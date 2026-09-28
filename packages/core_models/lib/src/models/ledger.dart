import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'ledger.freezed.dart';
part 'ledger.g.dart';

/// One row of a vendor's earnings ledger (`vendorLedger` collection).
/// [amountKobo] is signed: sales positive, commission/refund/payout negative.
@freezed
abstract class VendorLedgerEntry with _$VendorLedgerEntry {
  const factory VendorLedgerEntry({
    @JsonKey(readValue: readId) required String id,
    required String vendorId,
    String? subOrderId,
    String? payoutId,
    required LedgerEntryType type,
    required int amountKobo,
    @Default(0) int balanceAfterKobo,
    String? note,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _VendorLedgerEntry;

  factory VendorLedgerEntry.fromJson(Map<String, dynamic> json) =>
      _$VendorLedgerEntryFromJson(json);
}

/// A vendor payout request (`payouts` collection). Paid manually by admin.
@freezed
abstract class Payout with _$Payout {
  const factory Payout({
    @JsonKey(readValue: readId) required String id,
    required String vendorId,
    required int amountKobo,
    @Default(PayoutStatus.requested) PayoutStatus status,
    @Default('manual') String method,
    String? reference,
    @NullableDateTimeConverter() DateTime? paidAt,
    String? vendorName,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Payout;

  factory Payout.fromJson(Map<String, dynamic> json) => _$PayoutFromJson(json);
}
