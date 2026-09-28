// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorLedgerEntry {

@JsonKey(readValue: readId) String get id; String get vendorId; String? get subOrderId; String? get payoutId; LedgerEntryType get type; int get amountKobo; int get balanceAfterKobo; String? get note;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of VendorLedgerEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorLedgerEntryCopyWith<VendorLedgerEntry> get copyWith => _$VendorLedgerEntryCopyWithImpl<VendorLedgerEntry>(this as VendorLedgerEntry, _$identity);

  /// Serializes this VendorLedgerEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorLedgerEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.subOrderId, subOrderId) || other.subOrderId == subOrderId)&&(identical(other.payoutId, payoutId) || other.payoutId == payoutId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.balanceAfterKobo, balanceAfterKobo) || other.balanceAfterKobo == balanceAfterKobo)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,subOrderId,payoutId,type,amountKobo,balanceAfterKobo,note,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'VendorLedgerEntry(id: $id, vendorId: $vendorId, subOrderId: $subOrderId, payoutId: $payoutId, type: $type, amountKobo: $amountKobo, balanceAfterKobo: $balanceAfterKobo, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $VendorLedgerEntryCopyWith<$Res>  {
  factory $VendorLedgerEntryCopyWith(VendorLedgerEntry value, $Res Function(VendorLedgerEntry) _then) = _$VendorLedgerEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String vendorId, String? subOrderId, String? payoutId, LedgerEntryType type, int amountKobo, int balanceAfterKobo, String? note,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class _$VendorLedgerEntryCopyWithImpl<$Res>
    implements $VendorLedgerEntryCopyWith<$Res> {
  _$VendorLedgerEntryCopyWithImpl(this._self, this._then);

  final VendorLedgerEntry _self;
  final $Res Function(VendorLedgerEntry) _then;

/// Create a copy of VendorLedgerEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorId = null,Object? subOrderId = freezed,Object? payoutId = freezed,Object? type = null,Object? amountKobo = null,Object? balanceAfterKobo = null,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,subOrderId: freezed == subOrderId ? _self.subOrderId : subOrderId // ignore: cast_nullable_to_non_nullable
as String?,payoutId: freezed == payoutId ? _self.payoutId : payoutId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LedgerEntryType,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,balanceAfterKobo: null == balanceAfterKobo ? _self.balanceAfterKobo : balanceAfterKobo // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorLedgerEntry].
extension VendorLedgerEntryPatterns on VendorLedgerEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorLedgerEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorLedgerEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorLedgerEntry value)  $default,){
final _that = this;
switch (_that) {
case _VendorLedgerEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorLedgerEntry value)?  $default,){
final _that = this;
switch (_that) {
case _VendorLedgerEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String vendorId,  String? subOrderId,  String? payoutId,  LedgerEntryType type,  int amountKobo,  int balanceAfterKobo,  String? note, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorLedgerEntry() when $default != null:
return $default(_that.id,_that.vendorId,_that.subOrderId,_that.payoutId,_that.type,_that.amountKobo,_that.balanceAfterKobo,_that.note,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String vendorId,  String? subOrderId,  String? payoutId,  LedgerEntryType type,  int amountKobo,  int balanceAfterKobo,  String? note, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _VendorLedgerEntry():
return $default(_that.id,_that.vendorId,_that.subOrderId,_that.payoutId,_that.type,_that.amountKobo,_that.balanceAfterKobo,_that.note,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String vendorId,  String? subOrderId,  String? payoutId,  LedgerEntryType type,  int amountKobo,  int balanceAfterKobo,  String? note, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _VendorLedgerEntry() when $default != null:
return $default(_that.id,_that.vendorId,_that.subOrderId,_that.payoutId,_that.type,_that.amountKobo,_that.balanceAfterKobo,_that.note,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorLedgerEntry implements VendorLedgerEntry {
  const _VendorLedgerEntry({@JsonKey(readValue: readId) required this.id, required this.vendorId, this.subOrderId, this.payoutId, required this.type, required this.amountKobo, this.balanceAfterKobo = 0, this.note, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0});
  factory _VendorLedgerEntry.fromJson(Map<String, dynamic> json) => _$VendorLedgerEntryFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String vendorId;
@override final  String? subOrderId;
@override final  String? payoutId;
@override final  LedgerEntryType type;
@override final  int amountKobo;
@override@JsonKey() final  int balanceAfterKobo;
@override final  String? note;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of VendorLedgerEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorLedgerEntryCopyWith<_VendorLedgerEntry> get copyWith => __$VendorLedgerEntryCopyWithImpl<_VendorLedgerEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorLedgerEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorLedgerEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.subOrderId, subOrderId) || other.subOrderId == subOrderId)&&(identical(other.payoutId, payoutId) || other.payoutId == payoutId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.balanceAfterKobo, balanceAfterKobo) || other.balanceAfterKobo == balanceAfterKobo)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,subOrderId,payoutId,type,amountKobo,balanceAfterKobo,note,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'VendorLedgerEntry(id: $id, vendorId: $vendorId, subOrderId: $subOrderId, payoutId: $payoutId, type: $type, amountKobo: $amountKobo, balanceAfterKobo: $balanceAfterKobo, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$VendorLedgerEntryCopyWith<$Res> implements $VendorLedgerEntryCopyWith<$Res> {
  factory _$VendorLedgerEntryCopyWith(_VendorLedgerEntry value, $Res Function(_VendorLedgerEntry) _then) = __$VendorLedgerEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String vendorId, String? subOrderId, String? payoutId, LedgerEntryType type, int amountKobo, int balanceAfterKobo, String? note,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class __$VendorLedgerEntryCopyWithImpl<$Res>
    implements _$VendorLedgerEntryCopyWith<$Res> {
  __$VendorLedgerEntryCopyWithImpl(this._self, this._then);

  final _VendorLedgerEntry _self;
  final $Res Function(_VendorLedgerEntry) _then;

/// Create a copy of VendorLedgerEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorId = null,Object? subOrderId = freezed,Object? payoutId = freezed,Object? type = null,Object? amountKobo = null,Object? balanceAfterKobo = null,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_VendorLedgerEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,subOrderId: freezed == subOrderId ? _self.subOrderId : subOrderId // ignore: cast_nullable_to_non_nullable
as String?,payoutId: freezed == payoutId ? _self.payoutId : payoutId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LedgerEntryType,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,balanceAfterKobo: null == balanceAfterKobo ? _self.balanceAfterKobo : balanceAfterKobo // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Payout {

@JsonKey(readValue: readId) String get id; String get vendorId; int get amountKobo; PayoutStatus get status; String get method; String? get reference;@NullableDateTimeConverter() DateTime? get paidAt; String? get vendorName;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of Payout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutCopyWith<Payout> get copyWith => _$PayoutCopyWithImpl<Payout>(this as Payout, _$identity);

  /// Serializes this Payout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payout&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.status, status) || other.status == status)&&(identical(other.method, method) || other.method == method)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,amountKobo,status,method,reference,paidAt,vendorName,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Payout(id: $id, vendorId: $vendorId, amountKobo: $amountKobo, status: $status, method: $method, reference: $reference, paidAt: $paidAt, vendorName: $vendorName, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $PayoutCopyWith<$Res>  {
  factory $PayoutCopyWith(Payout value, $Res Function(Payout) _then) = _$PayoutCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String vendorId, int amountKobo, PayoutStatus status, String method, String? reference,@NullableDateTimeConverter() DateTime? paidAt, String? vendorName,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class _$PayoutCopyWithImpl<$Res>
    implements $PayoutCopyWith<$Res> {
  _$PayoutCopyWithImpl(this._self, this._then);

  final Payout _self;
  final $Res Function(Payout) _then;

/// Create a copy of Payout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorId = null,Object? amountKobo = null,Object? status = null,Object? method = null,Object? reference = freezed,Object? paidAt = freezed,Object? vendorName = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PayoutStatus,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Payout].
extension PayoutPatterns on Payout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payout value)  $default,){
final _that = this;
switch (_that) {
case _Payout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payout value)?  $default,){
final _that = this;
switch (_that) {
case _Payout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String vendorId,  int amountKobo,  PayoutStatus status,  String method,  String? reference, @NullableDateTimeConverter()  DateTime? paidAt,  String? vendorName, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payout() when $default != null:
return $default(_that.id,_that.vendorId,_that.amountKobo,_that.status,_that.method,_that.reference,_that.paidAt,_that.vendorName,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String vendorId,  int amountKobo,  PayoutStatus status,  String method,  String? reference, @NullableDateTimeConverter()  DateTime? paidAt,  String? vendorName, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _Payout():
return $default(_that.id,_that.vendorId,_that.amountKobo,_that.status,_that.method,_that.reference,_that.paidAt,_that.vendorName,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String vendorId,  int amountKobo,  PayoutStatus status,  String method,  String? reference, @NullableDateTimeConverter()  DateTime? paidAt,  String? vendorName, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Payout() when $default != null:
return $default(_that.id,_that.vendorId,_that.amountKobo,_that.status,_that.method,_that.reference,_that.paidAt,_that.vendorName,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payout implements Payout {
  const _Payout({@JsonKey(readValue: readId) required this.id, required this.vendorId, required this.amountKobo, this.status = PayoutStatus.requested, this.method = 'manual', this.reference, @NullableDateTimeConverter() this.paidAt, this.vendorName, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0});
  factory _Payout.fromJson(Map<String, dynamic> json) => _$PayoutFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String vendorId;
@override final  int amountKobo;
@override@JsonKey() final  PayoutStatus status;
@override@JsonKey() final  String method;
@override final  String? reference;
@override@NullableDateTimeConverter() final  DateTime? paidAt;
@override final  String? vendorName;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of Payout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutCopyWith<_Payout> get copyWith => __$PayoutCopyWithImpl<_Payout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payout&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.status, status) || other.status == status)&&(identical(other.method, method) || other.method == method)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,amountKobo,status,method,reference,paidAt,vendorName,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Payout(id: $id, vendorId: $vendorId, amountKobo: $amountKobo, status: $status, method: $method, reference: $reference, paidAt: $paidAt, vendorName: $vendorName, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$PayoutCopyWith<$Res> implements $PayoutCopyWith<$Res> {
  factory _$PayoutCopyWith(_Payout value, $Res Function(_Payout) _then) = __$PayoutCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String vendorId, int amountKobo, PayoutStatus status, String method, String? reference,@NullableDateTimeConverter() DateTime? paidAt, String? vendorName,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class __$PayoutCopyWithImpl<$Res>
    implements _$PayoutCopyWith<$Res> {
  __$PayoutCopyWithImpl(this._self, this._then);

  final _Payout _self;
  final $Res Function(_Payout) _then;

/// Create a copy of Payout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorId = null,Object? amountKobo = null,Object? status = null,Object? method = null,Object? reference = freezed,Object? paidAt = freezed,Object? vendorName = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_Payout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PayoutStatus,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
