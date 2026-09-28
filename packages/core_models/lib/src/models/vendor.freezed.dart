// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorAddress {

 String get line1; String get city; String get state; String get country; double get lat; double get lng;
/// Create a copy of VendorAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorAddressCopyWith<VendorAddress> get copyWith => _$VendorAddressCopyWithImpl<VendorAddress>(this as VendorAddress, _$identity);

  /// Serializes this VendorAddress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorAddress&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,line1,city,state,country,lat,lng);

@override
String toString() {
  return 'VendorAddress(line1: $line1, city: $city, state: $state, country: $country, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $VendorAddressCopyWith<$Res>  {
  factory $VendorAddressCopyWith(VendorAddress value, $Res Function(VendorAddress) _then) = _$VendorAddressCopyWithImpl;
@useResult
$Res call({
 String line1, String city, String state, String country, double lat, double lng
});




}
/// @nodoc
class _$VendorAddressCopyWithImpl<$Res>
    implements $VendorAddressCopyWith<$Res> {
  _$VendorAddressCopyWithImpl(this._self, this._then);

  final VendorAddress _self;
  final $Res Function(VendorAddress) _then;

/// Create a copy of VendorAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? line1 = null,Object? city = null,Object? state = null,Object? country = null,Object? lat = null,Object? lng = null,}) {
  return _then(_self.copyWith(
line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorAddress].
extension VendorAddressPatterns on VendorAddress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorAddress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorAddress value)  $default,){
final _that = this;
switch (_that) {
case _VendorAddress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorAddress value)?  $default,){
final _that = this;
switch (_that) {
case _VendorAddress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String line1,  String city,  String state,  String country,  double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorAddress() when $default != null:
return $default(_that.line1,_that.city,_that.state,_that.country,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String line1,  String city,  String state,  String country,  double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _VendorAddress():
return $default(_that.line1,_that.city,_that.state,_that.country,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String line1,  String city,  String state,  String country,  double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _VendorAddress() when $default != null:
return $default(_that.line1,_that.city,_that.state,_that.country,_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorAddress implements VendorAddress {
  const _VendorAddress({required this.line1, required this.city, required this.state, this.country = 'NG', required this.lat, required this.lng});
  factory _VendorAddress.fromJson(Map<String, dynamic> json) => _$VendorAddressFromJson(json);

@override final  String line1;
@override final  String city;
@override final  String state;
@override@JsonKey() final  String country;
@override final  double lat;
@override final  double lng;

/// Create a copy of VendorAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorAddressCopyWith<_VendorAddress> get copyWith => __$VendorAddressCopyWithImpl<_VendorAddress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorAddressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorAddress&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,line1,city,state,country,lat,lng);

@override
String toString() {
  return 'VendorAddress(line1: $line1, city: $city, state: $state, country: $country, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$VendorAddressCopyWith<$Res> implements $VendorAddressCopyWith<$Res> {
  factory _$VendorAddressCopyWith(_VendorAddress value, $Res Function(_VendorAddress) _then) = __$VendorAddressCopyWithImpl;
@override @useResult
$Res call({
 String line1, String city, String state, String country, double lat, double lng
});




}
/// @nodoc
class __$VendorAddressCopyWithImpl<$Res>
    implements _$VendorAddressCopyWith<$Res> {
  __$VendorAddressCopyWithImpl(this._self, this._then);

  final _VendorAddress _self;
  final $Res Function(_VendorAddress) _then;

/// Create a copy of VendorAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? line1 = null,Object? city = null,Object? state = null,Object? country = null,Object? lat = null,Object? lng = null,}) {
  return _then(_VendorAddress(
line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DeliveryFeeConfig {

 int get baseKobo; int get perKmKobo; int? get freeAboveKobo;
/// Create a copy of DeliveryFeeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryFeeConfigCopyWith<DeliveryFeeConfig> get copyWith => _$DeliveryFeeConfigCopyWithImpl<DeliveryFeeConfig>(this as DeliveryFeeConfig, _$identity);

  /// Serializes this DeliveryFeeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryFeeConfig&&(identical(other.baseKobo, baseKobo) || other.baseKobo == baseKobo)&&(identical(other.perKmKobo, perKmKobo) || other.perKmKobo == perKmKobo)&&(identical(other.freeAboveKobo, freeAboveKobo) || other.freeAboveKobo == freeAboveKobo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseKobo,perKmKobo,freeAboveKobo);

@override
String toString() {
  return 'DeliveryFeeConfig(baseKobo: $baseKobo, perKmKobo: $perKmKobo, freeAboveKobo: $freeAboveKobo)';
}


}

/// @nodoc
abstract mixin class $DeliveryFeeConfigCopyWith<$Res>  {
  factory $DeliveryFeeConfigCopyWith(DeliveryFeeConfig value, $Res Function(DeliveryFeeConfig) _then) = _$DeliveryFeeConfigCopyWithImpl;
@useResult
$Res call({
 int baseKobo, int perKmKobo, int? freeAboveKobo
});




}
/// @nodoc
class _$DeliveryFeeConfigCopyWithImpl<$Res>
    implements $DeliveryFeeConfigCopyWith<$Res> {
  _$DeliveryFeeConfigCopyWithImpl(this._self, this._then);

  final DeliveryFeeConfig _self;
  final $Res Function(DeliveryFeeConfig) _then;

/// Create a copy of DeliveryFeeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseKobo = null,Object? perKmKobo = null,Object? freeAboveKobo = freezed,}) {
  return _then(_self.copyWith(
baseKobo: null == baseKobo ? _self.baseKobo : baseKobo // ignore: cast_nullable_to_non_nullable
as int,perKmKobo: null == perKmKobo ? _self.perKmKobo : perKmKobo // ignore: cast_nullable_to_non_nullable
as int,freeAboveKobo: freezed == freeAboveKobo ? _self.freeAboveKobo : freeAboveKobo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryFeeConfig].
extension DeliveryFeeConfigPatterns on DeliveryFeeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryFeeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryFeeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryFeeConfig value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryFeeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryFeeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryFeeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int baseKobo,  int perKmKobo,  int? freeAboveKobo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryFeeConfig() when $default != null:
return $default(_that.baseKobo,_that.perKmKobo,_that.freeAboveKobo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int baseKobo,  int perKmKobo,  int? freeAboveKobo)  $default,) {final _that = this;
switch (_that) {
case _DeliveryFeeConfig():
return $default(_that.baseKobo,_that.perKmKobo,_that.freeAboveKobo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int baseKobo,  int perKmKobo,  int? freeAboveKobo)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryFeeConfig() when $default != null:
return $default(_that.baseKobo,_that.perKmKobo,_that.freeAboveKobo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryFeeConfig extends DeliveryFeeConfig {
  const _DeliveryFeeConfig({this.baseKobo = 0, this.perKmKobo = 0, this.freeAboveKobo}): super._();
  factory _DeliveryFeeConfig.fromJson(Map<String, dynamic> json) => _$DeliveryFeeConfigFromJson(json);

@override@JsonKey() final  int baseKobo;
@override@JsonKey() final  int perKmKobo;
@override final  int? freeAboveKobo;

/// Create a copy of DeliveryFeeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryFeeConfigCopyWith<_DeliveryFeeConfig> get copyWith => __$DeliveryFeeConfigCopyWithImpl<_DeliveryFeeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryFeeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryFeeConfig&&(identical(other.baseKobo, baseKobo) || other.baseKobo == baseKobo)&&(identical(other.perKmKobo, perKmKobo) || other.perKmKobo == perKmKobo)&&(identical(other.freeAboveKobo, freeAboveKobo) || other.freeAboveKobo == freeAboveKobo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseKobo,perKmKobo,freeAboveKobo);

@override
String toString() {
  return 'DeliveryFeeConfig(baseKobo: $baseKobo, perKmKobo: $perKmKobo, freeAboveKobo: $freeAboveKobo)';
}


}

/// @nodoc
abstract mixin class _$DeliveryFeeConfigCopyWith<$Res> implements $DeliveryFeeConfigCopyWith<$Res> {
  factory _$DeliveryFeeConfigCopyWith(_DeliveryFeeConfig value, $Res Function(_DeliveryFeeConfig) _then) = __$DeliveryFeeConfigCopyWithImpl;
@override @useResult
$Res call({
 int baseKobo, int perKmKobo, int? freeAboveKobo
});




}
/// @nodoc
class __$DeliveryFeeConfigCopyWithImpl<$Res>
    implements _$DeliveryFeeConfigCopyWith<$Res> {
  __$DeliveryFeeConfigCopyWithImpl(this._self, this._then);

  final _DeliveryFeeConfig _self;
  final $Res Function(_DeliveryFeeConfig) _then;

/// Create a copy of DeliveryFeeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseKobo = null,Object? perKmKobo = null,Object? freeAboveKobo = freezed,}) {
  return _then(_DeliveryFeeConfig(
baseKobo: null == baseKobo ? _self.baseKobo : baseKobo // ignore: cast_nullable_to_non_nullable
as int,perKmKobo: null == perKmKobo ? _self.perKmKobo : perKmKobo // ignore: cast_nullable_to_non_nullable
as int,freeAboveKobo: freezed == freeAboveKobo ? _self.freeAboveKobo : freeAboveKobo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$OpeningHours {

/// ISO weekday, 1 = Monday … 7 = Sunday. Read from `weekday`, or from the
/// backend's stored `day` (0 = Sunday … 6 = Saturday).
@JsonKey(readValue: readWeekday) int get weekday; String get open; String get close; bool get closed;
/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpeningHoursCopyWith<OpeningHours> get copyWith => _$OpeningHoursCopyWithImpl<OpeningHours>(this as OpeningHours, _$identity);

  /// Serializes this OpeningHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpeningHours&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.open, open) || other.open == open)&&(identical(other.close, close) || other.close == close)&&(identical(other.closed, closed) || other.closed == closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekday,open,close,closed);

@override
String toString() {
  return 'OpeningHours(weekday: $weekday, open: $open, close: $close, closed: $closed)';
}


}

/// @nodoc
abstract mixin class $OpeningHoursCopyWith<$Res>  {
  factory $OpeningHoursCopyWith(OpeningHours value, $Res Function(OpeningHours) _then) = _$OpeningHoursCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readWeekday) int weekday, String open, String close, bool closed
});




}
/// @nodoc
class _$OpeningHoursCopyWithImpl<$Res>
    implements $OpeningHoursCopyWith<$Res> {
  _$OpeningHoursCopyWithImpl(this._self, this._then);

  final OpeningHours _self;
  final $Res Function(OpeningHours) _then;

/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? open = null,Object? close = null,Object? closed = null,}) {
  return _then(_self.copyWith(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as String,close: null == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OpeningHours].
extension OpeningHoursPatterns on OpeningHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpeningHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpeningHours value)  $default,){
final _that = this;
switch (_that) {
case _OpeningHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpeningHours value)?  $default,){
final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readWeekday)  int weekday,  String open,  String close,  bool closed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
return $default(_that.weekday,_that.open,_that.close,_that.closed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readWeekday)  int weekday,  String open,  String close,  bool closed)  $default,) {final _that = this;
switch (_that) {
case _OpeningHours():
return $default(_that.weekday,_that.open,_that.close,_that.closed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readWeekday)  int weekday,  String open,  String close,  bool closed)?  $default,) {final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
return $default(_that.weekday,_that.open,_that.close,_that.closed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpeningHours extends OpeningHours {
  const _OpeningHours({@JsonKey(readValue: readWeekday) required this.weekday, this.open = '09:00', this.close = '18:00', this.closed = false}): super._();
  factory _OpeningHours.fromJson(Map<String, dynamic> json) => _$OpeningHoursFromJson(json);

/// ISO weekday, 1 = Monday … 7 = Sunday. Read from `weekday`, or from the
/// backend's stored `day` (0 = Sunday … 6 = Saturday).
@override@JsonKey(readValue: readWeekday) final  int weekday;
@override@JsonKey() final  String open;
@override@JsonKey() final  String close;
@override@JsonKey() final  bool closed;

/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpeningHoursCopyWith<_OpeningHours> get copyWith => __$OpeningHoursCopyWithImpl<_OpeningHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpeningHoursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpeningHours&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.open, open) || other.open == open)&&(identical(other.close, close) || other.close == close)&&(identical(other.closed, closed) || other.closed == closed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekday,open,close,closed);

@override
String toString() {
  return 'OpeningHours(weekday: $weekday, open: $open, close: $close, closed: $closed)';
}


}

/// @nodoc
abstract mixin class _$OpeningHoursCopyWith<$Res> implements $OpeningHoursCopyWith<$Res> {
  factory _$OpeningHoursCopyWith(_OpeningHours value, $Res Function(_OpeningHours) _then) = __$OpeningHoursCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readWeekday) int weekday, String open, String close, bool closed
});




}
/// @nodoc
class __$OpeningHoursCopyWithImpl<$Res>
    implements _$OpeningHoursCopyWith<$Res> {
  __$OpeningHoursCopyWithImpl(this._self, this._then);

  final _OpeningHours _self;
  final $Res Function(_OpeningHours) _then;

/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? open = null,Object? close = null,Object? closed = null,}) {
  return _then(_OpeningHours(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as String,close: null == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PayoutAccount {

 String get bankName; String get accountNumber; String get accountName;
/// Create a copy of PayoutAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutAccountCopyWith<PayoutAccount> get copyWith => _$PayoutAccountCopyWithImpl<PayoutAccount>(this as PayoutAccount, _$identity);

  /// Serializes this PayoutAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutAccount&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bankName,accountNumber,accountName);

@override
String toString() {
  return 'PayoutAccount(bankName: $bankName, accountNumber: $accountNumber, accountName: $accountName)';
}


}

/// @nodoc
abstract mixin class $PayoutAccountCopyWith<$Res>  {
  factory $PayoutAccountCopyWith(PayoutAccount value, $Res Function(PayoutAccount) _then) = _$PayoutAccountCopyWithImpl;
@useResult
$Res call({
 String bankName, String accountNumber, String accountName
});




}
/// @nodoc
class _$PayoutAccountCopyWithImpl<$Res>
    implements $PayoutAccountCopyWith<$Res> {
  _$PayoutAccountCopyWithImpl(this._self, this._then);

  final PayoutAccount _self;
  final $Res Function(PayoutAccount) _then;

/// Create a copy of PayoutAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bankName = null,Object? accountNumber = null,Object? accountName = null,}) {
  return _then(_self.copyWith(
bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutAccount].
extension PayoutAccountPatterns on PayoutAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutAccount value)  $default,){
final _that = this;
switch (_that) {
case _PayoutAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutAccount value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bankName,  String accountNumber,  String accountName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutAccount() when $default != null:
return $default(_that.bankName,_that.accountNumber,_that.accountName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bankName,  String accountNumber,  String accountName)  $default,) {final _that = this;
switch (_that) {
case _PayoutAccount():
return $default(_that.bankName,_that.accountNumber,_that.accountName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bankName,  String accountNumber,  String accountName)?  $default,) {final _that = this;
switch (_that) {
case _PayoutAccount() when $default != null:
return $default(_that.bankName,_that.accountNumber,_that.accountName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayoutAccount implements PayoutAccount {
  const _PayoutAccount({required this.bankName, required this.accountNumber, required this.accountName});
  factory _PayoutAccount.fromJson(Map<String, dynamic> json) => _$PayoutAccountFromJson(json);

@override final  String bankName;
@override final  String accountNumber;
@override final  String accountName;

/// Create a copy of PayoutAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutAccountCopyWith<_PayoutAccount> get copyWith => __$PayoutAccountCopyWithImpl<_PayoutAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayoutAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutAccount&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bankName,accountNumber,accountName);

@override
String toString() {
  return 'PayoutAccount(bankName: $bankName, accountNumber: $accountNumber, accountName: $accountName)';
}


}

/// @nodoc
abstract mixin class _$PayoutAccountCopyWith<$Res> implements $PayoutAccountCopyWith<$Res> {
  factory _$PayoutAccountCopyWith(_PayoutAccount value, $Res Function(_PayoutAccount) _then) = __$PayoutAccountCopyWithImpl;
@override @useResult
$Res call({
 String bankName, String accountNumber, String accountName
});




}
/// @nodoc
class __$PayoutAccountCopyWithImpl<$Res>
    implements _$PayoutAccountCopyWith<$Res> {
  __$PayoutAccountCopyWithImpl(this._self, this._then);

  final _PayoutAccount _self;
  final $Res Function(_PayoutAccount) _then;

/// Create a copy of PayoutAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bankName = null,Object? accountNumber = null,Object? accountName = null,}) {
  return _then(_PayoutAccount(
bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Vendor {

@JsonKey(readValue: readId) String get id; String get name; String get slug; String? get description; String? get logoImageId; String? get coverImageId; String get ownerUserId; VendorStatus get status; VendorAddress? get address; DeliveryFeeConfig? get deliveryFee; double? get deliveryRadiusKm; List<OpeningHours> get openingHours; int get commissionBps; PayoutAccount? get payout; double? get distanceKm;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorCopyWith<Vendor> get copyWith => _$VendorCopyWithImpl<Vendor>(this as Vendor, _$identity);

  /// Serializes this Vendor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vendor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoImageId, logoImageId) || other.logoImageId == logoImageId)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.address, address) || other.address == address)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.deliveryRadiusKm, deliveryRadiusKm) || other.deliveryRadiusKm == deliveryRadiusKm)&&const DeepCollectionEquality().equals(other.openingHours, openingHours)&&(identical(other.commissionBps, commissionBps) || other.commissionBps == commissionBps)&&(identical(other.payout, payout) || other.payout == payout)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,description,logoImageId,coverImageId,ownerUserId,status,address,deliveryFee,deliveryRadiusKm,const DeepCollectionEquality().hash(openingHours),commissionBps,payout,distanceKm,createdAt,updatedAt,deletedAt,version]);

@override
String toString() {
  return 'Vendor(id: $id, name: $name, slug: $slug, description: $description, logoImageId: $logoImageId, coverImageId: $coverImageId, ownerUserId: $ownerUserId, status: $status, address: $address, deliveryFee: $deliveryFee, deliveryRadiusKm: $deliveryRadiusKm, openingHours: $openingHours, commissionBps: $commissionBps, payout: $payout, distanceKm: $distanceKm, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $VendorCopyWith<$Res>  {
  factory $VendorCopyWith(Vendor value, $Res Function(Vendor) _then) = _$VendorCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String name, String slug, String? description, String? logoImageId, String? coverImageId, String ownerUserId, VendorStatus status, VendorAddress? address, DeliveryFeeConfig? deliveryFee, double? deliveryRadiusKm, List<OpeningHours> openingHours, int commissionBps, PayoutAccount? payout, double? distanceKm,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


$VendorAddressCopyWith<$Res>? get address;$DeliveryFeeConfigCopyWith<$Res>? get deliveryFee;$PayoutAccountCopyWith<$Res>? get payout;

}
/// @nodoc
class _$VendorCopyWithImpl<$Res>
    implements $VendorCopyWith<$Res> {
  _$VendorCopyWithImpl(this._self, this._then);

  final Vendor _self;
  final $Res Function(Vendor) _then;

/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? logoImageId = freezed,Object? coverImageId = freezed,Object? ownerUserId = null,Object? status = null,Object? address = freezed,Object? deliveryFee = freezed,Object? deliveryRadiusKm = freezed,Object? openingHours = null,Object? commissionBps = null,Object? payout = freezed,Object? distanceKm = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoImageId: freezed == logoImageId ? _self.logoImageId : logoImageId // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VendorStatus,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as VendorAddress?,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as DeliveryFeeConfig?,deliveryRadiusKm: freezed == deliveryRadiusKm ? _self.deliveryRadiusKm : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
as double?,openingHours: null == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<OpeningHours>,commissionBps: null == commissionBps ? _self.commissionBps : commissionBps // ignore: cast_nullable_to_non_nullable
as int,payout: freezed == payout ? _self.payout : payout // ignore: cast_nullable_to_non_nullable
as PayoutAccount?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Vendor
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
}/// Create a copy of Vendor
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
}/// Create a copy of Vendor
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


/// Adds pattern-matching-related methods to [Vendor].
extension VendorPatterns on Vendor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vendor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vendor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vendor value)  $default,){
final _that = this;
switch (_that) {
case _Vendor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vendor value)?  $default,){
final _that = this;
switch (_that) {
case _Vendor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String name,  String slug,  String? description,  String? logoImageId,  String? coverImageId,  String ownerUserId,  VendorStatus status,  VendorAddress? address,  DeliveryFeeConfig? deliveryFee,  double? deliveryRadiusKm,  List<OpeningHours> openingHours,  int commissionBps,  PayoutAccount? payout,  double? distanceKm, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vendor() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.logoImageId,_that.coverImageId,_that.ownerUserId,_that.status,_that.address,_that.deliveryFee,_that.deliveryRadiusKm,_that.openingHours,_that.commissionBps,_that.payout,_that.distanceKm,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String name,  String slug,  String? description,  String? logoImageId,  String? coverImageId,  String ownerUserId,  VendorStatus status,  VendorAddress? address,  DeliveryFeeConfig? deliveryFee,  double? deliveryRadiusKm,  List<OpeningHours> openingHours,  int commissionBps,  PayoutAccount? payout,  double? distanceKm, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _Vendor():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.logoImageId,_that.coverImageId,_that.ownerUserId,_that.status,_that.address,_that.deliveryFee,_that.deliveryRadiusKm,_that.openingHours,_that.commissionBps,_that.payout,_that.distanceKm,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String name,  String slug,  String? description,  String? logoImageId,  String? coverImageId,  String ownerUserId,  VendorStatus status,  VendorAddress? address,  DeliveryFeeConfig? deliveryFee,  double? deliveryRadiusKm,  List<OpeningHours> openingHours,  int commissionBps,  PayoutAccount? payout,  double? distanceKm, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Vendor() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.logoImageId,_that.coverImageId,_that.ownerUserId,_that.status,_that.address,_that.deliveryFee,_that.deliveryRadiusKm,_that.openingHours,_that.commissionBps,_that.payout,_that.distanceKm,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vendor extends Vendor {
  const _Vendor({@JsonKey(readValue: readId) required this.id, required this.name, required this.slug, this.description, this.logoImageId, this.coverImageId, required this.ownerUserId, this.status = VendorStatus.pending, this.address, this.deliveryFee, this.deliveryRadiusKm, final  List<OpeningHours> openingHours = const <OpeningHours>[], this.commissionBps = 1000, this.payout, this.distanceKm, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0}): _openingHours = openingHours,super._();
  factory _Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String name;
@override final  String slug;
@override final  String? description;
@override final  String? logoImageId;
@override final  String? coverImageId;
@override final  String ownerUserId;
@override@JsonKey() final  VendorStatus status;
@override final  VendorAddress? address;
@override final  DeliveryFeeConfig? deliveryFee;
@override final  double? deliveryRadiusKm;
 final  List<OpeningHours> _openingHours;
@override@JsonKey() List<OpeningHours> get openingHours {
  if (_openingHours is EqualUnmodifiableListView) return _openingHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openingHours);
}

@override@JsonKey() final  int commissionBps;
@override final  PayoutAccount? payout;
@override final  double? distanceKm;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorCopyWith<_Vendor> get copyWith => __$VendorCopyWithImpl<_Vendor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vendor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoImageId, logoImageId) || other.logoImageId == logoImageId)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.address, address) || other.address == address)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.deliveryRadiusKm, deliveryRadiusKm) || other.deliveryRadiusKm == deliveryRadiusKm)&&const DeepCollectionEquality().equals(other._openingHours, _openingHours)&&(identical(other.commissionBps, commissionBps) || other.commissionBps == commissionBps)&&(identical(other.payout, payout) || other.payout == payout)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,description,logoImageId,coverImageId,ownerUserId,status,address,deliveryFee,deliveryRadiusKm,const DeepCollectionEquality().hash(_openingHours),commissionBps,payout,distanceKm,createdAt,updatedAt,deletedAt,version]);

@override
String toString() {
  return 'Vendor(id: $id, name: $name, slug: $slug, description: $description, logoImageId: $logoImageId, coverImageId: $coverImageId, ownerUserId: $ownerUserId, status: $status, address: $address, deliveryFee: $deliveryFee, deliveryRadiusKm: $deliveryRadiusKm, openingHours: $openingHours, commissionBps: $commissionBps, payout: $payout, distanceKm: $distanceKm, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$VendorCopyWith<$Res> implements $VendorCopyWith<$Res> {
  factory _$VendorCopyWith(_Vendor value, $Res Function(_Vendor) _then) = __$VendorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String name, String slug, String? description, String? logoImageId, String? coverImageId, String ownerUserId, VendorStatus status, VendorAddress? address, DeliveryFeeConfig? deliveryFee, double? deliveryRadiusKm, List<OpeningHours> openingHours, int commissionBps, PayoutAccount? payout, double? distanceKm,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


@override $VendorAddressCopyWith<$Res>? get address;@override $DeliveryFeeConfigCopyWith<$Res>? get deliveryFee;@override $PayoutAccountCopyWith<$Res>? get payout;

}
/// @nodoc
class __$VendorCopyWithImpl<$Res>
    implements _$VendorCopyWith<$Res> {
  __$VendorCopyWithImpl(this._self, this._then);

  final _Vendor _self;
  final $Res Function(_Vendor) _then;

/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? logoImageId = freezed,Object? coverImageId = freezed,Object? ownerUserId = null,Object? status = null,Object? address = freezed,Object? deliveryFee = freezed,Object? deliveryRadiusKm = freezed,Object? openingHours = null,Object? commissionBps = null,Object? payout = freezed,Object? distanceKm = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_Vendor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoImageId: freezed == logoImageId ? _self.logoImageId : logoImageId // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VendorStatus,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as VendorAddress?,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as DeliveryFeeConfig?,deliveryRadiusKm: freezed == deliveryRadiusKm ? _self.deliveryRadiusKm : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
as double?,openingHours: null == openingHours ? _self._openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<OpeningHours>,commissionBps: null == commissionBps ? _self.commissionBps : commissionBps // ignore: cast_nullable_to_non_nullable
as int,payout: freezed == payout ? _self.payout : payout // ignore: cast_nullable_to_non_nullable
as PayoutAccount?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Vendor
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
}/// Create a copy of Vendor
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
}/// Create a copy of Vendor
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

// dart format on
