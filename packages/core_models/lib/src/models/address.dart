import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';

part 'address.freezed.dart';
part 'address.g.dart';

/// A customer delivery address (`addresses` collection). Client-owned, synced
/// via the outbox; the client may mint the [id] (uuid) before the server sees it.
@freezed
abstract class Address with _$Address {
  const Address._();

  const factory Address({
    @JsonKey(readValue: readId) required String id,
    required String userId,
    @Default('Home') String label,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required double lat,
    required double lng,
    String? phone,
    @Default(false) bool isDefault,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  /// Single-line rendering for lists.
  String get oneLine => [line1, if (line2 != null && line2!.isNotEmpty) line2, city, state]
      .join(', ');

  /// Immutable copy embedded in orders.
  AddressSnapshot toSnapshot() => AddressSnapshot(
        label: label,
        line1: line1,
        line2: line2,
        city: city,
        state: state,
        lat: lat,
        lng: lng,
        phone: phone,
      );
}

/// The address captured on an order at checkout (`orders.addressSnapshot`).
@freezed
abstract class AddressSnapshot with _$AddressSnapshot {
  const AddressSnapshot._();

  const factory AddressSnapshot({
    String? label,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required double lat,
    required double lng,
    String? phone,
  }) = _AddressSnapshot;

  factory AddressSnapshot.fromJson(Map<String, dynamic> json) =>
      _$AddressSnapshotFromJson(json);

  String get oneLine => [line1, if (line2 != null && line2!.isNotEmpty) line2, city, state]
      .join(', ');
}
