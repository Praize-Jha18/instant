import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// A platform user (`users` collection, client-safe subset: no passwordHash).
@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    @JsonKey(readValue: readId) required String id,
    required String email,
    required String fullName,
    String? phone,
    @Default(<UserRole>[]) List<UserRole> roles,
    String? vendorId,
    String? avatarImageId,
    @Default(UserStatus.active) UserStatus status,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  bool hasRole(UserRole role) => roles.contains(role);
  bool get isAdmin => hasRole(UserRole.admin);
  bool get isVendor => hasRole(UserRole.vendorOwner) || hasRole(UserRole.vendorStaff);
  bool get isRider => hasRole(UserRole.rider);
  bool get isCustomer => hasRole(UserRole.customer);
}
