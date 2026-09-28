// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: readId(json, 'id') as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String?,
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UserRoleEnumMap, e))
          .toList() ??
      const <UserRole>[],
  vendorId: json['vendorId'] as String?,
  avatarImageId: json['avatarImageId'] as String?,
  status:
      $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
      UserStatus.active,
  createdAt: const NullableDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deletedAt']),
  version: (json['version'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'phone': ?instance.phone,
  'roles': instance.roles.map((e) => _$UserRoleEnumMap[e]!).toList(),
  'vendorId': ?instance.vendorId,
  'avatarImageId': ?instance.avatarImageId,
  'status': _$UserStatusEnumMap[instance.status]!,
  'createdAt': ?const NullableDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': ?const NullableDateTimeConverter().toJson(instance.deletedAt),
  'version': instance.version,
};

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.rider: 'rider',
  UserRole.vendorOwner: 'vendor_owner',
  UserRole.vendorStaff: 'vendor_staff',
  UserRole.admin: 'admin',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.suspended: 'suspended',
};
