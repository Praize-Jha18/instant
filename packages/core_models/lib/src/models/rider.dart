import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'rider.freezed.dart';
part 'rider.g.dart';

/// A rider identity document (`riderProfiles.documents[]`).
@freezed
abstract class RiderDocument with _$RiderDocument {
  const factory RiderDocument({
    required String type,
    required String imageId,
  }) = _RiderDocument;

  factory RiderDocument.fromJson(Map<String, dynamic> json) =>
      _$RiderDocumentFromJson(json);
}

/// The rider's user summary embedded by `GET /vendor/riders`.
@freezed
abstract class RiderUserSummary with _$RiderUserSummary {
  const factory RiderUserSummary({
    @JsonKey(readValue: readId) required String id,
    required String fullName,
    String? phone,
    String? email,
  }) = _RiderUserSummary;

  factory RiderUserSummary.fromJson(Map<String, dynamic> json) =>
      _$RiderUserSummaryFromJson(json);
}

/// Last known position embedded by `GET /vendor/riders`.
@freezed
abstract class RiderLastLocation with _$RiderLastLocation {
  const factory RiderLastLocation({
    required double lat,
    required double lng,
    double? heading,
    double? speed,
    @DateTimeConverter() required DateTime at,
  }) = _RiderLastLocation;

  factory RiderLastLocation.fromJson(Map<String, dynamic> json) =>
      _$RiderLastLocationFromJson(json);
}

/// A vendor's rider (`riderProfiles` collection).
@freezed
abstract class RiderProfile with _$RiderProfile {
  const RiderProfile._();

  const factory RiderProfile({
    @JsonKey(readValue: readId) required String id,
    required String userId,
    required String vendorId,
    @Default(RiderStatus.pending) RiderStatus status,
    String? vehicleType,
    String? plateNumber,
    @Default(<RiderDocument>[]) List<RiderDocument> documents,
    @Default(false) bool isOnline,
    @NullableDateTimeConverter() DateTime? lastSeenAt,
    String? currentDeliveryId,
    String? fullName,
    String? phone,
    String? avatarImageId,
    /// Present on `GET /vendor/riders` responses.
    RiderUserSummary? user,
    /// Present on `GET /vendor/riders` responses.
    RiderLastLocation? lastLocation,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _RiderProfile;

  factory RiderProfile.fromJson(Map<String, dynamic> json) =>
      _$RiderProfileFromJson(json);

  bool get isAvailable =>
      status == RiderStatus.active && isOnline && currentDeliveryId == null;

  /// Display name from the embedded user summary or the flattened field.
  String? get displayName => user?.fullName ?? fullName;

  /// Phone from the embedded user summary or the flattened field.
  String? get displayPhone => user?.phone ?? phone;
}

/// A rider GPS sample (`riderLocations` collection, TTL 24 h).
@freezed
abstract class RiderLocation with _$RiderLocation {
  const factory RiderLocation({
    @JsonKey(readValue: readId) String? id,
    required String riderId,
    String? vendorId,
    String? deliveryId,
    required double lat,
    required double lng,
    double? heading,
    double? speed,
    @DateTimeConverter() required DateTime at,
  }) = _RiderLocation;

  factory RiderLocation.fromJson(Map<String, dynamic> json) =>
      _$RiderLocationFromJson(json);
}
