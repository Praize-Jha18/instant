// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryMovement {

@JsonKey(readValue: readId) String get id; String get vendorId; String get productId; String? get variantId; int get delta; InventoryReason get reason; String? get orderId; String? get byUserId; String? get note;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of InventoryMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryMovementCopyWith<InventoryMovement> get copyWith => _$InventoryMovementCopyWithImpl<InventoryMovement>(this as InventoryMovement, _$identity);

  /// Serializes this InventoryMovement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variantId, variantId) || other.variantId == variantId)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.byUserId, byUserId) || other.byUserId == byUserId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,productId,variantId,delta,reason,orderId,byUserId,note,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'InventoryMovement(id: $id, vendorId: $vendorId, productId: $productId, variantId: $variantId, delta: $delta, reason: $reason, orderId: $orderId, byUserId: $byUserId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $InventoryMovementCopyWith<$Res>  {
  factory $InventoryMovementCopyWith(InventoryMovement value, $Res Function(InventoryMovement) _then) = _$InventoryMovementCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String vendorId, String productId, String? variantId, int delta, InventoryReason reason, String? orderId, String? byUserId, String? note,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class _$InventoryMovementCopyWithImpl<$Res>
    implements $InventoryMovementCopyWith<$Res> {
  _$InventoryMovementCopyWithImpl(this._self, this._then);

  final InventoryMovement _self;
  final $Res Function(InventoryMovement) _then;

/// Create a copy of InventoryMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorId = null,Object? productId = null,Object? variantId = freezed,Object? delta = null,Object? reason = null,Object? orderId = freezed,Object? byUserId = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variantId: freezed == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String?,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as InventoryReason,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,byUserId: freezed == byUserId ? _self.byUserId : byUserId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryMovement].
extension InventoryMovementPatterns on InventoryMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryMovement value)  $default,){
final _that = this;
switch (_that) {
case _InventoryMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryMovement value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String vendorId,  String productId,  String? variantId,  int delta,  InventoryReason reason,  String? orderId,  String? byUserId,  String? note, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryMovement() when $default != null:
return $default(_that.id,_that.vendorId,_that.productId,_that.variantId,_that.delta,_that.reason,_that.orderId,_that.byUserId,_that.note,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String vendorId,  String productId,  String? variantId,  int delta,  InventoryReason reason,  String? orderId,  String? byUserId,  String? note, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _InventoryMovement():
return $default(_that.id,_that.vendorId,_that.productId,_that.variantId,_that.delta,_that.reason,_that.orderId,_that.byUserId,_that.note,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String vendorId,  String productId,  String? variantId,  int delta,  InventoryReason reason,  String? orderId,  String? byUserId,  String? note, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _InventoryMovement() when $default != null:
return $default(_that.id,_that.vendorId,_that.productId,_that.variantId,_that.delta,_that.reason,_that.orderId,_that.byUserId,_that.note,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryMovement implements InventoryMovement {
  const _InventoryMovement({@JsonKey(readValue: readId) required this.id, required this.vendorId, required this.productId, this.variantId, required this.delta, required this.reason, this.orderId, this.byUserId, this.note, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0});
  factory _InventoryMovement.fromJson(Map<String, dynamic> json) => _$InventoryMovementFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String vendorId;
@override final  String productId;
@override final  String? variantId;
@override final  int delta;
@override final  InventoryReason reason;
@override final  String? orderId;
@override final  String? byUserId;
@override final  String? note;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of InventoryMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryMovementCopyWith<_InventoryMovement> get copyWith => __$InventoryMovementCopyWithImpl<_InventoryMovement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryMovementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.variantId, variantId) || other.variantId == variantId)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.byUserId, byUserId) || other.byUserId == byUserId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,productId,variantId,delta,reason,orderId,byUserId,note,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'InventoryMovement(id: $id, vendorId: $vendorId, productId: $productId, variantId: $variantId, delta: $delta, reason: $reason, orderId: $orderId, byUserId: $byUserId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$InventoryMovementCopyWith<$Res> implements $InventoryMovementCopyWith<$Res> {
  factory _$InventoryMovementCopyWith(_InventoryMovement value, $Res Function(_InventoryMovement) _then) = __$InventoryMovementCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String vendorId, String productId, String? variantId, int delta, InventoryReason reason, String? orderId, String? byUserId, String? note,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class __$InventoryMovementCopyWithImpl<$Res>
    implements _$InventoryMovementCopyWith<$Res> {
  __$InventoryMovementCopyWithImpl(this._self, this._then);

  final _InventoryMovement _self;
  final $Res Function(_InventoryMovement) _then;

/// Create a copy of InventoryMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorId = null,Object? productId = null,Object? variantId = freezed,Object? delta = null,Object? reason = null,Object? orderId = freezed,Object? byUserId = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_InventoryMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variantId: freezed == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String?,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as InventoryReason,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,byUserId: freezed == byUserId ? _self.byUserId : byUserId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
