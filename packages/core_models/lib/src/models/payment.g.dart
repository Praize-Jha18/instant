// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: readId(json, 'id') as String,
  orderId: json['orderId'] as String,
  provider: json['provider'] as String? ?? 'stripe',
  providerRef: json['providerRef'] as String?,
  amountKobo: (json['amountKobo'] as num).toInt(),
  currency: json['currency'] as String? ?? 'NGN',
  status:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ??
      PaymentStatus.pending,
  clientSecret: json['clientSecret'] as String?,
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'provider': instance.provider,
  'providerRef': ?instance.providerRef,
  'amountKobo': instance.amountKobo,
  'currency': instance.currency,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'clientSecret': ?instance.clientSecret,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.partiallyRefunded: 'partially_refunded',
};
