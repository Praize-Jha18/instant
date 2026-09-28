// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryOffer _$DeliveryOfferFromJson(Map<String, dynamic> json) =>
    _DeliveryOffer(
      riderId: json['riderId'] as String,
      at: const DateTimeConverter().fromJson(json['at'] as Object),
      response: json['response'] as String?,
      respondedAt: const NullableDateTimeConverter().fromJson(
        json['respondedAt'],
      ),
    );

Map<String, dynamic> _$DeliveryOfferToJson(_DeliveryOffer instance) =>
    <String, dynamic>{
      'riderId': instance.riderId,
      'at': const DateTimeConverter().toJson(instance.at),
      'response': ?instance.response,
      'respondedAt': ?const NullableDateTimeConverter().toJson(
        instance.respondedAt,
      ),
    };

_DeliveryProof _$DeliveryProofFromJson(Map<String, dynamic> json) =>
    _DeliveryProof(
      photoImageId: json['photoImageId'] as String?,
      otp: json['otp'] as String?,
      otpVerifiedAt: const NullableDateTimeConverter().fromJson(
        json['otpVerifiedAt'],
      ),
    );

Map<String, dynamic> _$DeliveryProofToJson(_DeliveryProof instance) =>
    <String, dynamic>{
      'photoImageId': ?instance.photoImageId,
      'otp': ?instance.otp,
      'otpVerifiedAt': ?const NullableDateTimeConverter().toJson(
        instance.otpVerifiedAt,
      ),
    };

_DropoffPoint _$DropoffPointFromJson(Map<String, dynamic> json) =>
    _DropoffPoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      addressSnapshot: json['addressSnapshot'] == null
          ? null
          : AddressSnapshot.fromJson(
              json['addressSnapshot'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$DropoffPointToJson(_DropoffPoint instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'addressSnapshot': ?instance.addressSnapshot?.toJson(),
    };

_PickupPoint _$PickupPointFromJson(Map<String, dynamic> json) => _PickupPoint(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  vendorName: json['vendorName'] as String?,
  line1: json['line1'] as String?,
);

Map<String, dynamic> _$PickupPointToJson(_PickupPoint instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'vendorName': ?instance.vendorName,
      'line1': ?instance.line1,
    };

_Delivery _$DeliveryFromJson(Map<String, dynamic> json) => _Delivery(
  id: readId(json, 'id') as String,
  subOrderId: json['subOrderId'] as String,
  vendorId: json['vendorId'] as String,
  orderId: json['orderId'] as String?,
  riderId: json['riderId'] as String?,
  status:
      $enumDecodeNullable(_$DeliveryStatusEnumMap, json['status']) ??
      DeliveryStatus.unassigned,
  pickup: json['pickup'] == null
      ? null
      : PickupPoint.fromJson(json['pickup'] as Map<String, dynamic>),
  dropoff: json['dropoff'] == null
      ? null
      : DropoffPoint.fromJson(json['dropoff'] as Map<String, dynamic>),
  offeredTo:
      (json['offeredTo'] as List<dynamic>?)
          ?.map((e) => DeliveryOffer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DeliveryOffer>[],
  proof: json['proof'] == null
      ? null
      : DeliveryProof.fromJson(json['proof'] as Map<String, dynamic>),
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => TimelineEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TimelineEntry>[],
  orderNumber: json['orderNumber'] as String?,
  customerName: json['customerName'] as String?,
  customerPhone: json['customerPhone'] as String?,
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DeliveryToJson(_Delivery instance) => <String, dynamic>{
  'id': instance.id,
  'subOrderId': instance.subOrderId,
  'vendorId': instance.vendorId,
  'orderId': ?instance.orderId,
  'riderId': ?instance.riderId,
  'status': _$DeliveryStatusEnumMap[instance.status]!,
  'pickup': ?instance.pickup?.toJson(),
  'dropoff': ?instance.dropoff?.toJson(),
  'offeredTo': instance.offeredTo.map((e) => e.toJson()).toList(),
  'proof': ?instance.proof?.toJson(),
  'timeline': instance.timeline.map((e) => e.toJson()).toList(),
  'orderNumber': ?instance.orderNumber,
  'customerName': ?instance.customerName,
  'customerPhone': ?instance.customerPhone,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.unassigned: 'unassigned',
  DeliveryStatus.offered: 'offered',
  DeliveryStatus.accepted: 'accepted',
  DeliveryStatus.pickedUp: 'picked_up',
  DeliveryStatus.delivered: 'delivered',
  DeliveryStatus.failed: 'failed',
};
