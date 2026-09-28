// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryOffer {

 String get riderId;@DateTimeConverter() DateTime get at; String? get response;@NullableDateTimeConverter() DateTime? get respondedAt;
/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryOfferCopyWith<DeliveryOffer> get copyWith => _$DeliveryOfferCopyWithImpl<DeliveryOffer>(this as DeliveryOffer, _$identity);

  /// Serializes this DeliveryOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryOffer&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.at, at) || other.at == at)&&(identical(other.response, response) || other.response == response)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riderId,at,response,respondedAt);

@override
String toString() {
  return 'DeliveryOffer(riderId: $riderId, at: $at, response: $response, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class $DeliveryOfferCopyWith<$Res>  {
  factory $DeliveryOfferCopyWith(DeliveryOffer value, $Res Function(DeliveryOffer) _then) = _$DeliveryOfferCopyWithImpl;
@useResult
$Res call({
 String riderId,@DateTimeConverter() DateTime at, String? response,@NullableDateTimeConverter() DateTime? respondedAt
});




}
/// @nodoc
class _$DeliveryOfferCopyWithImpl<$Res>
    implements $DeliveryOfferCopyWith<$Res> {
  _$DeliveryOfferCopyWithImpl(this._self, this._then);

  final DeliveryOffer _self;
  final $Res Function(DeliveryOffer) _then;

/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? riderId = null,Object? at = null,Object? response = freezed,Object? respondedAt = freezed,}) {
  return _then(_self.copyWith(
riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryOffer].
extension DeliveryOfferPatterns on DeliveryOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryOffer value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryOffer value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String riderId, @DateTimeConverter()  DateTime at,  String? response, @NullableDateTimeConverter()  DateTime? respondedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
return $default(_that.riderId,_that.at,_that.response,_that.respondedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String riderId, @DateTimeConverter()  DateTime at,  String? response, @NullableDateTimeConverter()  DateTime? respondedAt)  $default,) {final _that = this;
switch (_that) {
case _DeliveryOffer():
return $default(_that.riderId,_that.at,_that.response,_that.respondedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String riderId, @DateTimeConverter()  DateTime at,  String? response, @NullableDateTimeConverter()  DateTime? respondedAt)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
return $default(_that.riderId,_that.at,_that.response,_that.respondedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryOffer extends DeliveryOffer {
  const _DeliveryOffer({required this.riderId, @DateTimeConverter() required this.at, this.response, @NullableDateTimeConverter() this.respondedAt}): super._();
  factory _DeliveryOffer.fromJson(Map<String, dynamic> json) => _$DeliveryOfferFromJson(json);

@override final  String riderId;
@override@DateTimeConverter() final  DateTime at;
@override final  String? response;
@override@NullableDateTimeConverter() final  DateTime? respondedAt;

/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryOfferCopyWith<_DeliveryOffer> get copyWith => __$DeliveryOfferCopyWithImpl<_DeliveryOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryOffer&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.at, at) || other.at == at)&&(identical(other.response, response) || other.response == response)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riderId,at,response,respondedAt);

@override
String toString() {
  return 'DeliveryOffer(riderId: $riderId, at: $at, response: $response, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class _$DeliveryOfferCopyWith<$Res> implements $DeliveryOfferCopyWith<$Res> {
  factory _$DeliveryOfferCopyWith(_DeliveryOffer value, $Res Function(_DeliveryOffer) _then) = __$DeliveryOfferCopyWithImpl;
@override @useResult
$Res call({
 String riderId,@DateTimeConverter() DateTime at, String? response,@NullableDateTimeConverter() DateTime? respondedAt
});




}
/// @nodoc
class __$DeliveryOfferCopyWithImpl<$Res>
    implements _$DeliveryOfferCopyWith<$Res> {
  __$DeliveryOfferCopyWithImpl(this._self, this._then);

  final _DeliveryOffer _self;
  final $Res Function(_DeliveryOffer) _then;

/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? riderId = null,Object? at = null,Object? response = freezed,Object? respondedAt = freezed,}) {
  return _then(_DeliveryOffer(
riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DeliveryProof {

 String? get photoImageId; String? get otp;@NullableDateTimeConverter() DateTime? get otpVerifiedAt;
/// Create a copy of DeliveryProof
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryProofCopyWith<DeliveryProof> get copyWith => _$DeliveryProofCopyWithImpl<DeliveryProof>(this as DeliveryProof, _$identity);

  /// Serializes this DeliveryProof to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryProof&&(identical(other.photoImageId, photoImageId) || other.photoImageId == photoImageId)&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.otpVerifiedAt, otpVerifiedAt) || other.otpVerifiedAt == otpVerifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,photoImageId,otp,otpVerifiedAt);

@override
String toString() {
  return 'DeliveryProof(photoImageId: $photoImageId, otp: $otp, otpVerifiedAt: $otpVerifiedAt)';
}


}

/// @nodoc
abstract mixin class $DeliveryProofCopyWith<$Res>  {
  factory $DeliveryProofCopyWith(DeliveryProof value, $Res Function(DeliveryProof) _then) = _$DeliveryProofCopyWithImpl;
@useResult
$Res call({
 String? photoImageId, String? otp,@NullableDateTimeConverter() DateTime? otpVerifiedAt
});




}
/// @nodoc
class _$DeliveryProofCopyWithImpl<$Res>
    implements $DeliveryProofCopyWith<$Res> {
  _$DeliveryProofCopyWithImpl(this._self, this._then);

  final DeliveryProof _self;
  final $Res Function(DeliveryProof) _then;

/// Create a copy of DeliveryProof
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photoImageId = freezed,Object? otp = freezed,Object? otpVerifiedAt = freezed,}) {
  return _then(_self.copyWith(
photoImageId: freezed == photoImageId ? _self.photoImageId : photoImageId // ignore: cast_nullable_to_non_nullable
as String?,otp: freezed == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String?,otpVerifiedAt: freezed == otpVerifiedAt ? _self.otpVerifiedAt : otpVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryProof].
extension DeliveryProofPatterns on DeliveryProof {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryProof value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryProof() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryProof value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryProof():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryProof value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryProof() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? photoImageId,  String? otp, @NullableDateTimeConverter()  DateTime? otpVerifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryProof() when $default != null:
return $default(_that.photoImageId,_that.otp,_that.otpVerifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? photoImageId,  String? otp, @NullableDateTimeConverter()  DateTime? otpVerifiedAt)  $default,) {final _that = this;
switch (_that) {
case _DeliveryProof():
return $default(_that.photoImageId,_that.otp,_that.otpVerifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? photoImageId,  String? otp, @NullableDateTimeConverter()  DateTime? otpVerifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryProof() when $default != null:
return $default(_that.photoImageId,_that.otp,_that.otpVerifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryProof implements DeliveryProof {
  const _DeliveryProof({this.photoImageId, this.otp, @NullableDateTimeConverter() this.otpVerifiedAt});
  factory _DeliveryProof.fromJson(Map<String, dynamic> json) => _$DeliveryProofFromJson(json);

@override final  String? photoImageId;
@override final  String? otp;
@override@NullableDateTimeConverter() final  DateTime? otpVerifiedAt;

/// Create a copy of DeliveryProof
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryProofCopyWith<_DeliveryProof> get copyWith => __$DeliveryProofCopyWithImpl<_DeliveryProof>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryProofToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryProof&&(identical(other.photoImageId, photoImageId) || other.photoImageId == photoImageId)&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.otpVerifiedAt, otpVerifiedAt) || other.otpVerifiedAt == otpVerifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,photoImageId,otp,otpVerifiedAt);

@override
String toString() {
  return 'DeliveryProof(photoImageId: $photoImageId, otp: $otp, otpVerifiedAt: $otpVerifiedAt)';
}


}

/// @nodoc
abstract mixin class _$DeliveryProofCopyWith<$Res> implements $DeliveryProofCopyWith<$Res> {
  factory _$DeliveryProofCopyWith(_DeliveryProof value, $Res Function(_DeliveryProof) _then) = __$DeliveryProofCopyWithImpl;
@override @useResult
$Res call({
 String? photoImageId, String? otp,@NullableDateTimeConverter() DateTime? otpVerifiedAt
});




}
/// @nodoc
class __$DeliveryProofCopyWithImpl<$Res>
    implements _$DeliveryProofCopyWith<$Res> {
  __$DeliveryProofCopyWithImpl(this._self, this._then);

  final _DeliveryProof _self;
  final $Res Function(_DeliveryProof) _then;

/// Create a copy of DeliveryProof
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photoImageId = freezed,Object? otp = freezed,Object? otpVerifiedAt = freezed,}) {
  return _then(_DeliveryProof(
photoImageId: freezed == photoImageId ? _self.photoImageId : photoImageId // ignore: cast_nullable_to_non_nullable
as String?,otp: freezed == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String?,otpVerifiedAt: freezed == otpVerifiedAt ? _self.otpVerifiedAt : otpVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DropoffPoint {

 double get lat; double get lng; AddressSnapshot? get addressSnapshot;
/// Create a copy of DropoffPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DropoffPointCopyWith<DropoffPoint> get copyWith => _$DropoffPointCopyWithImpl<DropoffPoint>(this as DropoffPoint, _$identity);

  /// Serializes this DropoffPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DropoffPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.addressSnapshot, addressSnapshot) || other.addressSnapshot == addressSnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,addressSnapshot);

@override
String toString() {
  return 'DropoffPoint(lat: $lat, lng: $lng, addressSnapshot: $addressSnapshot)';
}


}

/// @nodoc
abstract mixin class $DropoffPointCopyWith<$Res>  {
  factory $DropoffPointCopyWith(DropoffPoint value, $Res Function(DropoffPoint) _then) = _$DropoffPointCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, AddressSnapshot? addressSnapshot
});


$AddressSnapshotCopyWith<$Res>? get addressSnapshot;

}
/// @nodoc
class _$DropoffPointCopyWithImpl<$Res>
    implements $DropoffPointCopyWith<$Res> {
  _$DropoffPointCopyWithImpl(this._self, this._then);

  final DropoffPoint _self;
  final $Res Function(DropoffPoint) _then;

/// Create a copy of DropoffPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? addressSnapshot = freezed,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,addressSnapshot: freezed == addressSnapshot ? _self.addressSnapshot : addressSnapshot // ignore: cast_nullable_to_non_nullable
as AddressSnapshot?,
  ));
}
/// Create a copy of DropoffPoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressSnapshotCopyWith<$Res>? get addressSnapshot {
    if (_self.addressSnapshot == null) {
    return null;
  }

  return $AddressSnapshotCopyWith<$Res>(_self.addressSnapshot!, (value) {
    return _then(_self.copyWith(addressSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [DropoffPoint].
extension DropoffPointPatterns on DropoffPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DropoffPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DropoffPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DropoffPoint value)  $default,){
final _that = this;
switch (_that) {
case _DropoffPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DropoffPoint value)?  $default,){
final _that = this;
switch (_that) {
case _DropoffPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  AddressSnapshot? addressSnapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DropoffPoint() when $default != null:
return $default(_that.lat,_that.lng,_that.addressSnapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  AddressSnapshot? addressSnapshot)  $default,) {final _that = this;
switch (_that) {
case _DropoffPoint():
return $default(_that.lat,_that.lng,_that.addressSnapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  AddressSnapshot? addressSnapshot)?  $default,) {final _that = this;
switch (_that) {
case _DropoffPoint() when $default != null:
return $default(_that.lat,_that.lng,_that.addressSnapshot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DropoffPoint implements DropoffPoint {
  const _DropoffPoint({required this.lat, required this.lng, this.addressSnapshot});
  factory _DropoffPoint.fromJson(Map<String, dynamic> json) => _$DropoffPointFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  AddressSnapshot? addressSnapshot;

/// Create a copy of DropoffPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DropoffPointCopyWith<_DropoffPoint> get copyWith => __$DropoffPointCopyWithImpl<_DropoffPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DropoffPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DropoffPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.addressSnapshot, addressSnapshot) || other.addressSnapshot == addressSnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,addressSnapshot);

@override
String toString() {
  return 'DropoffPoint(lat: $lat, lng: $lng, addressSnapshot: $addressSnapshot)';
}


}

/// @nodoc
abstract mixin class _$DropoffPointCopyWith<$Res> implements $DropoffPointCopyWith<$Res> {
  factory _$DropoffPointCopyWith(_DropoffPoint value, $Res Function(_DropoffPoint) _then) = __$DropoffPointCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, AddressSnapshot? addressSnapshot
});


@override $AddressSnapshotCopyWith<$Res>? get addressSnapshot;

}
/// @nodoc
class __$DropoffPointCopyWithImpl<$Res>
    implements _$DropoffPointCopyWith<$Res> {
  __$DropoffPointCopyWithImpl(this._self, this._then);

  final _DropoffPoint _self;
  final $Res Function(_DropoffPoint) _then;

/// Create a copy of DropoffPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? addressSnapshot = freezed,}) {
  return _then(_DropoffPoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,addressSnapshot: freezed == addressSnapshot ? _self.addressSnapshot : addressSnapshot // ignore: cast_nullable_to_non_nullable
as AddressSnapshot?,
  ));
}

/// Create a copy of DropoffPoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressSnapshotCopyWith<$Res>? get addressSnapshot {
    if (_self.addressSnapshot == null) {
    return null;
  }

  return $AddressSnapshotCopyWith<$Res>(_self.addressSnapshot!, (value) {
    return _then(_self.copyWith(addressSnapshot: value));
  });
}
}


/// @nodoc
mixin _$PickupPoint {

 double get lat; double get lng; String? get vendorName; String? get line1;
/// Create a copy of PickupPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickupPointCopyWith<PickupPoint> get copyWith => _$PickupPointCopyWithImpl<PickupPoint>(this as PickupPoint, _$identity);

  /// Serializes this PickupPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickupPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.line1, line1) || other.line1 == line1));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,vendorName,line1);

@override
String toString() {
  return 'PickupPoint(lat: $lat, lng: $lng, vendorName: $vendorName, line1: $line1)';
}


}

/// @nodoc
abstract mixin class $PickupPointCopyWith<$Res>  {
  factory $PickupPointCopyWith(PickupPoint value, $Res Function(PickupPoint) _then) = _$PickupPointCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, String? vendorName, String? line1
});




}
/// @nodoc
class _$PickupPointCopyWithImpl<$Res>
    implements $PickupPointCopyWith<$Res> {
  _$PickupPointCopyWithImpl(this._self, this._then);

  final PickupPoint _self;
  final $Res Function(PickupPoint) _then;

/// Create a copy of PickupPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? vendorName = freezed,Object? line1 = freezed,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,line1: freezed == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PickupPoint].
extension PickupPointPatterns on PickupPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickupPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickupPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickupPoint value)  $default,){
final _that = this;
switch (_that) {
case _PickupPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickupPoint value)?  $default,){
final _that = this;
switch (_that) {
case _PickupPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  String? vendorName,  String? line1)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickupPoint() when $default != null:
return $default(_that.lat,_that.lng,_that.vendorName,_that.line1);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  String? vendorName,  String? line1)  $default,) {final _that = this;
switch (_that) {
case _PickupPoint():
return $default(_that.lat,_that.lng,_that.vendorName,_that.line1);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  String? vendorName,  String? line1)?  $default,) {final _that = this;
switch (_that) {
case _PickupPoint() when $default != null:
return $default(_that.lat,_that.lng,_that.vendorName,_that.line1);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PickupPoint implements PickupPoint {
  const _PickupPoint({required this.lat, required this.lng, this.vendorName, this.line1});
  factory _PickupPoint.fromJson(Map<String, dynamic> json) => _$PickupPointFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  String? vendorName;
@override final  String? line1;

/// Create a copy of PickupPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickupPointCopyWith<_PickupPoint> get copyWith => __$PickupPointCopyWithImpl<_PickupPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PickupPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickupPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.line1, line1) || other.line1 == line1));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,vendorName,line1);

@override
String toString() {
  return 'PickupPoint(lat: $lat, lng: $lng, vendorName: $vendorName, line1: $line1)';
}


}

/// @nodoc
abstract mixin class _$PickupPointCopyWith<$Res> implements $PickupPointCopyWith<$Res> {
  factory _$PickupPointCopyWith(_PickupPoint value, $Res Function(_PickupPoint) _then) = __$PickupPointCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, String? vendorName, String? line1
});




}
/// @nodoc
class __$PickupPointCopyWithImpl<$Res>
    implements _$PickupPointCopyWith<$Res> {
  __$PickupPointCopyWithImpl(this._self, this._then);

  final _PickupPoint _self;
  final $Res Function(_PickupPoint) _then;

/// Create a copy of PickupPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? vendorName = freezed,Object? line1 = freezed,}) {
  return _then(_PickupPoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,line1: freezed == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Delivery {

@JsonKey(readValue: readId) String get id; String get subOrderId; String get vendorId; String? get orderId; String? get riderId; DeliveryStatus get status; PickupPoint? get pickup; DropoffPoint? get dropoff; List<DeliveryOffer> get offeredTo; DeliveryProof? get proof; List<TimelineEntry> get timeline; String? get orderNumber; String? get customerName; String? get customerPhone;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryCopyWith<Delivery> get copyWith => _$DeliveryCopyWithImpl<Delivery>(this as Delivery, _$identity);

  /// Serializes this Delivery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Delivery&&(identical(other.id, id) || other.id == id)&&(identical(other.subOrderId, subOrderId) || other.subOrderId == subOrderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff)&&const DeepCollectionEquality().equals(other.offeredTo, offeredTo)&&(identical(other.proof, proof) || other.proof == proof)&&const DeepCollectionEquality().equals(other.timeline, timeline)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subOrderId,vendorId,orderId,riderId,status,pickup,dropoff,const DeepCollectionEquality().hash(offeredTo),proof,const DeepCollectionEquality().hash(timeline),orderNumber,customerName,customerPhone,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Delivery(id: $id, subOrderId: $subOrderId, vendorId: $vendorId, orderId: $orderId, riderId: $riderId, status: $status, pickup: $pickup, dropoff: $dropoff, offeredTo: $offeredTo, proof: $proof, timeline: $timeline, orderNumber: $orderNumber, customerName: $customerName, customerPhone: $customerPhone, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $DeliveryCopyWith<$Res>  {
  factory $DeliveryCopyWith(Delivery value, $Res Function(Delivery) _then) = _$DeliveryCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String subOrderId, String vendorId, String? orderId, String? riderId, DeliveryStatus status, PickupPoint? pickup, DropoffPoint? dropoff, List<DeliveryOffer> offeredTo, DeliveryProof? proof, List<TimelineEntry> timeline, String? orderNumber, String? customerName, String? customerPhone,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


$PickupPointCopyWith<$Res>? get pickup;$DropoffPointCopyWith<$Res>? get dropoff;$DeliveryProofCopyWith<$Res>? get proof;

}
/// @nodoc
class _$DeliveryCopyWithImpl<$Res>
    implements $DeliveryCopyWith<$Res> {
  _$DeliveryCopyWithImpl(this._self, this._then);

  final Delivery _self;
  final $Res Function(Delivery) _then;

/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subOrderId = null,Object? vendorId = null,Object? orderId = freezed,Object? riderId = freezed,Object? status = null,Object? pickup = freezed,Object? dropoff = freezed,Object? offeredTo = null,Object? proof = freezed,Object? timeline = null,Object? orderNumber = freezed,Object? customerName = freezed,Object? customerPhone = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subOrderId: null == subOrderId ? _self.subOrderId : subOrderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,riderId: freezed == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeliveryStatus,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as PickupPoint?,dropoff: freezed == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as DropoffPoint?,offeredTo: null == offeredTo ? _self.offeredTo : offeredTo // ignore: cast_nullable_to_non_nullable
as List<DeliveryOffer>,proof: freezed == proof ? _self.proof : proof // ignore: cast_nullable_to_non_nullable
as DeliveryProof?,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEntry>,orderNumber: freezed == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PickupPointCopyWith<$Res>? get pickup {
    if (_self.pickup == null) {
    return null;
  }

  return $PickupPointCopyWith<$Res>(_self.pickup!, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropoffPointCopyWith<$Res>? get dropoff {
    if (_self.dropoff == null) {
    return null;
  }

  return $DropoffPointCopyWith<$Res>(_self.dropoff!, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryProofCopyWith<$Res>? get proof {
    if (_self.proof == null) {
    return null;
  }

  return $DeliveryProofCopyWith<$Res>(_self.proof!, (value) {
    return _then(_self.copyWith(proof: value));
  });
}
}


/// Adds pattern-matching-related methods to [Delivery].
extension DeliveryPatterns on Delivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Delivery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Delivery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Delivery value)  $default,){
final _that = this;
switch (_that) {
case _Delivery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Delivery value)?  $default,){
final _that = this;
switch (_that) {
case _Delivery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String subOrderId,  String vendorId,  String? orderId,  String? riderId,  DeliveryStatus status,  PickupPoint? pickup,  DropoffPoint? dropoff,  List<DeliveryOffer> offeredTo,  DeliveryProof? proof,  List<TimelineEntry> timeline,  String? orderNumber,  String? customerName,  String? customerPhone, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Delivery() when $default != null:
return $default(_that.id,_that.subOrderId,_that.vendorId,_that.orderId,_that.riderId,_that.status,_that.pickup,_that.dropoff,_that.offeredTo,_that.proof,_that.timeline,_that.orderNumber,_that.customerName,_that.customerPhone,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String subOrderId,  String vendorId,  String? orderId,  String? riderId,  DeliveryStatus status,  PickupPoint? pickup,  DropoffPoint? dropoff,  List<DeliveryOffer> offeredTo,  DeliveryProof? proof,  List<TimelineEntry> timeline,  String? orderNumber,  String? customerName,  String? customerPhone, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _Delivery():
return $default(_that.id,_that.subOrderId,_that.vendorId,_that.orderId,_that.riderId,_that.status,_that.pickup,_that.dropoff,_that.offeredTo,_that.proof,_that.timeline,_that.orderNumber,_that.customerName,_that.customerPhone,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String subOrderId,  String vendorId,  String? orderId,  String? riderId,  DeliveryStatus status,  PickupPoint? pickup,  DropoffPoint? dropoff,  List<DeliveryOffer> offeredTo,  DeliveryProof? proof,  List<TimelineEntry> timeline,  String? orderNumber,  String? customerName,  String? customerPhone, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Delivery() when $default != null:
return $default(_that.id,_that.subOrderId,_that.vendorId,_that.orderId,_that.riderId,_that.status,_that.pickup,_that.dropoff,_that.offeredTo,_that.proof,_that.timeline,_that.orderNumber,_that.customerName,_that.customerPhone,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Delivery extends Delivery {
  const _Delivery({@JsonKey(readValue: readId) required this.id, required this.subOrderId, required this.vendorId, this.orderId, this.riderId, this.status = DeliveryStatus.unassigned, this.pickup, this.dropoff, final  List<DeliveryOffer> offeredTo = const <DeliveryOffer>[], this.proof, final  List<TimelineEntry> timeline = const <TimelineEntry>[], this.orderNumber, this.customerName, this.customerPhone, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0}): _offeredTo = offeredTo,_timeline = timeline,super._();
  factory _Delivery.fromJson(Map<String, dynamic> json) => _$DeliveryFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String subOrderId;
@override final  String vendorId;
@override final  String? orderId;
@override final  String? riderId;
@override@JsonKey() final  DeliveryStatus status;
@override final  PickupPoint? pickup;
@override final  DropoffPoint? dropoff;
 final  List<DeliveryOffer> _offeredTo;
@override@JsonKey() List<DeliveryOffer> get offeredTo {
  if (_offeredTo is EqualUnmodifiableListView) return _offeredTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offeredTo);
}

@override final  DeliveryProof? proof;
 final  List<TimelineEntry> _timeline;
@override@JsonKey() List<TimelineEntry> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}

@override final  String? orderNumber;
@override final  String? customerName;
@override final  String? customerPhone;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryCopyWith<_Delivery> get copyWith => __$DeliveryCopyWithImpl<_Delivery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Delivery&&(identical(other.id, id) || other.id == id)&&(identical(other.subOrderId, subOrderId) || other.subOrderId == subOrderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff)&&const DeepCollectionEquality().equals(other._offeredTo, _offeredTo)&&(identical(other.proof, proof) || other.proof == proof)&&const DeepCollectionEquality().equals(other._timeline, _timeline)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subOrderId,vendorId,orderId,riderId,status,pickup,dropoff,const DeepCollectionEquality().hash(_offeredTo),proof,const DeepCollectionEquality().hash(_timeline),orderNumber,customerName,customerPhone,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Delivery(id: $id, subOrderId: $subOrderId, vendorId: $vendorId, orderId: $orderId, riderId: $riderId, status: $status, pickup: $pickup, dropoff: $dropoff, offeredTo: $offeredTo, proof: $proof, timeline: $timeline, orderNumber: $orderNumber, customerName: $customerName, customerPhone: $customerPhone, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$DeliveryCopyWith<$Res> implements $DeliveryCopyWith<$Res> {
  factory _$DeliveryCopyWith(_Delivery value, $Res Function(_Delivery) _then) = __$DeliveryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String subOrderId, String vendorId, String? orderId, String? riderId, DeliveryStatus status, PickupPoint? pickup, DropoffPoint? dropoff, List<DeliveryOffer> offeredTo, DeliveryProof? proof, List<TimelineEntry> timeline, String? orderNumber, String? customerName, String? customerPhone,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


@override $PickupPointCopyWith<$Res>? get pickup;@override $DropoffPointCopyWith<$Res>? get dropoff;@override $DeliveryProofCopyWith<$Res>? get proof;

}
/// @nodoc
class __$DeliveryCopyWithImpl<$Res>
    implements _$DeliveryCopyWith<$Res> {
  __$DeliveryCopyWithImpl(this._self, this._then);

  final _Delivery _self;
  final $Res Function(_Delivery) _then;

/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subOrderId = null,Object? vendorId = null,Object? orderId = freezed,Object? riderId = freezed,Object? status = null,Object? pickup = freezed,Object? dropoff = freezed,Object? offeredTo = null,Object? proof = freezed,Object? timeline = null,Object? orderNumber = freezed,Object? customerName = freezed,Object? customerPhone = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_Delivery(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subOrderId: null == subOrderId ? _self.subOrderId : subOrderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,riderId: freezed == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeliveryStatus,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as PickupPoint?,dropoff: freezed == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as DropoffPoint?,offeredTo: null == offeredTo ? _self._offeredTo : offeredTo // ignore: cast_nullable_to_non_nullable
as List<DeliveryOffer>,proof: freezed == proof ? _self.proof : proof // ignore: cast_nullable_to_non_nullable
as DeliveryProof?,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEntry>,orderNumber: freezed == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PickupPointCopyWith<$Res>? get pickup {
    if (_self.pickup == null) {
    return null;
  }

  return $PickupPointCopyWith<$Res>(_self.pickup!, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropoffPointCopyWith<$Res>? get dropoff {
    if (_self.dropoff == null) {
    return null;
  }

  return $DropoffPointCopyWith<$Res>(_self.dropoff!, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryProofCopyWith<$Res>? get proof {
    if (_self.proof == null) {
    return null;
  }

  return $DeliveryProofCopyWith<$Res>(_self.proof!, (value) {
    return _then(_self.copyWith(proof: value));
  });
}
}

// dart format on
