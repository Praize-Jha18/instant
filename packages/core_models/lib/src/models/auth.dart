import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/enums.dart';
import 'user.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

/// Access + refresh token pair (§3).
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);
}

/// The signed-in identity as the apps see it: the JWT claims
/// (`sub`, `roles`, `vendorId?`) plus display fields. Built from [User].
@freezed
abstract class AuthUser with _$AuthUser {
  const AuthUser._();

  const factory AuthUser({
    required String id,
    required String email,
    required String fullName,
    @Default(<UserRole>[]) List<UserRole> roles,
    String? vendorId,
    String? avatarImageId,
    String? phone,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

  factory AuthUser.fromUser(User user) => AuthUser(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        roles: user.roles,
        vendorId: user.vendorId,
        avatarImageId: user.avatarImageId,
        phone: user.phone,
      );

  bool hasRole(UserRole role) => roles.contains(role);
  bool get isAdmin => hasRole(UserRole.admin);
  bool get isVendor => hasRole(UserRole.vendorOwner) || hasRole(UserRole.vendorStaff);
  bool get isRider => hasRole(UserRole.rider);
}

/// Response of `POST /auth/login`, `POST /auth/register` and
/// `POST /auth/refresh`: `{ accessToken, refreshToken, user }`.
@freezed
abstract class AuthResponse with _$AuthResponse {
  const AuthResponse._();

  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    User? user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  AuthTokens get tokens =>
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}
