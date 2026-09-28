// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterRequest {

 String get email; String get password; String get fullName; String? get phone; UserRole get role; String? get vendorId; String? get vendorName; String? get deviceId;
/// Create a copy of RegisterRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterRequestCopyWith<RegisterRequest> get copyWith => _$RegisterRequestCopyWithImpl<RegisterRequest>(this as RegisterRequest, _$identity);

  /// Serializes this RegisterRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password,fullName,phone,role,vendorId,vendorName,deviceId);

@override
String toString() {
  return 'RegisterRequest(email: $email, password: $password, fullName: $fullName, phone: $phone, role: $role, vendorId: $vendorId, vendorName: $vendorName, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $RegisterRequestCopyWith<$Res>  {
  factory $RegisterRequestCopyWith(RegisterRequest value, $Res Function(RegisterRequest) _then) = _$RegisterRequestCopyWithImpl;
@useResult
$Res call({
 String email, String password, String fullName, String? phone, UserRole role, String? vendorId, String? vendorName, String? deviceId
});




}
/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._self, this._then);

  final RegisterRequest _self;
  final $Res Function(RegisterRequest) _then;

/// Create a copy of RegisterRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? fullName = null,Object? phone = freezed,Object? role = null,Object? vendorId = freezed,Object? vendorName = freezed,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterRequest].
extension RegisterRequestPatterns on RegisterRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password,  String fullName,  String? phone,  UserRole role,  String? vendorId,  String? vendorName,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterRequest() when $default != null:
return $default(_that.email,_that.password,_that.fullName,_that.phone,_that.role,_that.vendorId,_that.vendorName,_that.deviceId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password,  String fullName,  String? phone,  UserRole role,  String? vendorId,  String? vendorName,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _RegisterRequest():
return $default(_that.email,_that.password,_that.fullName,_that.phone,_that.role,_that.vendorId,_that.vendorName,_that.deviceId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password,  String fullName,  String? phone,  UserRole role,  String? vendorId,  String? vendorName,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _RegisterRequest() when $default != null:
return $default(_that.email,_that.password,_that.fullName,_that.phone,_that.role,_that.vendorId,_that.vendorName,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterRequest implements RegisterRequest {
  const _RegisterRequest({required this.email, required this.password, required this.fullName, this.phone, required this.role, this.vendorId, this.vendorName, this.deviceId});
  factory _RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);

@override final  String email;
@override final  String password;
@override final  String fullName;
@override final  String? phone;
@override final  UserRole role;
@override final  String? vendorId;
@override final  String? vendorName;
@override final  String? deviceId;

/// Create a copy of RegisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterRequestCopyWith<_RegisterRequest> get copyWith => __$RegisterRequestCopyWithImpl<_RegisterRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password,fullName,phone,role,vendorId,vendorName,deviceId);

@override
String toString() {
  return 'RegisterRequest(email: $email, password: $password, fullName: $fullName, phone: $phone, role: $role, vendorId: $vendorId, vendorName: $vendorName, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$RegisterRequestCopyWith<$Res> implements $RegisterRequestCopyWith<$Res> {
  factory _$RegisterRequestCopyWith(_RegisterRequest value, $Res Function(_RegisterRequest) _then) = __$RegisterRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, String password, String fullName, String? phone, UserRole role, String? vendorId, String? vendorName, String? deviceId
});




}
/// @nodoc
class __$RegisterRequestCopyWithImpl<$Res>
    implements _$RegisterRequestCopyWith<$Res> {
  __$RegisterRequestCopyWithImpl(this._self, this._then);

  final _RegisterRequest _self;
  final $Res Function(_RegisterRequest) _then;

/// Create a copy of RegisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? fullName = null,Object? phone = freezed,Object? role = null,Object? vendorId = freezed,Object? vendorName = freezed,Object? deviceId = freezed,}) {
  return _then(_RegisterRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LoginRequest {

 String get email; String get password; String? get deviceId;
/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequestCopyWith<LoginRequest> get copyWith => _$LoginRequestCopyWithImpl<LoginRequest>(this as LoginRequest, _$identity);

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password,deviceId);

@override
String toString() {
  return 'LoginRequest(email: $email, password: $password, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $LoginRequestCopyWith<$Res>  {
  factory $LoginRequestCopyWith(LoginRequest value, $Res Function(LoginRequest) _then) = _$LoginRequestCopyWithImpl;
@useResult
$Res call({
 String email, String password, String? deviceId
});




}
/// @nodoc
class _$LoginRequestCopyWithImpl<$Res>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._self, this._then);

  final LoginRequest _self;
  final $Res Function(LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginRequest].
extension LoginRequestPatterns on LoginRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.email,_that.password,_that.deviceId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that.email,_that.password,_that.deviceId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.email,_that.password,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginRequest implements LoginRequest {
  const _LoginRequest({required this.email, required this.password, this.deviceId});
  factory _LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

@override final  String email;
@override final  String password;
@override final  String? deviceId;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginRequestCopyWith<_LoginRequest> get copyWith => __$LoginRequestCopyWithImpl<_LoginRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password,deviceId);

@override
String toString() {
  return 'LoginRequest(email: $email, password: $password, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$LoginRequestCopyWith<$Res> implements $LoginRequestCopyWith<$Res> {
  factory _$LoginRequestCopyWith(_LoginRequest value, $Res Function(_LoginRequest) _then) = __$LoginRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, String password, String? deviceId
});




}
/// @nodoc
class __$LoginRequestCopyWithImpl<$Res>
    implements _$LoginRequestCopyWith<$Res> {
  __$LoginRequestCopyWithImpl(this._self, this._then);

  final _LoginRequest _self;
  final $Res Function(_LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? deviceId = freezed,}) {
  return _then(_LoginRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RefreshTokenRequest {

 String get refreshToken; String? get deviceId;
/// Create a copy of RefreshTokenRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshTokenRequestCopyWith<RefreshTokenRequest> get copyWith => _$RefreshTokenRequestCopyWithImpl<RefreshTokenRequest>(this as RefreshTokenRequest, _$identity);

  /// Serializes this RefreshTokenRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshTokenRequest&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,refreshToken,deviceId);

@override
String toString() {
  return 'RefreshTokenRequest(refreshToken: $refreshToken, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $RefreshTokenRequestCopyWith<$Res>  {
  factory $RefreshTokenRequestCopyWith(RefreshTokenRequest value, $Res Function(RefreshTokenRequest) _then) = _$RefreshTokenRequestCopyWithImpl;
@useResult
$Res call({
 String refreshToken, String? deviceId
});




}
/// @nodoc
class _$RefreshTokenRequestCopyWithImpl<$Res>
    implements $RefreshTokenRequestCopyWith<$Res> {
  _$RefreshTokenRequestCopyWithImpl(this._self, this._then);

  final RefreshTokenRequest _self;
  final $Res Function(RefreshTokenRequest) _then;

/// Create a copy of RefreshTokenRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refreshToken = null,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RefreshTokenRequest].
extension RefreshTokenRequestPatterns on RefreshTokenRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefreshTokenRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefreshTokenRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefreshTokenRequest value)  $default,){
final _that = this;
switch (_that) {
case _RefreshTokenRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefreshTokenRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RefreshTokenRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String refreshToken,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefreshTokenRequest() when $default != null:
return $default(_that.refreshToken,_that.deviceId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String refreshToken,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _RefreshTokenRequest():
return $default(_that.refreshToken,_that.deviceId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String refreshToken,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _RefreshTokenRequest() when $default != null:
return $default(_that.refreshToken,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefreshTokenRequest implements RefreshTokenRequest {
  const _RefreshTokenRequest({required this.refreshToken, this.deviceId});
  factory _RefreshTokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestFromJson(json);

@override final  String refreshToken;
@override final  String? deviceId;

/// Create a copy of RefreshTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshTokenRequestCopyWith<_RefreshTokenRequest> get copyWith => __$RefreshTokenRequestCopyWithImpl<_RefreshTokenRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefreshTokenRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshTokenRequest&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,refreshToken,deviceId);

@override
String toString() {
  return 'RefreshTokenRequest(refreshToken: $refreshToken, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$RefreshTokenRequestCopyWith<$Res> implements $RefreshTokenRequestCopyWith<$Res> {
  factory _$RefreshTokenRequestCopyWith(_RefreshTokenRequest value, $Res Function(_RefreshTokenRequest) _then) = __$RefreshTokenRequestCopyWithImpl;
@override @useResult
$Res call({
 String refreshToken, String? deviceId
});




}
/// @nodoc
class __$RefreshTokenRequestCopyWithImpl<$Res>
    implements _$RefreshTokenRequestCopyWith<$Res> {
  __$RefreshTokenRequestCopyWithImpl(this._self, this._then);

  final _RefreshTokenRequest _self;
  final $Res Function(_RefreshTokenRequest) _then;

/// Create a copy of RefreshTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refreshToken = null,Object? deviceId = freezed,}) {
  return _then(_RefreshTokenRequest(
refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateOrderRequest {

 String get addressId; String? get note; String get paymentProvider;/// Idempotency key so a retried checkout does not create two orders.
 String? get idempotencyKey;
/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOrderRequestCopyWith<CreateOrderRequest> get copyWith => _$CreateOrderRequestCopyWithImpl<CreateOrderRequest>(this as CreateOrderRequest, _$identity);

  /// Serializes this CreateOrderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOrderRequest&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.note, note) || other.note == note)&&(identical(other.paymentProvider, paymentProvider) || other.paymentProvider == paymentProvider)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressId,note,paymentProvider,idempotencyKey);

@override
String toString() {
  return 'CreateOrderRequest(addressId: $addressId, note: $note, paymentProvider: $paymentProvider, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class $CreateOrderRequestCopyWith<$Res>  {
  factory $CreateOrderRequestCopyWith(CreateOrderRequest value, $Res Function(CreateOrderRequest) _then) = _$CreateOrderRequestCopyWithImpl;
@useResult
$Res call({
 String addressId, String? note, String paymentProvider, String? idempotencyKey
});




}
/// @nodoc
class _$CreateOrderRequestCopyWithImpl<$Res>
    implements $CreateOrderRequestCopyWith<$Res> {
  _$CreateOrderRequestCopyWithImpl(this._self, this._then);

  final CreateOrderRequest _self;
  final $Res Function(CreateOrderRequest) _then;

/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addressId = null,Object? note = freezed,Object? paymentProvider = null,Object? idempotencyKey = freezed,}) {
  return _then(_self.copyWith(
addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paymentProvider: null == paymentProvider ? _self.paymentProvider : paymentProvider // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOrderRequest].
extension CreateOrderRequestPatterns on CreateOrderRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOrderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOrderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateOrderRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOrderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String addressId,  String? note,  String paymentProvider,  String? idempotencyKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
return $default(_that.addressId,_that.note,_that.paymentProvider,_that.idempotencyKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String addressId,  String? note,  String paymentProvider,  String? idempotencyKey)  $default,) {final _that = this;
switch (_that) {
case _CreateOrderRequest():
return $default(_that.addressId,_that.note,_that.paymentProvider,_that.idempotencyKey);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String addressId,  String? note,  String paymentProvider,  String? idempotencyKey)?  $default,) {final _that = this;
switch (_that) {
case _CreateOrderRequest() when $default != null:
return $default(_that.addressId,_that.note,_that.paymentProvider,_that.idempotencyKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateOrderRequest implements CreateOrderRequest {
  const _CreateOrderRequest({required this.addressId, this.note, this.paymentProvider = 'stripe', this.idempotencyKey});
  factory _CreateOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderRequestFromJson(json);

@override final  String addressId;
@override final  String? note;
@override@JsonKey() final  String paymentProvider;
/// Idempotency key so a retried checkout does not create two orders.
@override final  String? idempotencyKey;

/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOrderRequestCopyWith<_CreateOrderRequest> get copyWith => __$CreateOrderRequestCopyWithImpl<_CreateOrderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateOrderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOrderRequest&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.note, note) || other.note == note)&&(identical(other.paymentProvider, paymentProvider) || other.paymentProvider == paymentProvider)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressId,note,paymentProvider,idempotencyKey);

@override
String toString() {
  return 'CreateOrderRequest(addressId: $addressId, note: $note, paymentProvider: $paymentProvider, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class _$CreateOrderRequestCopyWith<$Res> implements $CreateOrderRequestCopyWith<$Res> {
  factory _$CreateOrderRequestCopyWith(_CreateOrderRequest value, $Res Function(_CreateOrderRequest) _then) = __$CreateOrderRequestCopyWithImpl;
@override @useResult
$Res call({
 String addressId, String? note, String paymentProvider, String? idempotencyKey
});




}
/// @nodoc
class __$CreateOrderRequestCopyWithImpl<$Res>
    implements _$CreateOrderRequestCopyWith<$Res> {
  __$CreateOrderRequestCopyWithImpl(this._self, this._then);

  final _CreateOrderRequest _self;
  final $Res Function(_CreateOrderRequest) _then;

/// Create a copy of CreateOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addressId = null,Object? note = freezed,Object? paymentProvider = null,Object? idempotencyKey = freezed,}) {
  return _then(_CreateOrderRequest(
addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paymentProvider: null == paymentProvider ? _self.paymentProvider : paymentProvider // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StockAdjustRequest {

 String? get variantId; int get delta; InventoryReason get reason; String? get note;
/// Create a copy of StockAdjustRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockAdjustRequestCopyWith<StockAdjustRequest> get copyWith => _$StockAdjustRequestCopyWithImpl<StockAdjustRequest>(this as StockAdjustRequest, _$identity);

  /// Serializes this StockAdjustRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustRequest&&(identical(other.variantId, variantId) || other.variantId == variantId)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,variantId,delta,reason,note);

@override
String toString() {
  return 'StockAdjustRequest(variantId: $variantId, delta: $delta, reason: $reason, note: $note)';
}


}

/// @nodoc
abstract mixin class $StockAdjustRequestCopyWith<$Res>  {
  factory $StockAdjustRequestCopyWith(StockAdjustRequest value, $Res Function(StockAdjustRequest) _then) = _$StockAdjustRequestCopyWithImpl;
@useResult
$Res call({
 String? variantId, int delta, InventoryReason reason, String? note
});




}
/// @nodoc
class _$StockAdjustRequestCopyWithImpl<$Res>
    implements $StockAdjustRequestCopyWith<$Res> {
  _$StockAdjustRequestCopyWithImpl(this._self, this._then);

  final StockAdjustRequest _self;
  final $Res Function(StockAdjustRequest) _then;

/// Create a copy of StockAdjustRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? variantId = freezed,Object? delta = null,Object? reason = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
variantId: freezed == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String?,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as InventoryReason,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockAdjustRequest].
extension StockAdjustRequestPatterns on StockAdjustRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockAdjustRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockAdjustRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockAdjustRequest value)  $default,){
final _that = this;
switch (_that) {
case _StockAdjustRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockAdjustRequest value)?  $default,){
final _that = this;
switch (_that) {
case _StockAdjustRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? variantId,  int delta,  InventoryReason reason,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockAdjustRequest() when $default != null:
return $default(_that.variantId,_that.delta,_that.reason,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? variantId,  int delta,  InventoryReason reason,  String? note)  $default,) {final _that = this;
switch (_that) {
case _StockAdjustRequest():
return $default(_that.variantId,_that.delta,_that.reason,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? variantId,  int delta,  InventoryReason reason,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _StockAdjustRequest() when $default != null:
return $default(_that.variantId,_that.delta,_that.reason,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockAdjustRequest implements StockAdjustRequest {
  const _StockAdjustRequest({this.variantId, required this.delta, this.reason = InventoryReason.adjustment, this.note});
  factory _StockAdjustRequest.fromJson(Map<String, dynamic> json) => _$StockAdjustRequestFromJson(json);

@override final  String? variantId;
@override final  int delta;
@override@JsonKey() final  InventoryReason reason;
@override final  String? note;

/// Create a copy of StockAdjustRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockAdjustRequestCopyWith<_StockAdjustRequest> get copyWith => __$StockAdjustRequestCopyWithImpl<_StockAdjustRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockAdjustRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockAdjustRequest&&(identical(other.variantId, variantId) || other.variantId == variantId)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,variantId,delta,reason,note);

@override
String toString() {
  return 'StockAdjustRequest(variantId: $variantId, delta: $delta, reason: $reason, note: $note)';
}


}

/// @nodoc
abstract mixin class _$StockAdjustRequestCopyWith<$Res> implements $StockAdjustRequestCopyWith<$Res> {
  factory _$StockAdjustRequestCopyWith(_StockAdjustRequest value, $Res Function(_StockAdjustRequest) _then) = __$StockAdjustRequestCopyWithImpl;
@override @useResult
$Res call({
 String? variantId, int delta, InventoryReason reason, String? note
});




}
/// @nodoc
class __$StockAdjustRequestCopyWithImpl<$Res>
    implements _$StockAdjustRequestCopyWith<$Res> {
  __$StockAdjustRequestCopyWithImpl(this._self, this._then);

  final _StockAdjustRequest _self;
  final $Res Function(_StockAdjustRequest) _then;

/// Create a copy of StockAdjustRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? variantId = freezed,Object? delta = null,Object? reason = null,Object? note = freezed,}) {
  return _then(_StockAdjustRequest(
variantId: freezed == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String?,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as InventoryReason,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateSubOrderStatusRequest {

 SubOrderStatus get status; String? get note;
/// Create a copy of UpdateSubOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateSubOrderStatusRequestCopyWith<UpdateSubOrderStatusRequest> get copyWith => _$UpdateSubOrderStatusRequestCopyWithImpl<UpdateSubOrderStatusRequest>(this as UpdateSubOrderStatusRequest, _$identity);

  /// Serializes this UpdateSubOrderStatusRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateSubOrderStatusRequest&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,note);

@override
String toString() {
  return 'UpdateSubOrderStatusRequest(status: $status, note: $note)';
}


}

/// @nodoc
abstract mixin class $UpdateSubOrderStatusRequestCopyWith<$Res>  {
  factory $UpdateSubOrderStatusRequestCopyWith(UpdateSubOrderStatusRequest value, $Res Function(UpdateSubOrderStatusRequest) _then) = _$UpdateSubOrderStatusRequestCopyWithImpl;
@useResult
$Res call({
 SubOrderStatus status, String? note
});




}
/// @nodoc
class _$UpdateSubOrderStatusRequestCopyWithImpl<$Res>
    implements $UpdateSubOrderStatusRequestCopyWith<$Res> {
  _$UpdateSubOrderStatusRequestCopyWithImpl(this._self, this._then);

  final UpdateSubOrderStatusRequest _self;
  final $Res Function(UpdateSubOrderStatusRequest) _then;

/// Create a copy of UpdateSubOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubOrderStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateSubOrderStatusRequest].
extension UpdateSubOrderStatusRequestPatterns on UpdateSubOrderStatusRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateSubOrderStatusRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateSubOrderStatusRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateSubOrderStatusRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateSubOrderStatusRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateSubOrderStatusRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateSubOrderStatusRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SubOrderStatus status,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateSubOrderStatusRequest() when $default != null:
return $default(_that.status,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SubOrderStatus status,  String? note)  $default,) {final _that = this;
switch (_that) {
case _UpdateSubOrderStatusRequest():
return $default(_that.status,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SubOrderStatus status,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _UpdateSubOrderStatusRequest() when $default != null:
return $default(_that.status,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateSubOrderStatusRequest implements UpdateSubOrderStatusRequest {
  const _UpdateSubOrderStatusRequest({required this.status, this.note});
  factory _UpdateSubOrderStatusRequest.fromJson(Map<String, dynamic> json) => _$UpdateSubOrderStatusRequestFromJson(json);

@override final  SubOrderStatus status;
@override final  String? note;

/// Create a copy of UpdateSubOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSubOrderStatusRequestCopyWith<_UpdateSubOrderStatusRequest> get copyWith => __$UpdateSubOrderStatusRequestCopyWithImpl<_UpdateSubOrderStatusRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateSubOrderStatusRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSubOrderStatusRequest&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,note);

@override
String toString() {
  return 'UpdateSubOrderStatusRequest(status: $status, note: $note)';
}


}

/// @nodoc
abstract mixin class _$UpdateSubOrderStatusRequestCopyWith<$Res> implements $UpdateSubOrderStatusRequestCopyWith<$Res> {
  factory _$UpdateSubOrderStatusRequestCopyWith(_UpdateSubOrderStatusRequest value, $Res Function(_UpdateSubOrderStatusRequest) _then) = __$UpdateSubOrderStatusRequestCopyWithImpl;
@override @useResult
$Res call({
 SubOrderStatus status, String? note
});




}
/// @nodoc
class __$UpdateSubOrderStatusRequestCopyWithImpl<$Res>
    implements _$UpdateSubOrderStatusRequestCopyWith<$Res> {
  __$UpdateSubOrderStatusRequestCopyWithImpl(this._self, this._then);

  final _UpdateSubOrderStatusRequest _self;
  final $Res Function(_UpdateSubOrderStatusRequest) _then;

/// Create a copy of UpdateSubOrderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? note = freezed,}) {
  return _then(_UpdateSubOrderStatusRequest(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubOrderStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AssignDeliveryRequest {

 String get riderId;
/// Create a copy of AssignDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignDeliveryRequestCopyWith<AssignDeliveryRequest> get copyWith => _$AssignDeliveryRequestCopyWithImpl<AssignDeliveryRequest>(this as AssignDeliveryRequest, _$identity);

  /// Serializes this AssignDeliveryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignDeliveryRequest&&(identical(other.riderId, riderId) || other.riderId == riderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riderId);

@override
String toString() {
  return 'AssignDeliveryRequest(riderId: $riderId)';
}


}

/// @nodoc
abstract mixin class $AssignDeliveryRequestCopyWith<$Res>  {
  factory $AssignDeliveryRequestCopyWith(AssignDeliveryRequest value, $Res Function(AssignDeliveryRequest) _then) = _$AssignDeliveryRequestCopyWithImpl;
@useResult
$Res call({
 String riderId
});




}
/// @nodoc
class _$AssignDeliveryRequestCopyWithImpl<$Res>
    implements $AssignDeliveryRequestCopyWith<$Res> {
  _$AssignDeliveryRequestCopyWithImpl(this._self, this._then);

  final AssignDeliveryRequest _self;
  final $Res Function(AssignDeliveryRequest) _then;

/// Create a copy of AssignDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? riderId = null,}) {
  return _then(_self.copyWith(
riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignDeliveryRequest].
extension AssignDeliveryRequestPatterns on AssignDeliveryRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignDeliveryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignDeliveryRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignDeliveryRequest value)  $default,){
final _that = this;
switch (_that) {
case _AssignDeliveryRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignDeliveryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AssignDeliveryRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String riderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignDeliveryRequest() when $default != null:
return $default(_that.riderId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String riderId)  $default,) {final _that = this;
switch (_that) {
case _AssignDeliveryRequest():
return $default(_that.riderId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String riderId)?  $default,) {final _that = this;
switch (_that) {
case _AssignDeliveryRequest() when $default != null:
return $default(_that.riderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignDeliveryRequest implements AssignDeliveryRequest {
  const _AssignDeliveryRequest({required this.riderId});
  factory _AssignDeliveryRequest.fromJson(Map<String, dynamic> json) => _$AssignDeliveryRequestFromJson(json);

@override final  String riderId;

/// Create a copy of AssignDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignDeliveryRequestCopyWith<_AssignDeliveryRequest> get copyWith => __$AssignDeliveryRequestCopyWithImpl<_AssignDeliveryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignDeliveryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignDeliveryRequest&&(identical(other.riderId, riderId) || other.riderId == riderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riderId);

@override
String toString() {
  return 'AssignDeliveryRequest(riderId: $riderId)';
}


}

/// @nodoc
abstract mixin class _$AssignDeliveryRequestCopyWith<$Res> implements $AssignDeliveryRequestCopyWith<$Res> {
  factory _$AssignDeliveryRequestCopyWith(_AssignDeliveryRequest value, $Res Function(_AssignDeliveryRequest) _then) = __$AssignDeliveryRequestCopyWithImpl;
@override @useResult
$Res call({
 String riderId
});




}
/// @nodoc
class __$AssignDeliveryRequestCopyWithImpl<$Res>
    implements _$AssignDeliveryRequestCopyWith<$Res> {
  __$AssignDeliveryRequestCopyWithImpl(this._self, this._then);

  final _AssignDeliveryRequest _self;
  final $Res Function(_AssignDeliveryRequest) _then;

/// Create a copy of AssignDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? riderId = null,}) {
  return _then(_AssignDeliveryRequest(
riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RiderLocationUpdate {

 double get lat; double get lng; double? get heading; double? get speed;@DateTimeConverter() DateTime get at; String? get deliveryId;
/// Create a copy of RiderLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderLocationUpdateCopyWith<RiderLocationUpdate> get copyWith => _$RiderLocationUpdateCopyWithImpl<RiderLocationUpdate>(this as RiderLocationUpdate, _$identity);

  /// Serializes this RiderLocationUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderLocationUpdate&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.at, at) || other.at == at)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,heading,speed,at,deliveryId);

@override
String toString() {
  return 'RiderLocationUpdate(lat: $lat, lng: $lng, heading: $heading, speed: $speed, at: $at, deliveryId: $deliveryId)';
}


}

/// @nodoc
abstract mixin class $RiderLocationUpdateCopyWith<$Res>  {
  factory $RiderLocationUpdateCopyWith(RiderLocationUpdate value, $Res Function(RiderLocationUpdate) _then) = _$RiderLocationUpdateCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, double? heading, double? speed,@DateTimeConverter() DateTime at, String? deliveryId
});




}
/// @nodoc
class _$RiderLocationUpdateCopyWithImpl<$Res>
    implements $RiderLocationUpdateCopyWith<$Res> {
  _$RiderLocationUpdateCopyWithImpl(this._self, this._then);

  final RiderLocationUpdate _self;
  final $Res Function(RiderLocationUpdate) _then;

/// Create a copy of RiderLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? at = null,Object? deliveryId = freezed,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderLocationUpdate].
extension RiderLocationUpdatePatterns on RiderLocationUpdate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderLocationUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderLocationUpdate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderLocationUpdate value)  $default,){
final _that = this;
switch (_that) {
case _RiderLocationUpdate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderLocationUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _RiderLocationUpdate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at,  String? deliveryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderLocationUpdate() when $default != null:
return $default(_that.lat,_that.lng,_that.heading,_that.speed,_that.at,_that.deliveryId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at,  String? deliveryId)  $default,) {final _that = this;
switch (_that) {
case _RiderLocationUpdate():
return $default(_that.lat,_that.lng,_that.heading,_that.speed,_that.at,_that.deliveryId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at,  String? deliveryId)?  $default,) {final _that = this;
switch (_that) {
case _RiderLocationUpdate() when $default != null:
return $default(_that.lat,_that.lng,_that.heading,_that.speed,_that.at,_that.deliveryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderLocationUpdate implements RiderLocationUpdate {
  const _RiderLocationUpdate({required this.lat, required this.lng, this.heading, this.speed, @DateTimeConverter() required this.at, this.deliveryId});
  factory _RiderLocationUpdate.fromJson(Map<String, dynamic> json) => _$RiderLocationUpdateFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  double? heading;
@override final  double? speed;
@override@DateTimeConverter() final  DateTime at;
@override final  String? deliveryId;

/// Create a copy of RiderLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderLocationUpdateCopyWith<_RiderLocationUpdate> get copyWith => __$RiderLocationUpdateCopyWithImpl<_RiderLocationUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderLocationUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderLocationUpdate&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.at, at) || other.at == at)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,heading,speed,at,deliveryId);

@override
String toString() {
  return 'RiderLocationUpdate(lat: $lat, lng: $lng, heading: $heading, speed: $speed, at: $at, deliveryId: $deliveryId)';
}


}

/// @nodoc
abstract mixin class _$RiderLocationUpdateCopyWith<$Res> implements $RiderLocationUpdateCopyWith<$Res> {
  factory _$RiderLocationUpdateCopyWith(_RiderLocationUpdate value, $Res Function(_RiderLocationUpdate) _then) = __$RiderLocationUpdateCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, double? heading, double? speed,@DateTimeConverter() DateTime at, String? deliveryId
});




}
/// @nodoc
class __$RiderLocationUpdateCopyWithImpl<$Res>
    implements _$RiderLocationUpdateCopyWith<$Res> {
  __$RiderLocationUpdateCopyWithImpl(this._self, this._then);

  final _RiderLocationUpdate _self;
  final $Res Function(_RiderLocationUpdate) _then;

/// Create a copy of RiderLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? at = null,Object? deliveryId = freezed,}) {
  return _then(_RiderLocationUpdate(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateRiderProfileRequest {

 bool? get isOnline; String? get vehicleType; String? get plateNumber;
/// Create a copy of UpdateRiderProfileRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateRiderProfileRequestCopyWith<UpdateRiderProfileRequest> get copyWith => _$UpdateRiderProfileRequestCopyWithImpl<UpdateRiderProfileRequest>(this as UpdateRiderProfileRequest, _$identity);

  /// Serializes this UpdateRiderProfileRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateRiderProfileRequest&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOnline,vehicleType,plateNumber);

@override
String toString() {
  return 'UpdateRiderProfileRequest(isOnline: $isOnline, vehicleType: $vehicleType, plateNumber: $plateNumber)';
}


}

/// @nodoc
abstract mixin class $UpdateRiderProfileRequestCopyWith<$Res>  {
  factory $UpdateRiderProfileRequestCopyWith(UpdateRiderProfileRequest value, $Res Function(UpdateRiderProfileRequest) _then) = _$UpdateRiderProfileRequestCopyWithImpl;
@useResult
$Res call({
 bool? isOnline, String? vehicleType, String? plateNumber
});




}
/// @nodoc
class _$UpdateRiderProfileRequestCopyWithImpl<$Res>
    implements $UpdateRiderProfileRequestCopyWith<$Res> {
  _$UpdateRiderProfileRequestCopyWithImpl(this._self, this._then);

  final UpdateRiderProfileRequest _self;
  final $Res Function(UpdateRiderProfileRequest) _then;

/// Create a copy of UpdateRiderProfileRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOnline = freezed,Object? vehicleType = freezed,Object? plateNumber = freezed,}) {
  return _then(_self.copyWith(
isOnline: freezed == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool?,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateRiderProfileRequest].
extension UpdateRiderProfileRequestPatterns on UpdateRiderProfileRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateRiderProfileRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateRiderProfileRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateRiderProfileRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateRiderProfileRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateRiderProfileRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateRiderProfileRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isOnline,  String? vehicleType,  String? plateNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateRiderProfileRequest() when $default != null:
return $default(_that.isOnline,_that.vehicleType,_that.plateNumber);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isOnline,  String? vehicleType,  String? plateNumber)  $default,) {final _that = this;
switch (_that) {
case _UpdateRiderProfileRequest():
return $default(_that.isOnline,_that.vehicleType,_that.plateNumber);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isOnline,  String? vehicleType,  String? plateNumber)?  $default,) {final _that = this;
switch (_that) {
case _UpdateRiderProfileRequest() when $default != null:
return $default(_that.isOnline,_that.vehicleType,_that.plateNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateRiderProfileRequest implements UpdateRiderProfileRequest {
  const _UpdateRiderProfileRequest({this.isOnline, this.vehicleType, this.plateNumber});
  factory _UpdateRiderProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateRiderProfileRequestFromJson(json);

@override final  bool? isOnline;
@override final  String? vehicleType;
@override final  String? plateNumber;

/// Create a copy of UpdateRiderProfileRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateRiderProfileRequestCopyWith<_UpdateRiderProfileRequest> get copyWith => __$UpdateRiderProfileRequestCopyWithImpl<_UpdateRiderProfileRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateRiderProfileRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateRiderProfileRequest&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOnline,vehicleType,plateNumber);

@override
String toString() {
  return 'UpdateRiderProfileRequest(isOnline: $isOnline, vehicleType: $vehicleType, plateNumber: $plateNumber)';
}


}

/// @nodoc
abstract mixin class _$UpdateRiderProfileRequestCopyWith<$Res> implements $UpdateRiderProfileRequestCopyWith<$Res> {
  factory _$UpdateRiderProfileRequestCopyWith(_UpdateRiderProfileRequest value, $Res Function(_UpdateRiderProfileRequest) _then) = __$UpdateRiderProfileRequestCopyWithImpl;
@override @useResult
$Res call({
 bool? isOnline, String? vehicleType, String? plateNumber
});




}
/// @nodoc
class __$UpdateRiderProfileRequestCopyWithImpl<$Res>
    implements _$UpdateRiderProfileRequestCopyWith<$Res> {
  __$UpdateRiderProfileRequestCopyWithImpl(this._self, this._then);

  final _UpdateRiderProfileRequest _self;
  final $Res Function(_UpdateRiderProfileRequest) _then;

/// Create a copy of UpdateRiderProfileRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOnline = freezed,Object? vehicleType = freezed,Object? plateNumber = freezed,}) {
  return _then(_UpdateRiderProfileRequest(
isOnline: freezed == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool?,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RespondDeliveryRequest {

 bool get accept;
/// Create a copy of RespondDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RespondDeliveryRequestCopyWith<RespondDeliveryRequest> get copyWith => _$RespondDeliveryRequestCopyWithImpl<RespondDeliveryRequest>(this as RespondDeliveryRequest, _$identity);

  /// Serializes this RespondDeliveryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RespondDeliveryRequest&&(identical(other.accept, accept) || other.accept == accept));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accept);

@override
String toString() {
  return 'RespondDeliveryRequest(accept: $accept)';
}


}

/// @nodoc
abstract mixin class $RespondDeliveryRequestCopyWith<$Res>  {
  factory $RespondDeliveryRequestCopyWith(RespondDeliveryRequest value, $Res Function(RespondDeliveryRequest) _then) = _$RespondDeliveryRequestCopyWithImpl;
@useResult
$Res call({
 bool accept
});




}
/// @nodoc
class _$RespondDeliveryRequestCopyWithImpl<$Res>
    implements $RespondDeliveryRequestCopyWith<$Res> {
  _$RespondDeliveryRequestCopyWithImpl(this._self, this._then);

  final RespondDeliveryRequest _self;
  final $Res Function(RespondDeliveryRequest) _then;

/// Create a copy of RespondDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accept = null,}) {
  return _then(_self.copyWith(
accept: null == accept ? _self.accept : accept // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RespondDeliveryRequest].
extension RespondDeliveryRequestPatterns on RespondDeliveryRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RespondDeliveryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RespondDeliveryRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RespondDeliveryRequest value)  $default,){
final _that = this;
switch (_that) {
case _RespondDeliveryRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RespondDeliveryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RespondDeliveryRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool accept)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RespondDeliveryRequest() when $default != null:
return $default(_that.accept);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool accept)  $default,) {final _that = this;
switch (_that) {
case _RespondDeliveryRequest():
return $default(_that.accept);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool accept)?  $default,) {final _that = this;
switch (_that) {
case _RespondDeliveryRequest() when $default != null:
return $default(_that.accept);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RespondDeliveryRequest implements RespondDeliveryRequest {
  const _RespondDeliveryRequest({required this.accept});
  factory _RespondDeliveryRequest.fromJson(Map<String, dynamic> json) => _$RespondDeliveryRequestFromJson(json);

@override final  bool accept;

/// Create a copy of RespondDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RespondDeliveryRequestCopyWith<_RespondDeliveryRequest> get copyWith => __$RespondDeliveryRequestCopyWithImpl<_RespondDeliveryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RespondDeliveryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RespondDeliveryRequest&&(identical(other.accept, accept) || other.accept == accept));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accept);

@override
String toString() {
  return 'RespondDeliveryRequest(accept: $accept)';
}


}

/// @nodoc
abstract mixin class _$RespondDeliveryRequestCopyWith<$Res> implements $RespondDeliveryRequestCopyWith<$Res> {
  factory _$RespondDeliveryRequestCopyWith(_RespondDeliveryRequest value, $Res Function(_RespondDeliveryRequest) _then) = __$RespondDeliveryRequestCopyWithImpl;
@override @useResult
$Res call({
 bool accept
});




}
/// @nodoc
class __$RespondDeliveryRequestCopyWithImpl<$Res>
    implements _$RespondDeliveryRequestCopyWith<$Res> {
  __$RespondDeliveryRequestCopyWithImpl(this._self, this._then);

  final _RespondDeliveryRequest _self;
  final $Res Function(_RespondDeliveryRequest) _then;

/// Create a copy of RespondDeliveryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accept = null,}) {
  return _then(_RespondDeliveryRequest(
accept: null == accept ? _self.accept : accept // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DeliverRequest {

 String? get otp; String? get note;
/// Create a copy of DeliverRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliverRequestCopyWith<DeliverRequest> get copyWith => _$DeliverRequestCopyWithImpl<DeliverRequest>(this as DeliverRequest, _$identity);

  /// Serializes this DeliverRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliverRequest&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,otp,note);

@override
String toString() {
  return 'DeliverRequest(otp: $otp, note: $note)';
}


}

/// @nodoc
abstract mixin class $DeliverRequestCopyWith<$Res>  {
  factory $DeliverRequestCopyWith(DeliverRequest value, $Res Function(DeliverRequest) _then) = _$DeliverRequestCopyWithImpl;
@useResult
$Res call({
 String? otp, String? note
});




}
/// @nodoc
class _$DeliverRequestCopyWithImpl<$Res>
    implements $DeliverRequestCopyWith<$Res> {
  _$DeliverRequestCopyWithImpl(this._self, this._then);

  final DeliverRequest _self;
  final $Res Function(DeliverRequest) _then;

/// Create a copy of DeliverRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otp = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
otp: freezed == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliverRequest].
extension DeliverRequestPatterns on DeliverRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliverRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliverRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliverRequest value)  $default,){
final _that = this;
switch (_that) {
case _DeliverRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliverRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DeliverRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? otp,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliverRequest() when $default != null:
return $default(_that.otp,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? otp,  String? note)  $default,) {final _that = this;
switch (_that) {
case _DeliverRequest():
return $default(_that.otp,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? otp,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _DeliverRequest() when $default != null:
return $default(_that.otp,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliverRequest implements DeliverRequest {
  const _DeliverRequest({this.otp, this.note});
  factory _DeliverRequest.fromJson(Map<String, dynamic> json) => _$DeliverRequestFromJson(json);

@override final  String? otp;
@override final  String? note;

/// Create a copy of DeliverRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliverRequestCopyWith<_DeliverRequest> get copyWith => __$DeliverRequestCopyWithImpl<_DeliverRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliverRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliverRequest&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,otp,note);

@override
String toString() {
  return 'DeliverRequest(otp: $otp, note: $note)';
}


}

/// @nodoc
abstract mixin class _$DeliverRequestCopyWith<$Res> implements $DeliverRequestCopyWith<$Res> {
  factory _$DeliverRequestCopyWith(_DeliverRequest value, $Res Function(_DeliverRequest) _then) = __$DeliverRequestCopyWithImpl;
@override @useResult
$Res call({
 String? otp, String? note
});




}
/// @nodoc
class __$DeliverRequestCopyWithImpl<$Res>
    implements _$DeliverRequestCopyWith<$Res> {
  __$DeliverRequestCopyWithImpl(this._self, this._then);

  final _DeliverRequest _self;
  final $Res Function(_DeliverRequest) _then;

/// Create a copy of DeliverRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otp = freezed,Object? note = freezed,}) {
  return _then(_DeliverRequest(
otp: freezed == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RequestPayoutRequest {

 int? get amountKobo; String? get note;
/// Create a copy of RequestPayoutRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestPayoutRequestCopyWith<RequestPayoutRequest> get copyWith => _$RequestPayoutRequestCopyWithImpl<RequestPayoutRequest>(this as RequestPayoutRequest, _$identity);

  /// Serializes this RequestPayoutRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestPayoutRequest&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amountKobo,note);

@override
String toString() {
  return 'RequestPayoutRequest(amountKobo: $amountKobo, note: $note)';
}


}

/// @nodoc
abstract mixin class $RequestPayoutRequestCopyWith<$Res>  {
  factory $RequestPayoutRequestCopyWith(RequestPayoutRequest value, $Res Function(RequestPayoutRequest) _then) = _$RequestPayoutRequestCopyWithImpl;
@useResult
$Res call({
 int? amountKobo, String? note
});




}
/// @nodoc
class _$RequestPayoutRequestCopyWithImpl<$Res>
    implements $RequestPayoutRequestCopyWith<$Res> {
  _$RequestPayoutRequestCopyWithImpl(this._self, this._then);

  final RequestPayoutRequest _self;
  final $Res Function(RequestPayoutRequest) _then;

/// Create a copy of RequestPayoutRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amountKobo = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
amountKobo: freezed == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestPayoutRequest].
extension RequestPayoutRequestPatterns on RequestPayoutRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestPayoutRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestPayoutRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestPayoutRequest value)  $default,){
final _that = this;
switch (_that) {
case _RequestPayoutRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestPayoutRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RequestPayoutRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? amountKobo,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestPayoutRequest() when $default != null:
return $default(_that.amountKobo,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? amountKobo,  String? note)  $default,) {final _that = this;
switch (_that) {
case _RequestPayoutRequest():
return $default(_that.amountKobo,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? amountKobo,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _RequestPayoutRequest() when $default != null:
return $default(_that.amountKobo,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestPayoutRequest implements RequestPayoutRequest {
  const _RequestPayoutRequest({this.amountKobo, this.note});
  factory _RequestPayoutRequest.fromJson(Map<String, dynamic> json) => _$RequestPayoutRequestFromJson(json);

@override final  int? amountKobo;
@override final  String? note;

/// Create a copy of RequestPayoutRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestPayoutRequestCopyWith<_RequestPayoutRequest> get copyWith => __$RequestPayoutRequestCopyWithImpl<_RequestPayoutRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestPayoutRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestPayoutRequest&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amountKobo,note);

@override
String toString() {
  return 'RequestPayoutRequest(amountKobo: $amountKobo, note: $note)';
}


}

/// @nodoc
abstract mixin class _$RequestPayoutRequestCopyWith<$Res> implements $RequestPayoutRequestCopyWith<$Res> {
  factory _$RequestPayoutRequestCopyWith(_RequestPayoutRequest value, $Res Function(_RequestPayoutRequest) _then) = __$RequestPayoutRequestCopyWithImpl;
@override @useResult
$Res call({
 int? amountKobo, String? note
});




}
/// @nodoc
class __$RequestPayoutRequestCopyWithImpl<$Res>
    implements _$RequestPayoutRequestCopyWith<$Res> {
  __$RequestPayoutRequestCopyWithImpl(this._self, this._then);

  final _RequestPayoutRequest _self;
  final $Res Function(_RequestPayoutRequest) _then;

/// Create a copy of RequestPayoutRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amountKobo = freezed,Object? note = freezed,}) {
  return _then(_RequestPayoutRequest(
amountKobo: freezed == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MarkPayoutPaidRequest {

 String? get reference;
/// Create a copy of MarkPayoutPaidRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkPayoutPaidRequestCopyWith<MarkPayoutPaidRequest> get copyWith => _$MarkPayoutPaidRequestCopyWithImpl<MarkPayoutPaidRequest>(this as MarkPayoutPaidRequest, _$identity);

  /// Serializes this MarkPayoutPaidRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkPayoutPaidRequest&&(identical(other.reference, reference) || other.reference == reference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reference);

@override
String toString() {
  return 'MarkPayoutPaidRequest(reference: $reference)';
}


}

/// @nodoc
abstract mixin class $MarkPayoutPaidRequestCopyWith<$Res>  {
  factory $MarkPayoutPaidRequestCopyWith(MarkPayoutPaidRequest value, $Res Function(MarkPayoutPaidRequest) _then) = _$MarkPayoutPaidRequestCopyWithImpl;
@useResult
$Res call({
 String? reference
});




}
/// @nodoc
class _$MarkPayoutPaidRequestCopyWithImpl<$Res>
    implements $MarkPayoutPaidRequestCopyWith<$Res> {
  _$MarkPayoutPaidRequestCopyWithImpl(this._self, this._then);

  final MarkPayoutPaidRequest _self;
  final $Res Function(MarkPayoutPaidRequest) _then;

/// Create a copy of MarkPayoutPaidRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reference = freezed,}) {
  return _then(_self.copyWith(
reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarkPayoutPaidRequest].
extension MarkPayoutPaidRequestPatterns on MarkPayoutPaidRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarkPayoutPaidRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarkPayoutPaidRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarkPayoutPaidRequest value)  $default,){
final _that = this;
switch (_that) {
case _MarkPayoutPaidRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarkPayoutPaidRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MarkPayoutPaidRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarkPayoutPaidRequest() when $default != null:
return $default(_that.reference);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reference)  $default,) {final _that = this;
switch (_that) {
case _MarkPayoutPaidRequest():
return $default(_that.reference);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reference)?  $default,) {final _that = this;
switch (_that) {
case _MarkPayoutPaidRequest() when $default != null:
return $default(_that.reference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarkPayoutPaidRequest implements MarkPayoutPaidRequest {
  const _MarkPayoutPaidRequest({this.reference});
  factory _MarkPayoutPaidRequest.fromJson(Map<String, dynamic> json) => _$MarkPayoutPaidRequestFromJson(json);

@override final  String? reference;

/// Create a copy of MarkPayoutPaidRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarkPayoutPaidRequestCopyWith<_MarkPayoutPaidRequest> get copyWith => __$MarkPayoutPaidRequestCopyWithImpl<_MarkPayoutPaidRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarkPayoutPaidRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarkPayoutPaidRequest&&(identical(other.reference, reference) || other.reference == reference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reference);

@override
String toString() {
  return 'MarkPayoutPaidRequest(reference: $reference)';
}


}

/// @nodoc
abstract mixin class _$MarkPayoutPaidRequestCopyWith<$Res> implements $MarkPayoutPaidRequestCopyWith<$Res> {
  factory _$MarkPayoutPaidRequestCopyWith(_MarkPayoutPaidRequest value, $Res Function(_MarkPayoutPaidRequest) _then) = __$MarkPayoutPaidRequestCopyWithImpl;
@override @useResult
$Res call({
 String? reference
});




}
/// @nodoc
class __$MarkPayoutPaidRequestCopyWithImpl<$Res>
    implements _$MarkPayoutPaidRequestCopyWith<$Res> {
  __$MarkPayoutPaidRequestCopyWithImpl(this._self, this._then);

  final _MarkPayoutPaidRequest _self;
  final $Res Function(_MarkPayoutPaidRequest) _then;

/// Create a copy of MarkPayoutPaidRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reference = freezed,}) {
  return _then(_MarkPayoutPaidRequest(
reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProductInput {

 String? get name; String? get description; List<String>? get categoryIds; int? get basePriceKobo; List<ProductVariant>? get variants; bool? get hasVariants; int? get stock; ProductStatus? get status; List<String>? get tags; List<ProductImage>? get images;
/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductInputCopyWith<ProductInput> get copyWith => _$ProductInputCopyWithImpl<ProductInput>(this as ProductInput, _$identity);

  /// Serializes this ProductInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInput&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds)&&(identical(other.basePriceKobo, basePriceKobo) || other.basePriceKobo == basePriceKobo)&&const DeepCollectionEquality().equals(other.variants, variants)&&(identical(other.hasVariants, hasVariants) || other.hasVariants == hasVariants)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(categoryIds),basePriceKobo,const DeepCollectionEquality().hash(variants),hasVariants,stock,status,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'ProductInput(name: $name, description: $description, categoryIds: $categoryIds, basePriceKobo: $basePriceKobo, variants: $variants, hasVariants: $hasVariants, stock: $stock, status: $status, tags: $tags, images: $images)';
}


}

/// @nodoc
abstract mixin class $ProductInputCopyWith<$Res>  {
  factory $ProductInputCopyWith(ProductInput value, $Res Function(ProductInput) _then) = _$ProductInputCopyWithImpl;
@useResult
$Res call({
 String? name, String? description, List<String>? categoryIds, int? basePriceKobo, List<ProductVariant>? variants, bool? hasVariants, int? stock, ProductStatus? status, List<String>? tags, List<ProductImage>? images
});




}
/// @nodoc
class _$ProductInputCopyWithImpl<$Res>
    implements $ProductInputCopyWith<$Res> {
  _$ProductInputCopyWithImpl(this._self, this._then);

  final ProductInput _self;
  final $Res Function(ProductInput) _then;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? description = freezed,Object? categoryIds = freezed,Object? basePriceKobo = freezed,Object? variants = freezed,Object? hasVariants = freezed,Object? stock = freezed,Object? status = freezed,Object? tags = freezed,Object? images = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryIds: freezed == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,basePriceKobo: freezed == basePriceKobo ? _self.basePriceKobo : basePriceKobo // ignore: cast_nullable_to_non_nullable
as int?,variants: freezed == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariant>?,hasVariants: freezed == hasVariants ? _self.hasVariants : hasVariants // ignore: cast_nullable_to_non_nullable
as bool?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImage>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductInput].
extension ProductInputPatterns on ProductInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductInput value)  $default,){
final _that = this;
switch (_that) {
case _ProductInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductInput value)?  $default,){
final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? description,  List<String>? categoryIds,  int? basePriceKobo,  List<ProductVariant>? variants,  bool? hasVariants,  int? stock,  ProductStatus? status,  List<String>? tags,  List<ProductImage>? images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
return $default(_that.name,_that.description,_that.categoryIds,_that.basePriceKobo,_that.variants,_that.hasVariants,_that.stock,_that.status,_that.tags,_that.images);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? description,  List<String>? categoryIds,  int? basePriceKobo,  List<ProductVariant>? variants,  bool? hasVariants,  int? stock,  ProductStatus? status,  List<String>? tags,  List<ProductImage>? images)  $default,) {final _that = this;
switch (_that) {
case _ProductInput():
return $default(_that.name,_that.description,_that.categoryIds,_that.basePriceKobo,_that.variants,_that.hasVariants,_that.stock,_that.status,_that.tags,_that.images);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? description,  List<String>? categoryIds,  int? basePriceKobo,  List<ProductVariant>? variants,  bool? hasVariants,  int? stock,  ProductStatus? status,  List<String>? tags,  List<ProductImage>? images)?  $default,) {final _that = this;
switch (_that) {
case _ProductInput() when $default != null:
return $default(_that.name,_that.description,_that.categoryIds,_that.basePriceKobo,_that.variants,_that.hasVariants,_that.stock,_that.status,_that.tags,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductInput implements ProductInput {
  const _ProductInput({this.name, this.description, final  List<String>? categoryIds, this.basePriceKobo, final  List<ProductVariant>? variants, this.hasVariants, this.stock, this.status, final  List<String>? tags, final  List<ProductImage>? images}): _categoryIds = categoryIds,_variants = variants,_tags = tags,_images = images;
  factory _ProductInput.fromJson(Map<String, dynamic> json) => _$ProductInputFromJson(json);

@override final  String? name;
@override final  String? description;
 final  List<String>? _categoryIds;
@override List<String>? get categoryIds {
  final value = _categoryIds;
  if (value == null) return null;
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? basePriceKobo;
 final  List<ProductVariant>? _variants;
@override List<ProductVariant>? get variants {
  final value = _variants;
  if (value == null) return null;
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? hasVariants;
@override final  int? stock;
@override final  ProductStatus? status;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ProductImage>? _images;
@override List<ProductImage>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductInputCopyWith<_ProductInput> get copyWith => __$ProductInputCopyWithImpl<_ProductInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductInput&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds)&&(identical(other.basePriceKobo, basePriceKobo) || other.basePriceKobo == basePriceKobo)&&const DeepCollectionEquality().equals(other._variants, _variants)&&(identical(other.hasVariants, hasVariants) || other.hasVariants == hasVariants)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(_categoryIds),basePriceKobo,const DeepCollectionEquality().hash(_variants),hasVariants,stock,status,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'ProductInput(name: $name, description: $description, categoryIds: $categoryIds, basePriceKobo: $basePriceKobo, variants: $variants, hasVariants: $hasVariants, stock: $stock, status: $status, tags: $tags, images: $images)';
}


}

/// @nodoc
abstract mixin class _$ProductInputCopyWith<$Res> implements $ProductInputCopyWith<$Res> {
  factory _$ProductInputCopyWith(_ProductInput value, $Res Function(_ProductInput) _then) = __$ProductInputCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? description, List<String>? categoryIds, int? basePriceKobo, List<ProductVariant>? variants, bool? hasVariants, int? stock, ProductStatus? status, List<String>? tags, List<ProductImage>? images
});




}
/// @nodoc
class __$ProductInputCopyWithImpl<$Res>
    implements _$ProductInputCopyWith<$Res> {
  __$ProductInputCopyWithImpl(this._self, this._then);

  final _ProductInput _self;
  final $Res Function(_ProductInput) _then;

/// Create a copy of ProductInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? description = freezed,Object? categoryIds = freezed,Object? basePriceKobo = freezed,Object? variants = freezed,Object? hasVariants = freezed,Object? stock = freezed,Object? status = freezed,Object? tags = freezed,Object? images = freezed,}) {
  return _then(_ProductInput(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryIds: freezed == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,basePriceKobo: freezed == basePriceKobo ? _self.basePriceKobo : basePriceKobo // ignore: cast_nullable_to_non_nullable
as int?,variants: freezed == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariant>?,hasVariants: freezed == hasVariants ? _self.hasVariants : hasVariants // ignore: cast_nullable_to_non_nullable
as bool?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImage>?,
  ));
}


}


/// @nodoc
mixin _$AddressInput {

 String? get id; String? get label; String? get line1; String? get line2; String? get city; String? get state; double? get lat; double? get lng; String? get phone; bool? get isDefault;
/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressInputCopyWith<AddressInput> get copyWith => _$AddressInputCopyWithImpl<AddressInput>(this as AddressInput, _$identity);

  /// Serializes this AddressInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressInput&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,line1,line2,city,state,lat,lng,phone,isDefault);

@override
String toString() {
  return 'AddressInput(id: $id, label: $label, line1: $line1, line2: $line2, city: $city, state: $state, lat: $lat, lng: $lng, phone: $phone, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $AddressInputCopyWith<$Res>  {
  factory $AddressInputCopyWith(AddressInput value, $Res Function(AddressInput) _then) = _$AddressInputCopyWithImpl;
@useResult
$Res call({
 String? id, String? label, String? line1, String? line2, String? city, String? state, double? lat, double? lng, String? phone, bool? isDefault
});




}
/// @nodoc
class _$AddressInputCopyWithImpl<$Res>
    implements $AddressInputCopyWith<$Res> {
  _$AddressInputCopyWithImpl(this._self, this._then);

  final AddressInput _self;
  final $Res Function(AddressInput) _then;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? label = freezed,Object? line1 = freezed,Object? line2 = freezed,Object? city = freezed,Object? state = freezed,Object? lat = freezed,Object? lng = freezed,Object? phone = freezed,Object? isDefault = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,line1: freezed == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String?,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressInput].
extension AddressInputPatterns on AddressInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressInput value)  $default,){
final _that = this;
switch (_that) {
case _AddressInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressInput value)?  $default,){
final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? label,  String? line1,  String? line2,  String? city,  String? state,  double? lat,  double? lng,  String? phone,  bool? isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that.id,_that.label,_that.line1,_that.line2,_that.city,_that.state,_that.lat,_that.lng,_that.phone,_that.isDefault);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? label,  String? line1,  String? line2,  String? city,  String? state,  double? lat,  double? lng,  String? phone,  bool? isDefault)  $default,) {final _that = this;
switch (_that) {
case _AddressInput():
return $default(_that.id,_that.label,_that.line1,_that.line2,_that.city,_that.state,_that.lat,_that.lng,_that.phone,_that.isDefault);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? label,  String? line1,  String? line2,  String? city,  String? state,  double? lat,  double? lng,  String? phone,  bool? isDefault)?  $default,) {final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that.id,_that.label,_that.line1,_that.line2,_that.city,_that.state,_that.lat,_that.lng,_that.phone,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddressInput implements AddressInput {
  const _AddressInput({this.id, this.label, this.line1, this.line2, this.city, this.state, this.lat, this.lng, this.phone, this.isDefault});
  factory _AddressInput.fromJson(Map<String, dynamic> json) => _$AddressInputFromJson(json);

@override final  String? id;
@override final  String? label;
@override final  String? line1;
@override final  String? line2;
@override final  String? city;
@override final  String? state;
@override final  double? lat;
@override final  double? lng;
@override final  String? phone;
@override final  bool? isDefault;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressInputCopyWith<_AddressInput> get copyWith => __$AddressInputCopyWithImpl<_AddressInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressInput&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,line1,line2,city,state,lat,lng,phone,isDefault);

@override
String toString() {
  return 'AddressInput(id: $id, label: $label, line1: $line1, line2: $line2, city: $city, state: $state, lat: $lat, lng: $lng, phone: $phone, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$AddressInputCopyWith<$Res> implements $AddressInputCopyWith<$Res> {
  factory _$AddressInputCopyWith(_AddressInput value, $Res Function(_AddressInput) _then) = __$AddressInputCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? label, String? line1, String? line2, String? city, String? state, double? lat, double? lng, String? phone, bool? isDefault
});




}
/// @nodoc
class __$AddressInputCopyWithImpl<$Res>
    implements _$AddressInputCopyWith<$Res> {
  __$AddressInputCopyWithImpl(this._self, this._then);

  final _AddressInput _self;
  final $Res Function(_AddressInput) _then;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? label = freezed,Object? line1 = freezed,Object? line2 = freezed,Object? city = freezed,Object? state = freezed,Object? lat = freezed,Object? lng = freezed,Object? phone = freezed,Object? isDefault = freezed,}) {
  return _then(_AddressInput(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,line1: freezed == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String?,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$VendorInput {

 String? get name; String? get description; String? get logoImageId; String? get coverImageId; VendorAddress? get address; DeliveryFeeConfig? get deliveryFee; double? get deliveryRadiusKm; List<OpeningHours>? get openingHours; int? get commissionBps; PayoutAccount? get payout; VendorStatus? get status;
/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorInputCopyWith<VendorInput> get copyWith => _$VendorInputCopyWithImpl<VendorInput>(this as VendorInput, _$identity);

  /// Serializes this VendorInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorInput&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoImageId, logoImageId) || other.logoImageId == logoImageId)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&(identical(other.address, address) || other.address == address)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.deliveryRadiusKm, deliveryRadiusKm) || other.deliveryRadiusKm == deliveryRadiusKm)&&const DeepCollectionEquality().equals(other.openingHours, openingHours)&&(identical(other.commissionBps, commissionBps) || other.commissionBps == commissionBps)&&(identical(other.payout, payout) || other.payout == payout)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,logoImageId,coverImageId,address,deliveryFee,deliveryRadiusKm,const DeepCollectionEquality().hash(openingHours),commissionBps,payout,status);

@override
String toString() {
  return 'VendorInput(name: $name, description: $description, logoImageId: $logoImageId, coverImageId: $coverImageId, address: $address, deliveryFee: $deliveryFee, deliveryRadiusKm: $deliveryRadiusKm, openingHours: $openingHours, commissionBps: $commissionBps, payout: $payout, status: $status)';
}


}

/// @nodoc
abstract mixin class $VendorInputCopyWith<$Res>  {
  factory $VendorInputCopyWith(VendorInput value, $Res Function(VendorInput) _then) = _$VendorInputCopyWithImpl;
@useResult
$Res call({
 String? name, String? description, String? logoImageId, String? coverImageId, VendorAddress? address, DeliveryFeeConfig? deliveryFee, double? deliveryRadiusKm, List<OpeningHours>? openingHours, int? commissionBps, PayoutAccount? payout, VendorStatus? status
});


$VendorAddressCopyWith<$Res>? get address;$DeliveryFeeConfigCopyWith<$Res>? get deliveryFee;$PayoutAccountCopyWith<$Res>? get payout;

}
/// @nodoc
class _$VendorInputCopyWithImpl<$Res>
    implements $VendorInputCopyWith<$Res> {
  _$VendorInputCopyWithImpl(this._self, this._then);

  final VendorInput _self;
  final $Res Function(VendorInput) _then;

/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? description = freezed,Object? logoImageId = freezed,Object? coverImageId = freezed,Object? address = freezed,Object? deliveryFee = freezed,Object? deliveryRadiusKm = freezed,Object? openingHours = freezed,Object? commissionBps = freezed,Object? payout = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoImageId: freezed == logoImageId ? _self.logoImageId : logoImageId // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as VendorAddress?,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as DeliveryFeeConfig?,deliveryRadiusKm: freezed == deliveryRadiusKm ? _self.deliveryRadiusKm : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
as double?,openingHours: freezed == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<OpeningHours>?,commissionBps: freezed == commissionBps ? _self.commissionBps : commissionBps // ignore: cast_nullable_to_non_nullable
as int?,payout: freezed == payout ? _self.payout : payout // ignore: cast_nullable_to_non_nullable
as PayoutAccount?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VendorStatus?,
  ));
}
/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorAddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $VendorAddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryFeeConfigCopyWith<$Res>? get deliveryFee {
    if (_self.deliveryFee == null) {
    return null;
  }

  return $DeliveryFeeConfigCopyWith<$Res>(_self.deliveryFee!, (value) {
    return _then(_self.copyWith(deliveryFee: value));
  });
}/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PayoutAccountCopyWith<$Res>? get payout {
    if (_self.payout == null) {
    return null;
  }

  return $PayoutAccountCopyWith<$Res>(_self.payout!, (value) {
    return _then(_self.copyWith(payout: value));
  });
}
}


/// Adds pattern-matching-related methods to [VendorInput].
extension VendorInputPatterns on VendorInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorInput value)  $default,){
final _that = this;
switch (_that) {
case _VendorInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorInput value)?  $default,){
final _that = this;
switch (_that) {
case _VendorInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? description,  String? logoImageId,  String? coverImageId,  VendorAddress? address,  DeliveryFeeConfig? deliveryFee,  double? deliveryRadiusKm,  List<OpeningHours>? openingHours,  int? commissionBps,  PayoutAccount? payout,  VendorStatus? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorInput() when $default != null:
return $default(_that.name,_that.description,_that.logoImageId,_that.coverImageId,_that.address,_that.deliveryFee,_that.deliveryRadiusKm,_that.openingHours,_that.commissionBps,_that.payout,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? description,  String? logoImageId,  String? coverImageId,  VendorAddress? address,  DeliveryFeeConfig? deliveryFee,  double? deliveryRadiusKm,  List<OpeningHours>? openingHours,  int? commissionBps,  PayoutAccount? payout,  VendorStatus? status)  $default,) {final _that = this;
switch (_that) {
case _VendorInput():
return $default(_that.name,_that.description,_that.logoImageId,_that.coverImageId,_that.address,_that.deliveryFee,_that.deliveryRadiusKm,_that.openingHours,_that.commissionBps,_that.payout,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? description,  String? logoImageId,  String? coverImageId,  VendorAddress? address,  DeliveryFeeConfig? deliveryFee,  double? deliveryRadiusKm,  List<OpeningHours>? openingHours,  int? commissionBps,  PayoutAccount? payout,  VendorStatus? status)?  $default,) {final _that = this;
switch (_that) {
case _VendorInput() when $default != null:
return $default(_that.name,_that.description,_that.logoImageId,_that.coverImageId,_that.address,_that.deliveryFee,_that.deliveryRadiusKm,_that.openingHours,_that.commissionBps,_that.payout,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorInput implements VendorInput {
  const _VendorInput({this.name, this.description, this.logoImageId, this.coverImageId, this.address, this.deliveryFee, this.deliveryRadiusKm, final  List<OpeningHours>? openingHours, this.commissionBps, this.payout, this.status}): _openingHours = openingHours;
  factory _VendorInput.fromJson(Map<String, dynamic> json) => _$VendorInputFromJson(json);

@override final  String? name;
@override final  String? description;
@override final  String? logoImageId;
@override final  String? coverImageId;
@override final  VendorAddress? address;
@override final  DeliveryFeeConfig? deliveryFee;
@override final  double? deliveryRadiusKm;
 final  List<OpeningHours>? _openingHours;
@override List<OpeningHours>? get openingHours {
  final value = _openingHours;
  if (value == null) return null;
  if (_openingHours is EqualUnmodifiableListView) return _openingHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? commissionBps;
@override final  PayoutAccount? payout;
@override final  VendorStatus? status;

/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorInputCopyWith<_VendorInput> get copyWith => __$VendorInputCopyWithImpl<_VendorInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorInput&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoImageId, logoImageId) || other.logoImageId == logoImageId)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&(identical(other.address, address) || other.address == address)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.deliveryRadiusKm, deliveryRadiusKm) || other.deliveryRadiusKm == deliveryRadiusKm)&&const DeepCollectionEquality().equals(other._openingHours, _openingHours)&&(identical(other.commissionBps, commissionBps) || other.commissionBps == commissionBps)&&(identical(other.payout, payout) || other.payout == payout)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,logoImageId,coverImageId,address,deliveryFee,deliveryRadiusKm,const DeepCollectionEquality().hash(_openingHours),commissionBps,payout,status);

@override
String toString() {
  return 'VendorInput(name: $name, description: $description, logoImageId: $logoImageId, coverImageId: $coverImageId, address: $address, deliveryFee: $deliveryFee, deliveryRadiusKm: $deliveryRadiusKm, openingHours: $openingHours, commissionBps: $commissionBps, payout: $payout, status: $status)';
}


}

/// @nodoc
abstract mixin class _$VendorInputCopyWith<$Res> implements $VendorInputCopyWith<$Res> {
  factory _$VendorInputCopyWith(_VendorInput value, $Res Function(_VendorInput) _then) = __$VendorInputCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? description, String? logoImageId, String? coverImageId, VendorAddress? address, DeliveryFeeConfig? deliveryFee, double? deliveryRadiusKm, List<OpeningHours>? openingHours, int? commissionBps, PayoutAccount? payout, VendorStatus? status
});


@override $VendorAddressCopyWith<$Res>? get address;@override $DeliveryFeeConfigCopyWith<$Res>? get deliveryFee;@override $PayoutAccountCopyWith<$Res>? get payout;

}
/// @nodoc
class __$VendorInputCopyWithImpl<$Res>
    implements _$VendorInputCopyWith<$Res> {
  __$VendorInputCopyWithImpl(this._self, this._then);

  final _VendorInput _self;
  final $Res Function(_VendorInput) _then;

/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? description = freezed,Object? logoImageId = freezed,Object? coverImageId = freezed,Object? address = freezed,Object? deliveryFee = freezed,Object? deliveryRadiusKm = freezed,Object? openingHours = freezed,Object? commissionBps = freezed,Object? payout = freezed,Object? status = freezed,}) {
  return _then(_VendorInput(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoImageId: freezed == logoImageId ? _self.logoImageId : logoImageId // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as VendorAddress?,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as DeliveryFeeConfig?,deliveryRadiusKm: freezed == deliveryRadiusKm ? _self.deliveryRadiusKm : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
as double?,openingHours: freezed == openingHours ? _self._openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<OpeningHours>?,commissionBps: freezed == commissionBps ? _self.commissionBps : commissionBps // ignore: cast_nullable_to_non_nullable
as int?,payout: freezed == payout ? _self.payout : payout // ignore: cast_nullable_to_non_nullable
as PayoutAccount?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VendorStatus?,
  ));
}

/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorAddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $VendorAddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryFeeConfigCopyWith<$Res>? get deliveryFee {
    if (_self.deliveryFee == null) {
    return null;
  }

  return $DeliveryFeeConfigCopyWith<$Res>(_self.deliveryFee!, (value) {
    return _then(_self.copyWith(deliveryFee: value));
  });
}/// Create a copy of VendorInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PayoutAccountCopyWith<$Res>? get payout {
    if (_self.payout == null) {
    return null;
  }

  return $PayoutAccountCopyWith<$Res>(_self.payout!, (value) {
    return _then(_self.copyWith(payout: value));
  });
}
}


/// @nodoc
mixin _$CategoryInput {

 String? get name; String? get slug; String? get parentId; int? get sortOrder; String? get imageId;
/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryInputCopyWith<CategoryInput> get copyWith => _$CategoryInputCopyWithImpl<CategoryInput>(this as CategoryInput, _$identity);

  /// Serializes this CategoryInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryInput&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,slug,parentId,sortOrder,imageId);

@override
String toString() {
  return 'CategoryInput(name: $name, slug: $slug, parentId: $parentId, sortOrder: $sortOrder, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class $CategoryInputCopyWith<$Res>  {
  factory $CategoryInputCopyWith(CategoryInput value, $Res Function(CategoryInput) _then) = _$CategoryInputCopyWithImpl;
@useResult
$Res call({
 String? name, String? slug, String? parentId, int? sortOrder, String? imageId
});




}
/// @nodoc
class _$CategoryInputCopyWithImpl<$Res>
    implements $CategoryInputCopyWith<$Res> {
  _$CategoryInputCopyWithImpl(this._self, this._then);

  final CategoryInput _self;
  final $Res Function(CategoryInput) _then;

/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? slug = freezed,Object? parentId = freezed,Object? sortOrder = freezed,Object? imageId = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryInput].
extension CategoryInputPatterns on CategoryInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryInput value)  $default,){
final _that = this;
switch (_that) {
case _CategoryInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryInput value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? slug,  String? parentId,  int? sortOrder,  String? imageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
return $default(_that.name,_that.slug,_that.parentId,_that.sortOrder,_that.imageId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? slug,  String? parentId,  int? sortOrder,  String? imageId)  $default,) {final _that = this;
switch (_that) {
case _CategoryInput():
return $default(_that.name,_that.slug,_that.parentId,_that.sortOrder,_that.imageId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? slug,  String? parentId,  int? sortOrder,  String? imageId)?  $default,) {final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
return $default(_that.name,_that.slug,_that.parentId,_that.sortOrder,_that.imageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryInput implements CategoryInput {
  const _CategoryInput({this.name, this.slug, this.parentId, this.sortOrder, this.imageId});
  factory _CategoryInput.fromJson(Map<String, dynamic> json) => _$CategoryInputFromJson(json);

@override final  String? name;
@override final  String? slug;
@override final  String? parentId;
@override final  int? sortOrder;
@override final  String? imageId;

/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryInputCopyWith<_CategoryInput> get copyWith => __$CategoryInputCopyWithImpl<_CategoryInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryInput&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,slug,parentId,sortOrder,imageId);

@override
String toString() {
  return 'CategoryInput(name: $name, slug: $slug, parentId: $parentId, sortOrder: $sortOrder, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class _$CategoryInputCopyWith<$Res> implements $CategoryInputCopyWith<$Res> {
  factory _$CategoryInputCopyWith(_CategoryInput value, $Res Function(_CategoryInput) _then) = __$CategoryInputCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? slug, String? parentId, int? sortOrder, String? imageId
});




}
/// @nodoc
class __$CategoryInputCopyWithImpl<$Res>
    implements _$CategoryInputCopyWith<$Res> {
  __$CategoryInputCopyWithImpl(this._self, this._then);

  final _CategoryInput _self;
  final $Res Function(_CategoryInput) _then;

/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? slug = freezed,Object? parentId = freezed,Object? sortOrder = freezed,Object? imageId = freezed,}) {
  return _then(_CategoryInput(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CartInput {

 List<CartItem> get items;@NullableDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of CartInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartInputCopyWith<CartInput> get copyWith => _$CartInputCopyWithImpl<CartInput>(this as CartInput, _$identity);

  /// Serializes this CartInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartInput&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),updatedAt);

@override
String toString() {
  return 'CartInput(items: $items, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CartInputCopyWith<$Res>  {
  factory $CartInputCopyWith(CartInput value, $Res Function(CartInput) _then) = _$CartInputCopyWithImpl;
@useResult
$Res call({
 List<CartItem> items,@NullableDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$CartInputCopyWithImpl<$Res>
    implements $CartInputCopyWith<$Res> {
  _$CartInputCopyWithImpl(this._self, this._then);

  final CartInput _self;
  final $Res Function(CartInput) _then;

/// Create a copy of CartInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartInput].
extension CartInputPatterns on CartInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartInput value)  $default,){
final _that = this;
switch (_that) {
case _CartInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartInput value)?  $default,){
final _that = this;
switch (_that) {
case _CartInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CartItem> items, @NullableDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartInput() when $default != null:
return $default(_that.items,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CartItem> items, @NullableDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CartInput():
return $default(_that.items,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CartItem> items, @NullableDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CartInput() when $default != null:
return $default(_that.items,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartInput implements CartInput {
  const _CartInput({final  List<CartItem> items = const <CartItem>[], @NullableDateTimeConverter() this.updatedAt}): _items = items;
  factory _CartInput.fromJson(Map<String, dynamic> json) => _$CartInputFromJson(json);

 final  List<CartItem> _items;
@override@JsonKey() List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@NullableDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of CartInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartInputCopyWith<_CartInput> get copyWith => __$CartInputCopyWithImpl<_CartInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartInput&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),updatedAt);

@override
String toString() {
  return 'CartInput(items: $items, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CartInputCopyWith<$Res> implements $CartInputCopyWith<$Res> {
  factory _$CartInputCopyWith(_CartInput value, $Res Function(_CartInput) _then) = __$CartInputCopyWithImpl;
@override @useResult
$Res call({
 List<CartItem> items,@NullableDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$CartInputCopyWithImpl<$Res>
    implements _$CartInputCopyWith<$Res> {
  __$CartInputCopyWithImpl(this._self, this._then);

  final _CartInput _self;
  final $Res Function(_CartInput) _then;

/// Create a copy of CartInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? updatedAt = freezed,}) {
  return _then(_CartInput(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RevenueWindow {

 int get revenueKobo; int get orders; int get commissionKobo;
/// Create a copy of RevenueWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevenueWindowCopyWith<RevenueWindow> get copyWith => _$RevenueWindowCopyWithImpl<RevenueWindow>(this as RevenueWindow, _$identity);

  /// Serializes this RevenueWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevenueWindow&&(identical(other.revenueKobo, revenueKobo) || other.revenueKobo == revenueKobo)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.commissionKobo, commissionKobo) || other.commissionKobo == commissionKobo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revenueKobo,orders,commissionKobo);

@override
String toString() {
  return 'RevenueWindow(revenueKobo: $revenueKobo, orders: $orders, commissionKobo: $commissionKobo)';
}


}

/// @nodoc
abstract mixin class $RevenueWindowCopyWith<$Res>  {
  factory $RevenueWindowCopyWith(RevenueWindow value, $Res Function(RevenueWindow) _then) = _$RevenueWindowCopyWithImpl;
@useResult
$Res call({
 int revenueKobo, int orders, int commissionKobo
});




}
/// @nodoc
class _$RevenueWindowCopyWithImpl<$Res>
    implements $RevenueWindowCopyWith<$Res> {
  _$RevenueWindowCopyWithImpl(this._self, this._then);

  final RevenueWindow _self;
  final $Res Function(RevenueWindow) _then;

/// Create a copy of RevenueWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revenueKobo = null,Object? orders = null,Object? commissionKobo = null,}) {
  return _then(_self.copyWith(
revenueKobo: null == revenueKobo ? _self.revenueKobo : revenueKobo // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,commissionKobo: null == commissionKobo ? _self.commissionKobo : commissionKobo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RevenueWindow].
extension RevenueWindowPatterns on RevenueWindow {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevenueWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevenueWindow() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevenueWindow value)  $default,){
final _that = this;
switch (_that) {
case _RevenueWindow():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevenueWindow value)?  $default,){
final _that = this;
switch (_that) {
case _RevenueWindow() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int revenueKobo,  int orders,  int commissionKobo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevenueWindow() when $default != null:
return $default(_that.revenueKobo,_that.orders,_that.commissionKobo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int revenueKobo,  int orders,  int commissionKobo)  $default,) {final _that = this;
switch (_that) {
case _RevenueWindow():
return $default(_that.revenueKobo,_that.orders,_that.commissionKobo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int revenueKobo,  int orders,  int commissionKobo)?  $default,) {final _that = this;
switch (_that) {
case _RevenueWindow() when $default != null:
return $default(_that.revenueKobo,_that.orders,_that.commissionKobo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RevenueWindow implements RevenueWindow {
  const _RevenueWindow({this.revenueKobo = 0, this.orders = 0, this.commissionKobo = 0});
  factory _RevenueWindow.fromJson(Map<String, dynamic> json) => _$RevenueWindowFromJson(json);

@override@JsonKey() final  int revenueKobo;
@override@JsonKey() final  int orders;
@override@JsonKey() final  int commissionKobo;

/// Create a copy of RevenueWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevenueWindowCopyWith<_RevenueWindow> get copyWith => __$RevenueWindowCopyWithImpl<_RevenueWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevenueWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevenueWindow&&(identical(other.revenueKobo, revenueKobo) || other.revenueKobo == revenueKobo)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.commissionKobo, commissionKobo) || other.commissionKobo == commissionKobo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revenueKobo,orders,commissionKobo);

@override
String toString() {
  return 'RevenueWindow(revenueKobo: $revenueKobo, orders: $orders, commissionKobo: $commissionKobo)';
}


}

/// @nodoc
abstract mixin class _$RevenueWindowCopyWith<$Res> implements $RevenueWindowCopyWith<$Res> {
  factory _$RevenueWindowCopyWith(_RevenueWindow value, $Res Function(_RevenueWindow) _then) = __$RevenueWindowCopyWithImpl;
@override @useResult
$Res call({
 int revenueKobo, int orders, int commissionKobo
});




}
/// @nodoc
class __$RevenueWindowCopyWithImpl<$Res>
    implements _$RevenueWindowCopyWith<$Res> {
  __$RevenueWindowCopyWithImpl(this._self, this._then);

  final _RevenueWindow _self;
  final $Res Function(_RevenueWindow) _then;

/// Create a copy of RevenueWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revenueKobo = null,Object? orders = null,Object? commissionKobo = null,}) {
  return _then(_RevenueWindow(
revenueKobo: null == revenueKobo ? _self.revenueKobo : revenueKobo // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,commissionKobo: null == commissionKobo ? _self.commissionKobo : commissionKobo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdminCounts {

 int get users; int get customers; int get riders; Map<String, int> get vendors; int get products; int get activeProducts; int get orders; int get paidOrders; int get openSubOrders;
/// Create a copy of AdminCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCountsCopyWith<AdminCounts> get copyWith => _$AdminCountsCopyWithImpl<AdminCounts>(this as AdminCounts, _$identity);

  /// Serializes this AdminCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCounts&&(identical(other.users, users) || other.users == users)&&(identical(other.customers, customers) || other.customers == customers)&&(identical(other.riders, riders) || other.riders == riders)&&const DeepCollectionEquality().equals(other.vendors, vendors)&&(identical(other.products, products) || other.products == products)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.paidOrders, paidOrders) || other.paidOrders == paidOrders)&&(identical(other.openSubOrders, openSubOrders) || other.openSubOrders == openSubOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,users,customers,riders,const DeepCollectionEquality().hash(vendors),products,activeProducts,orders,paidOrders,openSubOrders);

@override
String toString() {
  return 'AdminCounts(users: $users, customers: $customers, riders: $riders, vendors: $vendors, products: $products, activeProducts: $activeProducts, orders: $orders, paidOrders: $paidOrders, openSubOrders: $openSubOrders)';
}


}

/// @nodoc
abstract mixin class $AdminCountsCopyWith<$Res>  {
  factory $AdminCountsCopyWith(AdminCounts value, $Res Function(AdminCounts) _then) = _$AdminCountsCopyWithImpl;
@useResult
$Res call({
 int users, int customers, int riders, Map<String, int> vendors, int products, int activeProducts, int orders, int paidOrders, int openSubOrders
});




}
/// @nodoc
class _$AdminCountsCopyWithImpl<$Res>
    implements $AdminCountsCopyWith<$Res> {
  _$AdminCountsCopyWithImpl(this._self, this._then);

  final AdminCounts _self;
  final $Res Function(AdminCounts) _then;

/// Create a copy of AdminCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? customers = null,Object? riders = null,Object? vendors = null,Object? products = null,Object? activeProducts = null,Object? orders = null,Object? paidOrders = null,Object? openSubOrders = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as int,customers: null == customers ? _self.customers : customers // ignore: cast_nullable_to_non_nullable
as int,riders: null == riders ? _self.riders : riders // ignore: cast_nullable_to_non_nullable
as int,vendors: null == vendors ? _self.vendors : vendors // ignore: cast_nullable_to_non_nullable
as Map<String, int>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,paidOrders: null == paidOrders ? _self.paidOrders : paidOrders // ignore: cast_nullable_to_non_nullable
as int,openSubOrders: null == openSubOrders ? _self.openSubOrders : openSubOrders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCounts].
extension AdminCountsPatterns on AdminCounts {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCounts() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCounts value)  $default,){
final _that = this;
switch (_that) {
case _AdminCounts():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCounts value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCounts() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int users,  int customers,  int riders,  Map<String, int> vendors,  int products,  int activeProducts,  int orders,  int paidOrders,  int openSubOrders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCounts() when $default != null:
return $default(_that.users,_that.customers,_that.riders,_that.vendors,_that.products,_that.activeProducts,_that.orders,_that.paidOrders,_that.openSubOrders);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int users,  int customers,  int riders,  Map<String, int> vendors,  int products,  int activeProducts,  int orders,  int paidOrders,  int openSubOrders)  $default,) {final _that = this;
switch (_that) {
case _AdminCounts():
return $default(_that.users,_that.customers,_that.riders,_that.vendors,_that.products,_that.activeProducts,_that.orders,_that.paidOrders,_that.openSubOrders);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int users,  int customers,  int riders,  Map<String, int> vendors,  int products,  int activeProducts,  int orders,  int paidOrders,  int openSubOrders)?  $default,) {final _that = this;
switch (_that) {
case _AdminCounts() when $default != null:
return $default(_that.users,_that.customers,_that.riders,_that.vendors,_that.products,_that.activeProducts,_that.orders,_that.paidOrders,_that.openSubOrders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminCounts extends AdminCounts {
  const _AdminCounts({this.users = 0, this.customers = 0, this.riders = 0, final  Map<String, int> vendors = const <String, int>{}, this.products = 0, this.activeProducts = 0, this.orders = 0, this.paidOrders = 0, this.openSubOrders = 0}): _vendors = vendors,super._();
  factory _AdminCounts.fromJson(Map<String, dynamic> json) => _$AdminCountsFromJson(json);

@override@JsonKey() final  int users;
@override@JsonKey() final  int customers;
@override@JsonKey() final  int riders;
 final  Map<String, int> _vendors;
@override@JsonKey() Map<String, int> get vendors {
  if (_vendors is EqualUnmodifiableMapView) return _vendors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_vendors);
}

@override@JsonKey() final  int products;
@override@JsonKey() final  int activeProducts;
@override@JsonKey() final  int orders;
@override@JsonKey() final  int paidOrders;
@override@JsonKey() final  int openSubOrders;

/// Create a copy of AdminCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCountsCopyWith<_AdminCounts> get copyWith => __$AdminCountsCopyWithImpl<_AdminCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCounts&&(identical(other.users, users) || other.users == users)&&(identical(other.customers, customers) || other.customers == customers)&&(identical(other.riders, riders) || other.riders == riders)&&const DeepCollectionEquality().equals(other._vendors, _vendors)&&(identical(other.products, products) || other.products == products)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.paidOrders, paidOrders) || other.paidOrders == paidOrders)&&(identical(other.openSubOrders, openSubOrders) || other.openSubOrders == openSubOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,users,customers,riders,const DeepCollectionEquality().hash(_vendors),products,activeProducts,orders,paidOrders,openSubOrders);

@override
String toString() {
  return 'AdminCounts(users: $users, customers: $customers, riders: $riders, vendors: $vendors, products: $products, activeProducts: $activeProducts, orders: $orders, paidOrders: $paidOrders, openSubOrders: $openSubOrders)';
}


}

/// @nodoc
abstract mixin class _$AdminCountsCopyWith<$Res> implements $AdminCountsCopyWith<$Res> {
  factory _$AdminCountsCopyWith(_AdminCounts value, $Res Function(_AdminCounts) _then) = __$AdminCountsCopyWithImpl;
@override @useResult
$Res call({
 int users, int customers, int riders, Map<String, int> vendors, int products, int activeProducts, int orders, int paidOrders, int openSubOrders
});




}
/// @nodoc
class __$AdminCountsCopyWithImpl<$Res>
    implements _$AdminCountsCopyWith<$Res> {
  __$AdminCountsCopyWithImpl(this._self, this._then);

  final _AdminCounts _self;
  final $Res Function(_AdminCounts) _then;

/// Create a copy of AdminCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? customers = null,Object? riders = null,Object? vendors = null,Object? products = null,Object? activeProducts = null,Object? orders = null,Object? paidOrders = null,Object? openSubOrders = null,}) {
  return _then(_AdminCounts(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as int,customers: null == customers ? _self.customers : customers // ignore: cast_nullable_to_non_nullable
as int,riders: null == riders ? _self.riders : riders // ignore: cast_nullable_to_non_nullable
as int,vendors: null == vendors ? _self._vendors : vendors // ignore: cast_nullable_to_non_nullable
as Map<String, int>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,paidOrders: null == paidOrders ? _self.paidOrders : paidOrders // ignore: cast_nullable_to_non_nullable
as int,openSubOrders: null == openSubOrders ? _self.openSubOrders : openSubOrders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdminRevenue {

 RevenueWindow get today; RevenueWindow get last7d; RevenueWindow get last30d;
/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRevenueCopyWith<AdminRevenue> get copyWith => _$AdminRevenueCopyWithImpl<AdminRevenue>(this as AdminRevenue, _$identity);

  /// Serializes this AdminRevenue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRevenue&&(identical(other.today, today) || other.today == today)&&(identical(other.last7d, last7d) || other.last7d == last7d)&&(identical(other.last30d, last30d) || other.last30d == last30d));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,today,last7d,last30d);

@override
String toString() {
  return 'AdminRevenue(today: $today, last7d: $last7d, last30d: $last30d)';
}


}

/// @nodoc
abstract mixin class $AdminRevenueCopyWith<$Res>  {
  factory $AdminRevenueCopyWith(AdminRevenue value, $Res Function(AdminRevenue) _then) = _$AdminRevenueCopyWithImpl;
@useResult
$Res call({
 RevenueWindow today, RevenueWindow last7d, RevenueWindow last30d
});


$RevenueWindowCopyWith<$Res> get today;$RevenueWindowCopyWith<$Res> get last7d;$RevenueWindowCopyWith<$Res> get last30d;

}
/// @nodoc
class _$AdminRevenueCopyWithImpl<$Res>
    implements $AdminRevenueCopyWith<$Res> {
  _$AdminRevenueCopyWithImpl(this._self, this._then);

  final AdminRevenue _self;
  final $Res Function(AdminRevenue) _then;

/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? today = null,Object? last7d = null,Object? last30d = null,}) {
  return _then(_self.copyWith(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as RevenueWindow,last7d: null == last7d ? _self.last7d : last7d // ignore: cast_nullable_to_non_nullable
as RevenueWindow,last30d: null == last30d ? _self.last30d : last30d // ignore: cast_nullable_to_non_nullable
as RevenueWindow,
  ));
}
/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevenueWindowCopyWith<$Res> get today {
  
  return $RevenueWindowCopyWith<$Res>(_self.today, (value) {
    return _then(_self.copyWith(today: value));
  });
}/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevenueWindowCopyWith<$Res> get last7d {
  
  return $RevenueWindowCopyWith<$Res>(_self.last7d, (value) {
    return _then(_self.copyWith(last7d: value));
  });
}/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevenueWindowCopyWith<$Res> get last30d {
  
  return $RevenueWindowCopyWith<$Res>(_self.last30d, (value) {
    return _then(_self.copyWith(last30d: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminRevenue].
extension AdminRevenuePatterns on AdminRevenue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRevenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRevenue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRevenue value)  $default,){
final _that = this;
switch (_that) {
case _AdminRevenue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRevenue value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRevenue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RevenueWindow today,  RevenueWindow last7d,  RevenueWindow last30d)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRevenue() when $default != null:
return $default(_that.today,_that.last7d,_that.last30d);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RevenueWindow today,  RevenueWindow last7d,  RevenueWindow last30d)  $default,) {final _that = this;
switch (_that) {
case _AdminRevenue():
return $default(_that.today,_that.last7d,_that.last30d);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RevenueWindow today,  RevenueWindow last7d,  RevenueWindow last30d)?  $default,) {final _that = this;
switch (_that) {
case _AdminRevenue() when $default != null:
return $default(_that.today,_that.last7d,_that.last30d);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRevenue implements AdminRevenue {
  const _AdminRevenue({this.today = const RevenueWindow(), this.last7d = const RevenueWindow(), this.last30d = const RevenueWindow()});
  factory _AdminRevenue.fromJson(Map<String, dynamic> json) => _$AdminRevenueFromJson(json);

@override@JsonKey() final  RevenueWindow today;
@override@JsonKey() final  RevenueWindow last7d;
@override@JsonKey() final  RevenueWindow last30d;

/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRevenueCopyWith<_AdminRevenue> get copyWith => __$AdminRevenueCopyWithImpl<_AdminRevenue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRevenueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRevenue&&(identical(other.today, today) || other.today == today)&&(identical(other.last7d, last7d) || other.last7d == last7d)&&(identical(other.last30d, last30d) || other.last30d == last30d));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,today,last7d,last30d);

@override
String toString() {
  return 'AdminRevenue(today: $today, last7d: $last7d, last30d: $last30d)';
}


}

/// @nodoc
abstract mixin class _$AdminRevenueCopyWith<$Res> implements $AdminRevenueCopyWith<$Res> {
  factory _$AdminRevenueCopyWith(_AdminRevenue value, $Res Function(_AdminRevenue) _then) = __$AdminRevenueCopyWithImpl;
@override @useResult
$Res call({
 RevenueWindow today, RevenueWindow last7d, RevenueWindow last30d
});


@override $RevenueWindowCopyWith<$Res> get today;@override $RevenueWindowCopyWith<$Res> get last7d;@override $RevenueWindowCopyWith<$Res> get last30d;

}
/// @nodoc
class __$AdminRevenueCopyWithImpl<$Res>
    implements _$AdminRevenueCopyWith<$Res> {
  __$AdminRevenueCopyWithImpl(this._self, this._then);

  final _AdminRevenue _self;
  final $Res Function(_AdminRevenue) _then;

/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? today = null,Object? last7d = null,Object? last30d = null,}) {
  return _then(_AdminRevenue(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as RevenueWindow,last7d: null == last7d ? _self.last7d : last7d // ignore: cast_nullable_to_non_nullable
as RevenueWindow,last30d: null == last30d ? _self.last30d : last30d // ignore: cast_nullable_to_non_nullable
as RevenueWindow,
  ));
}

/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevenueWindowCopyWith<$Res> get today {
  
  return $RevenueWindowCopyWith<$Res>(_self.today, (value) {
    return _then(_self.copyWith(today: value));
  });
}/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevenueWindowCopyWith<$Res> get last7d {
  
  return $RevenueWindowCopyWith<$Res>(_self.last7d, (value) {
    return _then(_self.copyWith(last7d: value));
  });
}/// Create a copy of AdminRevenue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevenueWindowCopyWith<$Res> get last30d {
  
  return $RevenueWindowCopyWith<$Res>(_self.last30d, (value) {
    return _then(_self.copyWith(last30d: value));
  });
}
}


/// @nodoc
mixin _$AdminStats {

 AdminCounts get counts; AdminRevenue get revenue;@NullableDateTimeConverter() DateTime? get generatedAt;
/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStatsCopyWith<AdminStats> get copyWith => _$AdminStatsCopyWithImpl<AdminStats>(this as AdminStats, _$identity);

  /// Serializes this AdminStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminStats&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,counts,revenue,generatedAt);

@override
String toString() {
  return 'AdminStats(counts: $counts, revenue: $revenue, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class $AdminStatsCopyWith<$Res>  {
  factory $AdminStatsCopyWith(AdminStats value, $Res Function(AdminStats) _then) = _$AdminStatsCopyWithImpl;
@useResult
$Res call({
 AdminCounts counts, AdminRevenue revenue,@NullableDateTimeConverter() DateTime? generatedAt
});


$AdminCountsCopyWith<$Res> get counts;$AdminRevenueCopyWith<$Res> get revenue;

}
/// @nodoc
class _$AdminStatsCopyWithImpl<$Res>
    implements $AdminStatsCopyWith<$Res> {
  _$AdminStatsCopyWithImpl(this._self, this._then);

  final AdminStats _self;
  final $Res Function(AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? counts = null,Object? revenue = null,Object? generatedAt = freezed,}) {
  return _then(_self.copyWith(
counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as AdminCounts,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as AdminRevenue,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminCountsCopyWith<$Res> get counts {
  
  return $AdminCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRevenueCopyWith<$Res> get revenue {
  
  return $AdminRevenueCopyWith<$Res>(_self.revenue, (value) {
    return _then(_self.copyWith(revenue: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminStats].
extension AdminStatsPatterns on AdminStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminStats value)  $default,){
final _that = this;
switch (_that) {
case _AdminStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdminCounts counts,  AdminRevenue revenue, @NullableDateTimeConverter()  DateTime? generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.counts,_that.revenue,_that.generatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdminCounts counts,  AdminRevenue revenue, @NullableDateTimeConverter()  DateTime? generatedAt)  $default,) {final _that = this;
switch (_that) {
case _AdminStats():
return $default(_that.counts,_that.revenue,_that.generatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdminCounts counts,  AdminRevenue revenue, @NullableDateTimeConverter()  DateTime? generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.counts,_that.revenue,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminStats implements AdminStats {
  const _AdminStats({this.counts = const AdminCounts(), this.revenue = const AdminRevenue(), @NullableDateTimeConverter() this.generatedAt});
  factory _AdminStats.fromJson(Map<String, dynamic> json) => _$AdminStatsFromJson(json);

@override@JsonKey() final  AdminCounts counts;
@override@JsonKey() final  AdminRevenue revenue;
@override@NullableDateTimeConverter() final  DateTime? generatedAt;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStatsCopyWith<_AdminStats> get copyWith => __$AdminStatsCopyWithImpl<_AdminStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminStats&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,counts,revenue,generatedAt);

@override
String toString() {
  return 'AdminStats(counts: $counts, revenue: $revenue, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$AdminStatsCopyWith<$Res> implements $AdminStatsCopyWith<$Res> {
  factory _$AdminStatsCopyWith(_AdminStats value, $Res Function(_AdminStats) _then) = __$AdminStatsCopyWithImpl;
@override @useResult
$Res call({
 AdminCounts counts, AdminRevenue revenue,@NullableDateTimeConverter() DateTime? generatedAt
});


@override $AdminCountsCopyWith<$Res> get counts;@override $AdminRevenueCopyWith<$Res> get revenue;

}
/// @nodoc
class __$AdminStatsCopyWithImpl<$Res>
    implements _$AdminStatsCopyWith<$Res> {
  __$AdminStatsCopyWithImpl(this._self, this._then);

  final _AdminStats _self;
  final $Res Function(_AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? counts = null,Object? revenue = null,Object? generatedAt = freezed,}) {
  return _then(_AdminStats(
counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as AdminCounts,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as AdminRevenue,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminCountsCopyWith<$Res> get counts {
  
  return $AdminCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRevenueCopyWith<$Res> get revenue {
  
  return $AdminRevenueCopyWith<$Res>(_self.revenue, (value) {
    return _then(_self.copyWith(revenue: value));
  });
}
}


/// @nodoc
mixin _$ApiErrorBody {

 int get statusCode; String get code; String get message; Object? get details;
/// Create a copy of ApiErrorBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiErrorBodyCopyWith<ApiErrorBody> get copyWith => _$ApiErrorBodyCopyWithImpl<ApiErrorBody>(this as ApiErrorBody, _$identity);

  /// Serializes this ApiErrorBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiErrorBody&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,code,message,const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'ApiErrorBody(statusCode: $statusCode, code: $code, message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class $ApiErrorBodyCopyWith<$Res>  {
  factory $ApiErrorBodyCopyWith(ApiErrorBody value, $Res Function(ApiErrorBody) _then) = _$ApiErrorBodyCopyWithImpl;
@useResult
$Res call({
 int statusCode, String code, String message, Object? details
});




}
/// @nodoc
class _$ApiErrorBodyCopyWithImpl<$Res>
    implements $ApiErrorBodyCopyWith<$Res> {
  _$ApiErrorBodyCopyWithImpl(this._self, this._then);

  final ApiErrorBody _self;
  final $Res Function(ApiErrorBody) _then;

/// Create a copy of ApiErrorBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusCode = null,Object? code = null,Object? message = null,Object? details = freezed,}) {
  return _then(_self.copyWith(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details ,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiErrorBody].
extension ApiErrorBodyPatterns on ApiErrorBody {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiErrorBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiErrorBody() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiErrorBody value)  $default,){
final _that = this;
switch (_that) {
case _ApiErrorBody():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiErrorBody value)?  $default,){
final _that = this;
switch (_that) {
case _ApiErrorBody() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int statusCode,  String code,  String message,  Object? details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiErrorBody() when $default != null:
return $default(_that.statusCode,_that.code,_that.message,_that.details);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int statusCode,  String code,  String message,  Object? details)  $default,) {final _that = this;
switch (_that) {
case _ApiErrorBody():
return $default(_that.statusCode,_that.code,_that.message,_that.details);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int statusCode,  String code,  String message,  Object? details)?  $default,) {final _that = this;
switch (_that) {
case _ApiErrorBody() when $default != null:
return $default(_that.statusCode,_that.code,_that.message,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiErrorBody implements ApiErrorBody {
  const _ApiErrorBody({required this.statusCode, this.code = 'UNKNOWN', this.message = '', this.details});
  factory _ApiErrorBody.fromJson(Map<String, dynamic> json) => _$ApiErrorBodyFromJson(json);

@override final  int statusCode;
@override@JsonKey() final  String code;
@override@JsonKey() final  String message;
@override final  Object? details;

/// Create a copy of ApiErrorBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiErrorBodyCopyWith<_ApiErrorBody> get copyWith => __$ApiErrorBodyCopyWithImpl<_ApiErrorBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiErrorBodyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiErrorBody&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,code,message,const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'ApiErrorBody(statusCode: $statusCode, code: $code, message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class _$ApiErrorBodyCopyWith<$Res> implements $ApiErrorBodyCopyWith<$Res> {
  factory _$ApiErrorBodyCopyWith(_ApiErrorBody value, $Res Function(_ApiErrorBody) _then) = __$ApiErrorBodyCopyWithImpl;
@override @useResult
$Res call({
 int statusCode, String code, String message, Object? details
});




}
/// @nodoc
class __$ApiErrorBodyCopyWithImpl<$Res>
    implements _$ApiErrorBodyCopyWith<$Res> {
  __$ApiErrorBodyCopyWithImpl(this._self, this._then);

  final _ApiErrorBody _self;
  final $Res Function(_ApiErrorBody) _then;

/// Create a copy of ApiErrorBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = null,Object? code = null,Object? message = null,Object? details = freezed,}) {
  return _then(_ApiErrorBody(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details ,
  ));
}


}


/// @nodoc
mixin _$UploadedImage {

@JsonKey(readValue: readId) String get id; String? get contentType; int? get size; int? get width; int? get height;
/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadedImageCopyWith<UploadedImage> get copyWith => _$UploadedImageCopyWithImpl<UploadedImage>(this as UploadedImage, _$identity);

  /// Serializes this UploadedImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadedImage&&(identical(other.id, id) || other.id == id)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contentType,size,width,height);

@override
String toString() {
  return 'UploadedImage(id: $id, contentType: $contentType, size: $size, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $UploadedImageCopyWith<$Res>  {
  factory $UploadedImageCopyWith(UploadedImage value, $Res Function(UploadedImage) _then) = _$UploadedImageCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String? contentType, int? size, int? width, int? height
});




}
/// @nodoc
class _$UploadedImageCopyWithImpl<$Res>
    implements $UploadedImageCopyWith<$Res> {
  _$UploadedImageCopyWithImpl(this._self, this._then);

  final UploadedImage _self;
  final $Res Function(UploadedImage) _then;

/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contentType = freezed,Object? size = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadedImage].
extension UploadedImagePatterns on UploadedImage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadedImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadedImage value)  $default,){
final _that = this;
switch (_that) {
case _UploadedImage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadedImage value)?  $default,){
final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String? contentType,  int? size,  int? width,  int? height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
return $default(_that.id,_that.contentType,_that.size,_that.width,_that.height);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String? contentType,  int? size,  int? width,  int? height)  $default,) {final _that = this;
switch (_that) {
case _UploadedImage():
return $default(_that.id,_that.contentType,_that.size,_that.width,_that.height);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String? contentType,  int? size,  int? width,  int? height)?  $default,) {final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
return $default(_that.id,_that.contentType,_that.size,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadedImage implements UploadedImage {
  const _UploadedImage({@JsonKey(readValue: readId) required this.id, this.contentType, this.size, this.width, this.height});
  factory _UploadedImage.fromJson(Map<String, dynamic> json) => _$UploadedImageFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String? contentType;
@override final  int? size;
@override final  int? width;
@override final  int? height;

/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadedImageCopyWith<_UploadedImage> get copyWith => __$UploadedImageCopyWithImpl<_UploadedImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadedImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadedImage&&(identical(other.id, id) || other.id == id)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contentType,size,width,height);

@override
String toString() {
  return 'UploadedImage(id: $id, contentType: $contentType, size: $size, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$UploadedImageCopyWith<$Res> implements $UploadedImageCopyWith<$Res> {
  factory _$UploadedImageCopyWith(_UploadedImage value, $Res Function(_UploadedImage) _then) = __$UploadedImageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String? contentType, int? size, int? width, int? height
});




}
/// @nodoc
class __$UploadedImageCopyWithImpl<$Res>
    implements _$UploadedImageCopyWith<$Res> {
  __$UploadedImageCopyWithImpl(this._self, this._then);

  final _UploadedImage _self;
  final $Res Function(_UploadedImage) _then;

/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contentType = freezed,Object? size = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_UploadedImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
