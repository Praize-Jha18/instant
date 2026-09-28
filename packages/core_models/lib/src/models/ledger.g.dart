// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorLedgerEntry _$VendorLedgerEntryFromJson(Map<String, dynamic> json) =>
    _VendorLedgerEntry(
      id: readId(json, 'id') as String,
      vendorId: json['vendorId'] as String,
      subOrderId: json['subOrderId'] as String?,
      payoutId: json['payoutId'] as String?,
      type: $enumDecode(_$LedgerEntryTypeEnumMap, json['type']),
      amountKobo: (json['amountKobo'] as num).toInt(),
      balanceAfterKobo: (json['balanceAfterKobo'] as num?)?.toInt() ?? 0,
      note: json['note'] as String?,
      createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
      deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
      version: (json['version'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VendorLedgerEntryToJson(
  _VendorLedgerEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'vendorId': instance.vendorId,
  'subOrderId': ?instance.subOrderId,
  'payoutId': ?instance.payoutId,
  'type': _$LedgerEntryTypeEnumMap[instance.type]!,
  'amountKobo': instance.amountKobo,
  'balanceAfterKobo': instance.balanceAfterKobo,
  'note': ?instance.note,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$LedgerEntryTypeEnumMap = {
  LedgerEntryType.sale: 'sale',
  LedgerEntryType.commission: 'commission',
  LedgerEntryType.refund: 'refund',
  LedgerEntryType.payout: 'payout',
};

_Payout _$PayoutFromJson(Map<String, dynamic> json) => _Payout(
  id: readId(json, 'id') as String,
  vendorId: json['vendorId'] as String,
  amountKobo: (json['amountKobo'] as num).toInt(),
  status:
      $enumDecodeNullable(_$PayoutStatusEnumMap, json['status']) ??
      PayoutStatus.requested,
  method: json['method'] as String? ?? 'manual',
  reference: json['reference'] as String?,
  paidAt: const NullableDateTimeConverter().fromJson(json['paidAt']),
  vendorName: json['vendorName'] as String?,
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PayoutToJson(_Payout instance) => <String, dynamic>{
  'id': instance.id,
  'vendorId': instance.vendorId,
  'amountKobo': instance.amountKobo,
  'status': _$PayoutStatusEnumMap[instance.status]!,
  'method': instance.method,
  'reference': ?instance.reference,
  'paidAt': ?const NullableDateTimeConverter().toJson(instance.paidAt),
  'vendorName': ?instance.vendorName,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$PayoutStatusEnumMap = {
  PayoutStatus.requested: 'requested',
  PayoutStatus.paid: 'paid',
  PayoutStatus.failed: 'failed',
};
