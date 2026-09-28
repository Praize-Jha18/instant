// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubOrder _$SubOrderFromJson(Map<String, dynamic> json) => _SubOrder(
  id: readId(json, 'id') as String,
  orderId: json['orderId'] as String,
  vendorId: json['vendorId'] as String,
  customerId: json['customerId'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderItem>[],
  subtotalKobo: (json['subtotalKobo'] as num?)?.toInt() ?? 0,
  deliveryFeeKobo: (json['deliveryFeeKobo'] as num?)?.toInt() ?? 0,
  commissionKobo: (json['commissionKobo'] as num?)?.toInt() ?? 0,
  vendorNetKobo: (json['vendorNetKobo'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$SubOrderStatusEnumMap, json['status']) ??
      SubOrderStatus.awaitingPayment,
  deliveryId: json['deliveryId'] as String?,
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => TimelineEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TimelineEntry>[],
  orderNumber: json['orderNumber'] as String?,
  vendorName: json['vendorName'] as String?,
  vendorNameSnapshot: json['vendorNameSnapshot'] as String?,
  customerName: json['customerName'] as String?,
  deliveryOtp: json['deliveryOtp'] as String?,
  refundedKobo: (json['refundedKobo'] as num?)?.toInt() ?? 0,
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SubOrderToJson(_SubOrder instance) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'vendorId': instance.vendorId,
  'customerId': instance.customerId,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'subtotalKobo': instance.subtotalKobo,
  'deliveryFeeKobo': instance.deliveryFeeKobo,
  'commissionKobo': instance.commissionKobo,
  'vendorNetKobo': instance.vendorNetKobo,
  'status': _$SubOrderStatusEnumMap[instance.status]!,
  'deliveryId': ?instance.deliveryId,
  'timeline': instance.timeline.map((e) => e.toJson()).toList(),
  'orderNumber': ?instance.orderNumber,
  'vendorName': ?instance.vendorName,
  'vendorNameSnapshot': ?instance.vendorNameSnapshot,
  'customerName': ?instance.customerName,
  'deliveryOtp': ?instance.deliveryOtp,
  'refundedKobo': instance.refundedKobo,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$SubOrderStatusEnumMap = {
  SubOrderStatus.awaitingPayment: 'awaiting_payment',
  SubOrderStatus.placed: 'placed',
  SubOrderStatus.accepted: 'accepted',
  SubOrderStatus.preparing: 'preparing',
  SubOrderStatus.ready: 'ready',
  SubOrderStatus.outForDelivery: 'out_for_delivery',
  SubOrderStatus.delivered: 'delivered',
  SubOrderStatus.cancelled: 'cancelled',
};
