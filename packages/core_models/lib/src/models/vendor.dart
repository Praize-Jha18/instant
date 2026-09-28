import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'vendor.freezed.dart';
part 'vendor.g.dart';

/// A vendor's physical address (`vendors.address`).
@freezed
abstract class VendorAddress with _$VendorAddress {
  const factory VendorAddress({
    required String line1,
    required String city,
    required String state,
    @Default('NG') String country,
    required double lat,
    required double lng,
  }) = _VendorAddress;

  factory VendorAddress.fromJson(Map<String, dynamic> json) =>
      _$VendorAddressFromJson(json);
}

/// Delivery fee configuration (`vendors.deliveryFee`). All amounts in kobo.
@freezed
abstract class DeliveryFeeConfig with _$DeliveryFeeConfig {
  const DeliveryFeeConfig._();

  const factory DeliveryFeeConfig({
    @Default(0) int baseKobo,
    @Default(0) int perKmKobo,
    int? freeAboveKobo,
  }) = _DeliveryFeeConfig;

  factory DeliveryFeeConfig.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFeeConfigFromJson(json);

  /// Client-side estimate mirroring the server formula:
  /// `base + perKm * distance`, free when subtotal ≥ freeAbove.
  int estimateKobo({required double distanceKm, required int subtotalKobo}) {
    final free = freeAboveKobo;
    if (free != null && subtotalKobo >= free) return 0;
    return baseKobo + (perKmKobo * distanceKm).round();
  }
}

/// One opening-hours entry. [weekday] follows `DateTime.weekday` (1 = Monday …
/// 7 = Sunday); [open]/[close] are `HH:mm` local time.
@freezed
abstract class OpeningHours with _$OpeningHours {
  const OpeningHours._();

  const factory OpeningHours({
    /// ISO weekday, 1 = Monday … 7 = Sunday. Read from `weekday`, or from the
    /// backend's stored `day` (0 = Sunday … 6 = Saturday).
    @JsonKey(readValue: readWeekday) required int weekday,
    @Default('09:00') String open,
    @Default('18:00') String close,
    @Default(false) bool closed,
  }) = _OpeningHours;

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  /// Backend form of the weekday: 0 = Sunday … 6 = Saturday.
  int get day => weekday == 7 ? 0 : weekday;

  /// JSON in the backend's stored shape (`day`), for PATCH /vendor.
  Map<String, dynamic> toBackendJson() =>
      {'day': day, 'open': open, 'close': close, 'closed': closed};
}

/// Reads `weekday` (1–7) or, failing that, converts the backend's `day` (0–6).
Object? readWeekday(Map<dynamic, dynamic> json, String key) {
  final w = json['weekday'];
  if (w != null) return w;
  final d = json['day'];
  if (d is num) return d.toInt() == 0 ? 7 : d.toInt();
  return null;
}

/// Bank details for manual payouts (`vendors.payout`).
@freezed
abstract class PayoutAccount with _$PayoutAccount {
  const factory PayoutAccount({
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) = _PayoutAccount;

  factory PayoutAccount.fromJson(Map<String, dynamic> json) =>
      _$PayoutAccountFromJson(json);
}

/// A vendor (`vendors` collection).
@freezed
abstract class Vendor with _$Vendor {
  const Vendor._();

  const factory Vendor({
    @JsonKey(readValue: readId) required String id,
    required String name,
    required String slug,
    String? description,
    String? logoImageId,
    String? coverImageId,
    required String ownerUserId,
    @Default(VendorStatus.pending) VendorStatus status,
    VendorAddress? address,
    DeliveryFeeConfig? deliveryFee,
    double? deliveryRadiusKm,
    @Default(<OpeningHours>[]) List<OpeningHours> openingHours,
    @Default(1000) int commissionBps,
    PayoutAccount? payout,
    double? distanceKm,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Vendor;

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  bool get isActive => status == VendorStatus.active;
}
