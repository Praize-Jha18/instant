import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';
import 'pending_proof_queue.dart';

/// Result of [DeliveryActions.deliver].
sealed class DeliverOutcome {
  const DeliverOutcome();
}

/// The server accepted the proof.
final class Delivered extends DeliverOutcome {
  const Delivered(this.delivery);
  final Delivery delivery;
}

/// Offline: the proof is stored locally and will be submitted automatically.
final class ProofQueued extends DeliverOutcome {
  const ProofQueued();
}

/// Rider actions on deliveries. Respond/pickup are online-only per §7; deliver
/// falls back to the local proof queue when offline.
class DeliveryActions {
  DeliveryActions({required this.api, required this.store, required this.proofs});

  final ApiClient api;
  final LocalStore store;
  final PendingProofQueue proofs;

  Future<Delivery> respond(String deliveryId, {required bool accept}) async {
    final d = await api.rider.respond(deliveryId, accept: accept);
    await store.upsert(Collections.deliveries, d);
    return d;
  }

  Future<Delivery> pickup(String deliveryId) async {
    final d = await api.rider.pickup(deliveryId);
    await store.upsert(Collections.deliveries, d);
    return d;
  }

  Future<DeliverOutcome> deliver(
    String deliveryId, {
    String? otp,
    Uint8List? photoBytes,
    String photoContentType = 'image/jpeg',
  }) async {
    try {
      final d = await api.rider.deliver(
        deliveryId,
        otp: otp,
        photoBytes: photoBytes,
        photoContentType: photoContentType,
      );
      await store.upsert(Collections.deliveries, d);
      await proofs.discard(deliveryId);
      return Delivered(d);
    } on ApiException catch (e) {
      if (!e.isOffline) rethrow;
      await proofs.add(
        deliveryId: deliveryId,
        otp: otp,
        photoBytes: photoBytes,
        photoContentType: photoContentType,
      );
      return const ProofQueued();
    }
  }
}

final deliveryActionsProvider = Provider<DeliveryActions>(
  (ref) => DeliveryActions(
    api: ref.watch(apiClientProvider),
    store: ref.watch(localStoreProvider),
    proofs: ref.watch(pendingProofQueueProvider),
  ),
);
