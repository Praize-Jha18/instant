// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: readId(json, 'id') as String,
  customerId: json['customerId'] as String,
  orderNumber: json['orderNumber'] as String,
  subOrderIds:
      (json['subOrderIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  addressSnapshot: json['addressSnapshot'] == null
      ? null
      : AddressSnapshot.fromJson(
          json['addressSnapshot'] as Map<String, dynamic>,
        ),
  subtotalKobo: (json['subtotalKobo'] as num?)?.toInt() ?? 0,
  deliveryTotalKobo: (json['deliveryTotalKobo'] as num?)?.toInt() ?? 0,
  totalKobo: (json['totalKobo'] as num?)?.toInt() ?? 0,
  currency: json['currency'] as String? ?? 'NGN',
  paymentStatus:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
      PaymentStatus.pending,
  paymentId: json['paymentId'] as String?,
  placedAt: const NullableDateTimeConverter().fromJson(json['placedAt']),
  expiresAt: const NullableDateTimeConverter().fromJson(json['expiresAt']),
  subOrders:
      (json['subOrders'] as List<dynamic>?)
          ?.map((e) => SubOrder.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SubOrder>[],
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'customerId': instance.customerId,
  'orderNumber': instance.orderNumber,
  'subOrderIds': instance.subOrderIds,
  'addressSnapshot': ?instance.addressSnapshot?.toJson(),
  'subtotalKobo': instance.subtotalKobo,
  'deliveryTotalKobo': instance.deliveryTotalKobo,
  'totalKobo': instance.totalKobo,
  'currency': instance.currency,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'paymentId': ?instance.paymentId,
  'placedAt': ?const NullableDateTimeConverter().toJson(instance.placedAt),
  'expiresAt': ?const NullableDateTimeConverter().toJson(instance.expiresAt),
  'subOrders': instance.subOrders.map((e) => e.toJson()).toList(),
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

_CheckoutPayload _$CheckoutPayloadFromJson(Map<String, dynamic> json) =>
    _CheckoutPayload(
      order: Order.fromJson(json['order'] as Map<String, dynamic>),
      subOrders:
          (json['subOrders'] as List<dynamic>?)
              ?.map((e) => SubOrder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SubOrder>[],
      paymentId: json['paymentId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      providerRef: json['providerRef'] as String?,
      provider: json['provider'] as String? ?? 'stripe',
      publishableKey: json['publishableKey'] as String?,
    );

Map<String, dynamic> _$CheckoutPayloadToJson(_CheckoutPayload instance) =>
    <String, dynamic>{
      'order': instance.order.toJson(),
      'subOrders': instance.subOrders.map((e) => e.toJson()).toList(),
      'paymentId': ?instance.paymentId,
      'clientSecret': ?instance.clientSecret,
      'providerRef': ?instance.providerRef,
      'provider': instance.provider,
      'publishableKey': ?instance.publishableKey,
    };
