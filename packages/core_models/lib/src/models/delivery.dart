import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';
import 'address.dart';
import 'timeline_entry.dart';

part 'delivery.freezed.dart';
part 'delivery.g.dart';

/// A delivery offer made to a rider (`deliveries.offeredTo[]`).
/// [response] is `accepted`, `declined` or null while pending.
@freezed
abstract class DeliveryOffer with _$DeliveryOffer {
  const DeliveryOffer._();

  const factory DeliveryOffer({
    required String riderId,
    @DateTimeConverter() required DateTime at,
    String? response,
    @NullableDateTimeConverter() DateTime? respondedAt,
  }) = _DeliveryOffer;

  factory DeliveryOffer.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOfferFromJson(json);

  bool get isPending => response == null;
  bool get accepted => response == 'accepted';
}

/// Proof of delivery (`deliveries.proof`). The OTP is only sent to the
/// customer; riders submit it via `POST /rider/deliveries/:id/deliver`.
@freezed
abstract class DeliveryProof with _$DeliveryProof {
  const factory DeliveryProof({
    String? photoImageId,
    String? otp,
    @NullableDateTimeConverter() DateTime? otpVerifiedAt,
  }) = _DeliveryProof;

  factory DeliveryProof.fromJson(Map<String, dynamic> json) =>
      _$DeliveryProofFromJson(json);
}

/// Drop-off point with the address captured at checkout.
@freezed
abstract class DropoffPoint with _$DropoffPoint {
  const factory DropoffPoint({
    required double lat,
    required double lng,
    AddressSnapshot? addressSnapshot,
  }) = _DropoffPoint;

  factory DropoffPoint.fromJson(Map<String, dynamic> json) =>
      _$DropoffPointFromJson(json);
}

/// Pickup point (vendor location).
@freezed
abstract class PickupPoint with _$PickupPoint {
  const factory PickupPoint({
    required double lat,
    required double lng,
    String? vendorName,
    String? line1,
  }) = _PickupPoint;

  factory PickupPoint.fromJson(Map<String, dynamic> json) =>
      _$PickupPointFromJson(json);
}

/// A delivery of one SubOrder (`deliveries` collection). Created when the
/// SubOrder reaches `ready`.
@freezed
abstract class Delivery with _$Delivery {
  const Delivery._();

  const factory Delivery({
    @JsonKey(readValue: readId) required String id,
    required String subOrderId,
    required String vendorId,
    String? orderId,
    String? riderId,
    @Default(DeliveryStatus.unassigned) DeliveryStatus status,
    PickupPoint? pickup,
    DropoffPoint? dropoff,
    @Default(<DeliveryOffer>[]) List<DeliveryOffer> offeredTo,
    DeliveryProof? proof,
    @Default(<TimelineEntry>[]) List<TimelineEntry> timeline,
    String? orderNumber,
    String? customerName,
    String? customerPhone,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Delivery;

  factory Delivery.fromJson(Map<String, dynamic> json) => _$DeliveryFromJson(json);

  /// The pending offer for [riderId], if any.
  DeliveryOffer? pendingOfferFor(String riderId) {
    for (final o in offeredTo) {
      if (o.riderId == riderId && o.isPending) return o;
    }
    return null;
  }
}
