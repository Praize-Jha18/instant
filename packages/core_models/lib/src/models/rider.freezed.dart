// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RiderDocument {

 String get type; String get imageId;
/// Create a copy of RiderDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderDocumentCopyWith<RiderDocument> get copyWith => _$RiderDocumentCopyWithImpl<RiderDocument>(this as RiderDocument, _$identity);

  /// Serializes this RiderDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderDocument&&(identical(other.type, type) || other.type == type)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,imageId);

@override
String toString() {
  return 'RiderDocument(type: $type, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class $RiderDocumentCopyWith<$Res>  {
  factory $RiderDocumentCopyWith(RiderDocument value, $Res Function(RiderDocument) _then) = _$RiderDocumentCopyWithImpl;
@useResult
$Res call({
 String type, String imageId
});




}
/// @nodoc
class _$RiderDocumentCopyWithImpl<$Res>
    implements $RiderDocumentCopyWith<$Res> {
  _$RiderDocumentCopyWithImpl(this._self, this._then);

  final RiderDocument _self;
  final $Res Function(RiderDocument) _then;

/// Create a copy of RiderDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? imageId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageId: null == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderDocument].
extension RiderDocumentPatterns on RiderDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderDocument value)  $default,){
final _that = this;
switch (_that) {
case _RiderDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderDocument value)?  $default,){
final _that = this;
switch (_that) {
case _RiderDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String imageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderDocument() when $default != null:
return $default(_that.type,_that.imageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String imageId)  $default,) {final _that = this;
switch (_that) {
case _RiderDocument():
return $default(_that.type,_that.imageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String imageId)?  $default,) {final _that = this;
switch (_that) {
case _RiderDocument() when $default != null:
return $default(_that.type,_that.imageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderDocument implements RiderDocument {
  const _RiderDocument({required this.type, required this.imageId});
  factory _RiderDocument.fromJson(Map<String, dynamic> json) => _$RiderDocumentFromJson(json);

@override final  String type;
@override final  String imageId;

/// Create a copy of RiderDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderDocumentCopyWith<_RiderDocument> get copyWith => __$RiderDocumentCopyWithImpl<_RiderDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderDocument&&(identical(other.type, type) || other.type == type)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,imageId);

@override
String toString() {
  return 'RiderDocument(type: $type, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class _$RiderDocumentCopyWith<$Res> implements $RiderDocumentCopyWith<$Res> {
  factory _$RiderDocumentCopyWith(_RiderDocument value, $Res Function(_RiderDocument) _then) = __$RiderDocumentCopyWithImpl;
@override @useResult
$Res call({
 String type, String imageId
});




}
/// @nodoc
class __$RiderDocumentCopyWithImpl<$Res>
    implements _$RiderDocumentCopyWith<$Res> {
  __$RiderDocumentCopyWithImpl(this._self, this._then);

  final _RiderDocument _self;
  final $Res Function(_RiderDocument) _then;

/// Create a copy of RiderDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? imageId = null,}) {
  return _then(_RiderDocument(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageId: null == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RiderUserSummary {

@JsonKey(readValue: readId) String get id; String get fullName; String? get phone; String? get email;
/// Create a copy of RiderUserSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderUserSummaryCopyWith<RiderUserSummary> get copyWith => _$RiderUserSummaryCopyWithImpl<RiderUserSummary>(this as RiderUserSummary, _$identity);

  /// Serializes this RiderUserSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,phone,email);

@override
String toString() {
  return 'RiderUserSummary(id: $id, fullName: $fullName, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class $RiderUserSummaryCopyWith<$Res>  {
  factory $RiderUserSummaryCopyWith(RiderUserSummary value, $Res Function(RiderUserSummary) _then) = _$RiderUserSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String fullName, String? phone, String? email
});




}
/// @nodoc
class _$RiderUserSummaryCopyWithImpl<$Res>
    implements $RiderUserSummaryCopyWith<$Res> {
  _$RiderUserSummaryCopyWithImpl(this._self, this._then);

  final RiderUserSummary _self;
  final $Res Function(RiderUserSummary) _then;

/// Create a copy of RiderUserSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? email = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderUserSummary].
extension RiderUserSummaryPatterns on RiderUserSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderUserSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderUserSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderUserSummary value)  $default,){
final _that = this;
switch (_that) {
case _RiderUserSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderUserSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RiderUserSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String fullName,  String? phone,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderUserSummary() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String fullName,  String? phone,  String? email)  $default,) {final _that = this;
switch (_that) {
case _RiderUserSummary():
return $default(_that.id,_that.fullName,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String fullName,  String? phone,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _RiderUserSummary() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderUserSummary implements RiderUserSummary {
  const _RiderUserSummary({@JsonKey(readValue: readId) required this.id, required this.fullName, this.phone, this.email});
  factory _RiderUserSummary.fromJson(Map<String, dynamic> json) => _$RiderUserSummaryFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String fullName;
@override final  String? phone;
@override final  String? email;

/// Create a copy of RiderUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderUserSummaryCopyWith<_RiderUserSummary> get copyWith => __$RiderUserSummaryCopyWithImpl<_RiderUserSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderUserSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,phone,email);

@override
String toString() {
  return 'RiderUserSummary(id: $id, fullName: $fullName, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$RiderUserSummaryCopyWith<$Res> implements $RiderUserSummaryCopyWith<$Res> {
  factory _$RiderUserSummaryCopyWith(_RiderUserSummary value, $Res Function(_RiderUserSummary) _then) = __$RiderUserSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String fullName, String? phone, String? email
});




}
/// @nodoc
class __$RiderUserSummaryCopyWithImpl<$Res>
    implements _$RiderUserSummaryCopyWith<$Res> {
  __$RiderUserSummaryCopyWithImpl(this._self, this._then);

  final _RiderUserSummary _self;
  final $Res Function(_RiderUserSummary) _then;

/// Create a copy of RiderUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? email = freezed,}) {
  return _then(_RiderUserSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RiderLastLocation {

 double get lat; double get lng; double? get heading; double? get speed;@DateTimeConverter() DateTime get at;
/// Create a copy of RiderLastLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderLastLocationCopyWith<RiderLastLocation> get copyWith => _$RiderLastLocationCopyWithImpl<RiderLastLocation>(this as RiderLastLocation, _$identity);

  /// Serializes this RiderLastLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderLastLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,heading,speed,at);

@override
String toString() {
  return 'RiderLastLocation(lat: $lat, lng: $lng, heading: $heading, speed: $speed, at: $at)';
}


}

/// @nodoc
abstract mixin class $RiderLastLocationCopyWith<$Res>  {
  factory $RiderLastLocationCopyWith(RiderLastLocation value, $Res Function(RiderLastLocation) _then) = _$RiderLastLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, double? heading, double? speed,@DateTimeConverter() DateTime at
});




}
/// @nodoc
class _$RiderLastLocationCopyWithImpl<$Res>
    implements $RiderLastLocationCopyWith<$Res> {
  _$RiderLastLocationCopyWithImpl(this._self, this._then);

  final RiderLastLocation _self;
  final $Res Function(RiderLastLocation) _then;

/// Create a copy of RiderLastLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? at = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderLastLocation].
extension RiderLastLocationPatterns on RiderLastLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderLastLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderLastLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderLastLocation value)  $default,){
final _that = this;
switch (_that) {
case _RiderLastLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderLastLocation value)?  $default,){
final _that = this;
switch (_that) {
case _RiderLastLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderLastLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.heading,_that.speed,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _RiderLastLocation():
return $default(_that.lat,_that.lng,_that.heading,_that.speed,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _RiderLastLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.heading,_that.speed,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderLastLocation implements RiderLastLocation {
  const _RiderLastLocation({required this.lat, required this.lng, this.heading, this.speed, @DateTimeConverter() required this.at});
  factory _RiderLastLocation.fromJson(Map<String, dynamic> json) => _$RiderLastLocationFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  double? heading;
@override final  double? speed;
@override@DateTimeConverter() final  DateTime at;

/// Create a copy of RiderLastLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderLastLocationCopyWith<_RiderLastLocation> get copyWith => __$RiderLastLocationCopyWithImpl<_RiderLastLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderLastLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderLastLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,heading,speed,at);

@override
String toString() {
  return 'RiderLastLocation(lat: $lat, lng: $lng, heading: $heading, speed: $speed, at: $at)';
}


}

/// @nodoc
abstract mixin class _$RiderLastLocationCopyWith<$Res> implements $RiderLastLocationCopyWith<$Res> {
  factory _$RiderLastLocationCopyWith(_RiderLastLocation value, $Res Function(_RiderLastLocation) _then) = __$RiderLastLocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, double? heading, double? speed,@DateTimeConverter() DateTime at
});




}
/// @nodoc
class __$RiderLastLocationCopyWithImpl<$Res>
    implements _$RiderLastLocationCopyWith<$Res> {
  __$RiderLastLocationCopyWithImpl(this._self, this._then);

  final _RiderLastLocation _self;
  final $Res Function(_RiderLastLocation) _then;

/// Create a copy of RiderLastLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? at = null,}) {
  return _then(_RiderLastLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$RiderProfile {

@JsonKey(readValue: readId) String get id; String get userId; String get vendorId; RiderStatus get status; String? get vehicleType; String? get plateNumber; List<RiderDocument> get documents; bool get isOnline;@NullableDateTimeConverter() DateTime? get lastSeenAt; String? get currentDeliveryId; String? get fullName; String? get phone; String? get avatarImageId;/// Present on `GET /vendor/riders` responses.
 RiderUserSummary? get user;/// Present on `GET /vendor/riders` responses.
 RiderLastLocation? get lastLocation;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderProfileCopyWith<RiderProfile> get copyWith => _$RiderProfileCopyWithImpl<RiderProfile>(this as RiderProfile, _$identity);

  /// Serializes this RiderProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.status, status) || other.status == status)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&const DeepCollectionEquality().equals(other.documents, documents)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.currentDeliveryId, currentDeliveryId) || other.currentDeliveryId == currentDeliveryId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarImageId, avatarImageId) || other.avatarImageId == avatarImageId)&&(identical(other.user, user) || other.user == user)&&(identical(other.lastLocation, lastLocation) || other.lastLocation == lastLocation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,vendorId,status,vehicleType,plateNumber,const DeepCollectionEquality().hash(documents),isOnline,lastSeenAt,currentDeliveryId,fullName,phone,avatarImageId,user,lastLocation,createdAt,updatedAt,deletedAt,version]);

@override
String toString() {
  return 'RiderProfile(id: $id, userId: $userId, vendorId: $vendorId, status: $status, vehicleType: $vehicleType, plateNumber: $plateNumber, documents: $documents, isOnline: $isOnline, lastSeenAt: $lastSeenAt, currentDeliveryId: $currentDeliveryId, fullName: $fullName, phone: $phone, avatarImageId: $avatarImageId, user: $user, lastLocation: $lastLocation, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $RiderProfileCopyWith<$Res>  {
  factory $RiderProfileCopyWith(RiderProfile value, $Res Function(RiderProfile) _then) = _$RiderProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String userId, String vendorId, RiderStatus status, String? vehicleType, String? plateNumber, List<RiderDocument> documents, bool isOnline,@NullableDateTimeConverter() DateTime? lastSeenAt, String? currentDeliveryId, String? fullName, String? phone, String? avatarImageId, RiderUserSummary? user, RiderLastLocation? lastLocation,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


$RiderUserSummaryCopyWith<$Res>? get user;$RiderLastLocationCopyWith<$Res>? get lastLocation;

}
/// @nodoc
class _$RiderProfileCopyWithImpl<$Res>
    implements $RiderProfileCopyWith<$Res> {
  _$RiderProfileCopyWithImpl(this._self, this._then);

  final RiderProfile _self;
  final $Res Function(RiderProfile) _then;

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? vendorId = null,Object? status = null,Object? vehicleType = freezed,Object? plateNumber = freezed,Object? documents = null,Object? isOnline = null,Object? lastSeenAt = freezed,Object? currentDeliveryId = freezed,Object? fullName = freezed,Object? phone = freezed,Object? avatarImageId = freezed,Object? user = freezed,Object? lastLocation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RiderStatus,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as List<RiderDocument>,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentDeliveryId: freezed == currentDeliveryId ? _self.currentDeliveryId : currentDeliveryId // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarImageId: freezed == avatarImageId ? _self.avatarImageId : avatarImageId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as RiderUserSummary?,lastLocation: freezed == lastLocation ? _self.lastLocation : lastLocation // ignore: cast_nullable_to_non_nullable
as RiderLastLocation?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderUserSummaryCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $RiderUserSummaryCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderLastLocationCopyWith<$Res>? get lastLocation {
    if (_self.lastLocation == null) {
    return null;
  }

  return $RiderLastLocationCopyWith<$Res>(_self.lastLocation!, (value) {
    return _then(_self.copyWith(lastLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [RiderProfile].
extension RiderProfilePatterns on RiderProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderProfile value)  $default,){
final _that = this;
switch (_that) {
case _RiderProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderProfile value)?  $default,){
final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String userId,  String vendorId,  RiderStatus status,  String? vehicleType,  String? plateNumber,  List<RiderDocument> documents,  bool isOnline, @NullableDateTimeConverter()  DateTime? lastSeenAt,  String? currentDeliveryId,  String? fullName,  String? phone,  String? avatarImageId,  RiderUserSummary? user,  RiderLastLocation? lastLocation, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
return $default(_that.id,_that.userId,_that.vendorId,_that.status,_that.vehicleType,_that.plateNumber,_that.documents,_that.isOnline,_that.lastSeenAt,_that.currentDeliveryId,_that.fullName,_that.phone,_that.avatarImageId,_that.user,_that.lastLocation,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String userId,  String vendorId,  RiderStatus status,  String? vehicleType,  String? plateNumber,  List<RiderDocument> documents,  bool isOnline, @NullableDateTimeConverter()  DateTime? lastSeenAt,  String? currentDeliveryId,  String? fullName,  String? phone,  String? avatarImageId,  RiderUserSummary? user,  RiderLastLocation? lastLocation, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _RiderProfile():
return $default(_that.id,_that.userId,_that.vendorId,_that.status,_that.vehicleType,_that.plateNumber,_that.documents,_that.isOnline,_that.lastSeenAt,_that.currentDeliveryId,_that.fullName,_that.phone,_that.avatarImageId,_that.user,_that.lastLocation,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String userId,  String vendorId,  RiderStatus status,  String? vehicleType,  String? plateNumber,  List<RiderDocument> documents,  bool isOnline, @NullableDateTimeConverter()  DateTime? lastSeenAt,  String? currentDeliveryId,  String? fullName,  String? phone,  String? avatarImageId,  RiderUserSummary? user,  RiderLastLocation? lastLocation, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
return $default(_that.id,_that.userId,_that.vendorId,_that.status,_that.vehicleType,_that.plateNumber,_that.documents,_that.isOnline,_that.lastSeenAt,_that.currentDeliveryId,_that.fullName,_that.phone,_that.avatarImageId,_that.user,_that.lastLocation,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderProfile extends RiderProfile {
  const _RiderProfile({@JsonKey(readValue: readId) required this.id, required this.userId, required this.vendorId, this.status = RiderStatus.pending, this.vehicleType, this.plateNumber, final  List<RiderDocument> documents = const <RiderDocument>[], this.isOnline = false, @NullableDateTimeConverter() this.lastSeenAt, this.currentDeliveryId, this.fullName, this.phone, this.avatarImageId, this.user, this.lastLocation, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0}): _documents = documents,super._();
  factory _RiderProfile.fromJson(Map<String, dynamic> json) => _$RiderProfileFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String userId;
@override final  String vendorId;
@override@JsonKey() final  RiderStatus status;
@override final  String? vehicleType;
@override final  String? plateNumber;
 final  List<RiderDocument> _documents;
@override@JsonKey() List<RiderDocument> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@override@JsonKey() final  bool isOnline;
@override@NullableDateTimeConverter() final  DateTime? lastSeenAt;
@override final  String? currentDeliveryId;
@override final  String? fullName;
@override final  String? phone;
@override final  String? avatarImageId;
/// Present on `GET /vendor/riders` responses.
@override final  RiderUserSummary? user;
/// Present on `GET /vendor/riders` responses.
@override final  RiderLastLocation? lastLocation;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderProfileCopyWith<_RiderProfile> get copyWith => __$RiderProfileCopyWithImpl<_RiderProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.status, status) || other.status == status)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.currentDeliveryId, currentDeliveryId) || other.currentDeliveryId == currentDeliveryId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarImageId, avatarImageId) || other.avatarImageId == avatarImageId)&&(identical(other.user, user) || other.user == user)&&(identical(other.lastLocation, lastLocation) || other.lastLocation == lastLocation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,vendorId,status,vehicleType,plateNumber,const DeepCollectionEquality().hash(_documents),isOnline,lastSeenAt,currentDeliveryId,fullName,phone,avatarImageId,user,lastLocation,createdAt,updatedAt,deletedAt,version]);

@override
String toString() {
  return 'RiderProfile(id: $id, userId: $userId, vendorId: $vendorId, status: $status, vehicleType: $vehicleType, plateNumber: $plateNumber, documents: $documents, isOnline: $isOnline, lastSeenAt: $lastSeenAt, currentDeliveryId: $currentDeliveryId, fullName: $fullName, phone: $phone, avatarImageId: $avatarImageId, user: $user, lastLocation: $lastLocation, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$RiderProfileCopyWith<$Res> implements $RiderProfileCopyWith<$Res> {
  factory _$RiderProfileCopyWith(_RiderProfile value, $Res Function(_RiderProfile) _then) = __$RiderProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String userId, String vendorId, RiderStatus status, String? vehicleType, String? plateNumber, List<RiderDocument> documents, bool isOnline,@NullableDateTimeConverter() DateTime? lastSeenAt, String? currentDeliveryId, String? fullName, String? phone, String? avatarImageId, RiderUserSummary? user, RiderLastLocation? lastLocation,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


@override $RiderUserSummaryCopyWith<$Res>? get user;@override $RiderLastLocationCopyWith<$Res>? get lastLocation;

}
/// @nodoc
class __$RiderProfileCopyWithImpl<$Res>
    implements _$RiderProfileCopyWith<$Res> {
  __$RiderProfileCopyWithImpl(this._self, this._then);

  final _RiderProfile _self;
  final $Res Function(_RiderProfile) _then;

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? vendorId = null,Object? status = null,Object? vehicleType = freezed,Object? plateNumber = freezed,Object? documents = null,Object? isOnline = null,Object? lastSeenAt = freezed,Object? currentDeliveryId = freezed,Object? fullName = freezed,Object? phone = freezed,Object? avatarImageId = freezed,Object? user = freezed,Object? lastLocation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_RiderProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RiderStatus,vehicleType: freezed == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String?,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<RiderDocument>,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentDeliveryId: freezed == currentDeliveryId ? _self.currentDeliveryId : currentDeliveryId // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarImageId: freezed == avatarImageId ? _self.avatarImageId : avatarImageId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as RiderUserSummary?,lastLocation: freezed == lastLocation ? _self.lastLocation : lastLocation // ignore: cast_nullable_to_non_nullable
as RiderLastLocation?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderUserSummaryCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $RiderUserSummaryCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderLastLocationCopyWith<$Res>? get lastLocation {
    if (_self.lastLocation == null) {
    return null;
  }

  return $RiderLastLocationCopyWith<$Res>(_self.lastLocation!, (value) {
    return _then(_self.copyWith(lastLocation: value));
  });
}
}


/// @nodoc
mixin _$RiderLocation {

@JsonKey(readValue: readId) String? get id; String get riderId; String? get vendorId; String? get deliveryId; double get lat; double get lng; double? get heading; double? get speed;@DateTimeConverter() DateTime get at;
/// Create a copy of RiderLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderLocationCopyWith<RiderLocation> get copyWith => _$RiderLocationCopyWithImpl<RiderLocation>(this as RiderLocation, _$identity);

  /// Serializes this RiderLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riderId,vendorId,deliveryId,lat,lng,heading,speed,at);

@override
String toString() {
  return 'RiderLocation(id: $id, riderId: $riderId, vendorId: $vendorId, deliveryId: $deliveryId, lat: $lat, lng: $lng, heading: $heading, speed: $speed, at: $at)';
}


}

/// @nodoc
abstract mixin class $RiderLocationCopyWith<$Res>  {
  factory $RiderLocationCopyWith(RiderLocation value, $Res Function(RiderLocation) _then) = _$RiderLocationCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String? id, String riderId, String? vendorId, String? deliveryId, double lat, double lng, double? heading, double? speed,@DateTimeConverter() DateTime at
});




}
/// @nodoc
class _$RiderLocationCopyWithImpl<$Res>
    implements $RiderLocationCopyWith<$Res> {
  _$RiderLocationCopyWithImpl(this._self, this._then);

  final RiderLocation _self;
  final $Res Function(RiderLocation) _then;

/// Create a copy of RiderLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? riderId = null,Object? vendorId = freezed,Object? deliveryId = freezed,Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? at = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderLocation].
extension RiderLocationPatterns on RiderLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderLocation value)  $default,){
final _that = this;
switch (_that) {
case _RiderLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderLocation value)?  $default,){
final _that = this;
switch (_that) {
case _RiderLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String? id,  String riderId,  String? vendorId,  String? deliveryId,  double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderLocation() when $default != null:
return $default(_that.id,_that.riderId,_that.vendorId,_that.deliveryId,_that.lat,_that.lng,_that.heading,_that.speed,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String? id,  String riderId,  String? vendorId,  String? deliveryId,  double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _RiderLocation():
return $default(_that.id,_that.riderId,_that.vendorId,_that.deliveryId,_that.lat,_that.lng,_that.heading,_that.speed,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String? id,  String riderId,  String? vendorId,  String? deliveryId,  double lat,  double lng,  double? heading,  double? speed, @DateTimeConverter()  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _RiderLocation() when $default != null:
return $default(_that.id,_that.riderId,_that.vendorId,_that.deliveryId,_that.lat,_that.lng,_that.heading,_that.speed,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderLocation implements RiderLocation {
  const _RiderLocation({@JsonKey(readValue: readId) this.id, required this.riderId, this.vendorId, this.deliveryId, required this.lat, required this.lng, this.heading, this.speed, @DateTimeConverter() required this.at});
  factory _RiderLocation.fromJson(Map<String, dynamic> json) => _$RiderLocationFromJson(json);

@override@JsonKey(readValue: readId) final  String? id;
@override final  String riderId;
@override final  String? vendorId;
@override final  String? deliveryId;
@override final  double lat;
@override final  double lng;
@override final  double? heading;
@override final  double? speed;
@override@DateTimeConverter() final  DateTime at;

/// Create a copy of RiderLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderLocationCopyWith<_RiderLocation> get copyWith => __$RiderLocationCopyWithImpl<_RiderLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riderId,vendorId,deliveryId,lat,lng,heading,speed,at);

@override
String toString() {
  return 'RiderLocation(id: $id, riderId: $riderId, vendorId: $vendorId, deliveryId: $deliveryId, lat: $lat, lng: $lng, heading: $heading, speed: $speed, at: $at)';
}


}

/// @nodoc
abstract mixin class _$RiderLocationCopyWith<$Res> implements $RiderLocationCopyWith<$Res> {
  factory _$RiderLocationCopyWith(_RiderLocation value, $Res Function(_RiderLocation) _then) = __$RiderLocationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String? id, String riderId, String? vendorId, String? deliveryId, double lat, double lng, double? heading, double? speed,@DateTimeConverter() DateTime at
});




}
/// @nodoc
class __$RiderLocationCopyWithImpl<$Res>
    implements _$RiderLocationCopyWith<$Res> {
  __$RiderLocationCopyWithImpl(this._self, this._then);

  final _RiderLocation _self;
  final $Res Function(_RiderLocation) _then;

/// Create a copy of RiderLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? riderId = null,Object? vendorId = freezed,Object? deliveryId = freezed,Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? at = null,}) {
  return _then(_RiderLocation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
