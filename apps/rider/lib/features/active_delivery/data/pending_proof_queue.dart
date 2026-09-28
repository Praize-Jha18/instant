import 'dart:async';
import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';

/// A proof-of-delivery captured offline, waiting to be submitted.
@immutable
class PendingProof {
  const PendingProof({
    required this.deliveryId,
    this.otp,
    this.photoBase64,
    this.photoContentType = 'image/jpeg',
    required this.createdAt,
    this.attempts = 0,
    this.error,
  });

  factory PendingProof.fromJson(Map<String, dynamic> json) => PendingProof(
        deliveryId: (json['deliveryId'] ?? json['id']).toString(),
        otp: json['otp'] as String?,
        photoBase64: json['photoBase64'] as String?,
        photoContentType: json['photoContentType'] as String? ?? 'image/jpeg',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '')?.toUtc() ?? DateTime.now().toUtc(),
        attempts: (json['attempts'] as num?)?.toInt() ?? 0,
        error: json['error'] as String?,
      );

  final String deliveryId;
  final String? otp;
  final String? photoBase64;
  final String photoContentType;
  final DateTime createdAt;
  final int attempts;

  /// Set when the server definitively rejected the proof (e.g. wrong OTP).
  final String? error;

  bool get hasPhoto => photoBase64 != null && photoBase64!.isNotEmpty;
  bool get isFailed => error != null;
  Uint8List? get photoBytes => hasPhoto ? base64Decode(photoBase64!) : null;

  Map<String, dynamic> toJson() => {
        'id': deliveryId,
        'deliveryId': deliveryId,
        'otp': ?otp,
        'photoBase64': ?photoBase64,
        'photoContentType': photoContentType,
        'createdAt': createdAt.toIso8601String(),
        'attempts': attempts,
        'error': ?error,
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
      };

  PendingProof copyWith({int? attempts, String? error, bool clearError = false}) => PendingProof(
        deliveryId: deliveryId,
        otp: otp,
        photoBase64: photoBase64,
        photoContentType: photoContentType,
        createdAt: createdAt,
        attempts: attempts ?? this.attempts,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  bool operator ==(Object other) =>
      other is PendingProof &&
      other.deliveryId == deliveryId &&
      other.otp == otp &&
      other.photoBase64 == photoBase64 &&
      other.attempts == attempts &&
      other.error == error;

  @override
  int get hashCode => Object.hash(deliveryId, otp, photoBase64, attempts, error);
}

/// Local queue of proofs that could not be submitted (offline). `deliver` is
/// multipart and not a sync op, so it lives outside the outbox in the raw
/// `pendingProofs` collection and is flushed when connectivity returns.
class PendingProofQueue {
  PendingProofQueue({required this.store, required this.api});

  static const String collection = 'pendingProofs';

  final LocalStore store;
  final ApiClient api;

  StreamSubscription<SyncStatus>? _statusSub;
  StreamSubscription<RealtimeConnectionState>? _rtSub;
  Future<void>? _inFlight;
  bool _wasOffline = false;

  Future<void> add({
    required String deliveryId,
    String? otp,
    Uint8List? photoBytes,
    String photoContentType = 'image/jpeg',
  }) async {
    final proof = PendingProof(
      deliveryId: deliveryId,
      otp: otp,
      photoBase64: photoBytes == null ? null : base64Encode(photoBytes),
      photoContentType: photoContentType,
      createdAt: DateTime.now().toUtc(),
    );
    await store.upsertJson(collection, proof.toJson());
  }

  Stream<List<PendingProof>> watch() => store
      .watchAll<Map<String, dynamic>>(collection)
      .map((docs) => docs.map(PendingProof.fromJson).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt)));

  Stream<PendingProof?> watchFor(String deliveryId) =>
      store.watchById<Map<String, dynamic>>(collection, deliveryId).map((d) => d == null ? null : PendingProof.fromJson(d));

  Future<List<PendingProof>> all() async =>
      (await store.getAll<Map<String, dynamic>>(collection)).map(PendingProof.fromJson).toList();

  Future<void> discard(String deliveryId) => store.delete(collection, deliveryId);

  /// Clears the error flag and tries again right away.
  Future<void> retry(String deliveryId) async {
    final raw = await store.getById<Map<String, dynamic>>(collection, deliveryId);
    if (raw == null) return;
    await store.upsertJson(collection, PendingProof.fromJson(raw).copyWith(clearError: true).toJson());
    await flush();
  }

  /// Submits every queued proof (single-flight). Stops at the first offline
  /// error; definitive rejections are recorded on the proof or drop it when
  /// the delivery is already settled.
  Future<void> flush() {
    final running = _inFlight;
    if (running != null) return running;
    final f = _flush().whenComplete(() => _inFlight = null);
    _inFlight = f;
    return f;
  }

  Future<void> _flush() async {
    final proofs = (await all()).where((p) => !p.isFailed).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    for (final proof in proofs) {
      try {
        final delivery = await api.rider.deliver(
          proof.deliveryId,
          otp: proof.otp,
          photoBytes: proof.photoBytes,
          photoContentType: proof.photoContentType,
        );
        await store.upsert(Collections.deliveries, delivery);
        await store.delete(collection, proof.deliveryId);
      } on ApiException catch (e) {
        if (e.isOffline) return; // try again on the next reconnect
        if (e is ConflictException || e is NotFoundException) {
          // Already delivered / gone: nothing left to prove.
          await store.delete(collection, proof.deliveryId);
          continue;
        }
        if (e.isUnauthorized) return;
        await store.upsertJson(
          collection,
          proof.copyWith(attempts: proof.attempts + 1, error: e.message.isEmpty ? e.code : e.message).toJson(),
        );
      } catch (e) {
        await store.upsertJson(collection, proof.copyWith(attempts: proof.attempts + 1, error: e.toString()).toJson());
      }
    }
  }

  /// Flushes whenever the engine comes back online or the socket reconnects.
  void bind({required SyncEngine engine, RealtimeClient? realtime}) {
    unbind();
    _wasOffline = engine.currentStatus.isOffline;
    _statusSub = engine.status.listen((s) {
      final nowOnline = !s.isOffline;
      if (nowOnline && (_wasOffline || s.phase == SyncPhase.idle)) unawaited(flush());
      _wasOffline = s.isOffline;
    });
    _rtSub = realtime?.connectionState.listen((s) {
      if (s == RealtimeConnectionState.connected) unawaited(flush());
    });
    unawaited(flush());
  }

  void unbind() {
    _statusSub?.cancel();
    _rtSub?.cancel();
    _statusSub = null;
    _rtSub = null;
  }
}

final pendingProofQueueProvider = Provider<PendingProofQueue>((ref) {
  final q = PendingProofQueue(store: ref.watch(localStoreProvider), api: ref.watch(apiClientProvider));
  ref.onDispose(q.unbind);
  return q;
});

/// Pending proof for one delivery (null when none).
final pendingProofProvider = StreamProvider.family<PendingProof?, String>(
  (ref, deliveryId) => ref.watch(pendingProofQueueProvider).watchFor(deliveryId),
);

/// All queued proofs (Profile shows a count).
final pendingProofsProvider = StreamProvider<List<PendingProof>>(
  (ref) => ref.watch(pendingProofQueueProvider).watch(),
);
