// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorAddress _$VendorAddressFromJson(Map<String, dynamic> json) =>
    _VendorAddress(
      line1: json['line1'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String? ?? 'NG',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$VendorAddressToJson(_VendorAddress instance) =>
    <String, dynamic>{
      'line1': instance.line1,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_DeliveryFeeConfig _$DeliveryFeeConfigFromJson(Map<String, dynamic> json) =>
    _DeliveryFeeConfig(
      baseKobo: (json['baseKobo'] as num?)?.toInt() ?? 0,
      perKmKobo: (json['perKmKobo'] as num?)?.toInt() ?? 0,
      freeAboveKobo: (json['freeAboveKobo'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DeliveryFeeConfigToJson(_DeliveryFeeConfig instance) =>
    <String, dynamic>{
      'baseKobo': instance.baseKobo,
      'perKmKobo': instance.perKmKobo,
      'freeAboveKobo': ?instance.freeAboveKobo,
    };

_OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) =>
    _OpeningHours(
      weekday: (readWeekday(json, 'weekday') as num).toInt(),
      open: json['open'] as String? ?? '09:00',
      close: json['close'] as String? ?? '18:00',
      closed: json['closed'] as bool? ?? false,
    );

Map<String, dynamic> _$OpeningHoursToJson(_OpeningHours instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'open': instance.open,
      'close': instance.close,
      'closed': instance.closed,
    };

_PayoutAccount _$PayoutAccountFromJson(Map<String, dynamic> json) =>
    _PayoutAccount(
      bankName: json['bankName'] as String,
      accountNumber: json['accountNumber'] as String,
      accountName: json['accountName'] as String,
    );

Map<String, dynamic> _$PayoutAccountToJson(_PayoutAccount instance) =>
    <String, dynamic>{
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
    };

_Vendor _$VendorFromJson(Map<String, dynamic> json) => _Vendor(
  id: readId(json, 'id') as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  logoImageId: json['logoImageId'] as String?,
  coverImageId: json['coverImageId'] as String?,
  ownerUserId: json['ownerUserId'] as String,
  status:
      $enumDecodeNullable(_$VendorStatusEnumMap, json['status']) ??
      VendorStatus.pending,
  address: json['address'] == null
      ? null
      : VendorAddress.fromJson(json['address'] as Map<String, dynamic>),
  deliveryFee: json['deliveryFee'] == null
      ? null
      : DeliveryFeeConfig.fromJson(json['deliveryFee'] as Map<String, dynamic>),
  deliveryRadiusKm: (json['deliveryRadiusKm'] as num?)?.toDouble(),
  openingHours:
      (json['openingHours'] as List<dynamic>?)
          ?.map((e) => OpeningHours.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OpeningHours>[],
  commissionBps: (json['commissionBps'] as num?)?.toInt() ?? 1000,
  payout: json['payout'] == null
      ? null
      : PayoutAccount.fromJson(json['payout'] as Map<String, dynamic>),
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$VendorToJson(_Vendor instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': ?instance.description,
  'logoImageId': ?instance.logoImageId,
  'coverImageId': ?instance.coverImageId,
  'ownerUserId': instance.ownerUserId,
  'status': _$VendorStatusEnumMap[instance.status]!,
  'address': ?instance.address?.toJson(),
  'deliveryFee': ?instance.deliveryFee?.toJson(),
  'deliveryRadiusKm': ?instance.deliveryRadiusKm,
  'openingHours': instance.openingHours.map((e) => e.toJson()).toList(),
  'commissionBps': instance.commissionBps,
  'payout': ?instance.payout?.toJson(),
  'distanceKm': ?instance.distanceKm,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$VendorStatusEnumMap = {
  VendorStatus.pending: 'pending',
  VendorStatus.active: 'active',
  VendorStatus.suspended: 'suspended',
};
