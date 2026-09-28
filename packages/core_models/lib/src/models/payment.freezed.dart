// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

@JsonKey(readValue: readId) String get id; String get orderId; String get provider; String? get providerRef; int get amountKobo; String get currency; PaymentStatus get status; String? get clientSecret;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerRef, providerRef) || other.providerRef == providerRef)&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,provider,providerRef,amountKobo,currency,status,clientSecret,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, provider: $provider, providerRef: $providerRef, amountKobo: $amountKobo, currency: $currency, status: $status, clientSecret: $clientSecret, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String orderId, String provider, String? providerRef, int amountKobo, String currency, PaymentStatus status, String? clientSecret,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? provider = null,Object? providerRef = freezed,Object? amountKobo = null,Object? currency = null,Object? status = null,Object? clientSecret = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,providerRef: freezed == providerRef ? _self.providerRef : providerRef // ignore: cast_nullable_to_non_nullable
as String?,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,clientSecret: freezed == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String orderId,  String provider,  String? providerRef,  int amountKobo,  String currency,  PaymentStatus status,  String? clientSecret, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.provider,_that.providerRef,_that.amountKobo,_that.currency,_that.status,_that.clientSecret,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String orderId,  String provider,  String? providerRef,  int amountKobo,  String currency,  PaymentStatus status,  String? clientSecret, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.orderId,_that.provider,_that.providerRef,_that.amountKobo,_that.currency,_that.status,_that.clientSecret,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String orderId,  String provider,  String? providerRef,  int amountKobo,  String currency,  PaymentStatus status,  String? clientSecret, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.provider,_that.providerRef,_that.amountKobo,_that.currency,_that.status,_that.clientSecret,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({@JsonKey(readValue: readId) required this.id, required this.orderId, this.provider = 'stripe', this.providerRef, required this.amountKobo, this.currency = 'NGN', this.status = PaymentStatus.pending, this.clientSecret, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0});
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String orderId;
@override@JsonKey() final  String provider;
@override final  String? providerRef;
@override final  int amountKobo;
@override@JsonKey() final  String currency;
@override@JsonKey() final  PaymentStatus status;
@override final  String? clientSecret;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerRef, providerRef) || other.providerRef == providerRef)&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,provider,providerRef,amountKobo,currency,status,clientSecret,createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, provider: $provider, providerRef: $providerRef, amountKobo: $amountKobo, currency: $currency, status: $status, clientSecret: $clientSecret, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String orderId, String provider, String? providerRef, int amountKobo, String currency, PaymentStatus status, String? clientSecret,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? provider = null,Object? providerRef = freezed,Object? amountKobo = null,Object? currency = null,Object? status = null,Object? clientSecret = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,providerRef: freezed == providerRef ? _self.providerRef : providerRef // ignore: cast_nullable_to_non_nullable
as String?,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,clientSecret: freezed == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
