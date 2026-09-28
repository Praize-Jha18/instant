// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubOrderTracking _$SubOrderTrackingFromJson(Map<String, dynamic> json) =>
    _SubOrderTracking(
      subOrderId: json['subOrderId'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String?,
      status: $enumDecode(_$SubOrderStatusEnumMap, json['status']),
      deliveryId: json['deliveryId'] as String?,
      deliveryStatus: $enumDecodeNullable(
        _$DeliveryStatusEnumMap,
        json['deliveryStatus'],
      ),
      riderId: json['riderId'] as String?,
      riderName: json['riderName'] as String?,
      riderPhone: json['riderPhone'] as String?,
      riderLocation: json['riderLocation'] == null
          ? null
          : RiderLocation.fromJson(
              json['riderLocation'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SubOrderTrackingToJson(_SubOrderTracking instance) =>
    <String, dynamic>{
      'subOrderId': instance.subOrderId,
      'vendorId': instance.vendorId,
      'vendorName': ?instance.vendorName,
      'status': _$SubOrderStatusEnumMap[instance.status]!,
      'deliveryId': ?instance.deliveryId,
      'deliveryStatus': ?_$DeliveryStatusEnumMap[instance.deliveryStatus],
      'riderId': ?instance.riderId,
      'riderName': ?instance.riderName,
      'riderPhone': ?instance.riderPhone,
      'riderLocation': ?instance.riderLocation?.toJson(),
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

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.unassigned: 'unassigned',
  DeliveryStatus.offered: 'offered',
  DeliveryStatus.accepted: 'accepted',
  DeliveryStatus.pickedUp: 'picked_up',
  DeliveryStatus.delivered: 'delivered',
  DeliveryStatus.failed: 'failed',
};

_OrderTracking _$OrderTrackingFromJson(Map<String, dynamic> json) =>
    _OrderTracking(
      orderId: json['orderId'] as String,
      subOrders:
          (json['subOrders'] as List<dynamic>?)
              ?.map((e) => SubOrderTracking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SubOrderTracking>[],
    );

Map<String, dynamic> _$OrderTrackingToJson(_OrderTracking instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'subOrders': instance.subOrders.map((e) => e.toJson()).toList(),
    };
