// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

@JsonKey(readValue: readId) String get id; String get customerId; String get orderNumber; List<String> get subOrderIds; AddressSnapshot? get addressSnapshot; int get subtotalKobo; int get deliveryTotalKobo; int get totalKobo; String get currency; PaymentStatus get paymentStatus; String? get paymentId;@NullableDateTimeConverter() DateTime? get placedAt;@NullableDateTimeConverter() DateTime? get expiresAt;/// Populated by some endpoints (`GET /orders/:id`); otherwise empty.
 List<SubOrder> get subOrders;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&const DeepCollectionEquality().equals(other.subOrderIds, subOrderIds)&&(identical(other.addressSnapshot, addressSnapshot) || other.addressSnapshot == addressSnapshot)&&(identical(other.subtotalKobo, subtotalKobo) || other.subtotalKobo == subtotalKobo)&&(identical(other.deliveryTotalKobo, deliveryTotalKobo) || other.deliveryTotalKobo == deliveryTotalKobo)&&(identical(other.totalKobo, totalKobo) || other.totalKobo == totalKobo)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.subOrders, subOrders)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,orderNumber,const DeepCollectionEquality().hash(subOrderIds),addressSnapshot,subtotalKobo,deliveryTotalKobo,totalKobo,currency,paymentStatus,paymentId,placedAt,expiresAt,const DeepCollectionEquality().hash(subOrders),createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Order(id: $id, customerId: $customerId, orderNumber: $orderNumber, subOrderIds: $subOrderIds, addressSnapshot: $addressSnapshot, subtotalKobo: $subtotalKobo, deliveryTotalKobo: $deliveryTotalKobo, totalKobo: $totalKobo, currency: $currency, paymentStatus: $paymentStatus, paymentId: $paymentId, placedAt: $placedAt, expiresAt: $expiresAt, subOrders: $subOrders, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String customerId, String orderNumber, List<String> subOrderIds, AddressSnapshot? addressSnapshot, int subtotalKobo, int deliveryTotalKobo, int totalKobo, String currency, PaymentStatus paymentStatus, String? paymentId,@NullableDateTimeConverter() DateTime? placedAt,@NullableDateTimeConverter() DateTime? expiresAt, List<SubOrder> subOrders,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


$AddressSnapshotCopyWith<$Res>? get addressSnapshot;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? orderNumber = null,Object? subOrderIds = null,Object? addressSnapshot = freezed,Object? subtotalKobo = null,Object? deliveryTotalKobo = null,Object? totalKobo = null,Object? currency = null,Object? paymentStatus = null,Object? paymentId = freezed,Object? placedAt = freezed,Object? expiresAt = freezed,Object? subOrders = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,subOrderIds: null == subOrderIds ? _self.subOrderIds : subOrderIds // ignore: cast_nullable_to_non_nullable
as List<String>,addressSnapshot: freezed == addressSnapshot ? _self.addressSnapshot : addressSnapshot // ignore: cast_nullable_to_non_nullable
as AddressSnapshot?,subtotalKobo: null == subtotalKobo ? _self.subtotalKobo : subtotalKobo // ignore: cast_nullable_to_non_nullable
as int,deliveryTotalKobo: null == deliveryTotalKobo ? _self.deliveryTotalKobo : deliveryTotalKobo // ignore: cast_nullable_to_non_nullable
as int,totalKobo: null == totalKobo ? _self.totalKobo : totalKobo // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,placedAt: freezed == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subOrders: null == subOrders ? _self.subOrders : subOrders // ignore: cast_nullable_to_non_nullable
as List<SubOrder>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Order
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


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String customerId,  String orderNumber,  List<String> subOrderIds,  AddressSnapshot? addressSnapshot,  int subtotalKobo,  int deliveryTotalKobo,  int totalKobo,  String currency,  PaymentStatus paymentStatus,  String? paymentId, @NullableDateTimeConverter()  DateTime? placedAt, @NullableDateTimeConverter()  DateTime? expiresAt,  List<SubOrder> subOrders, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.customerId,_that.orderNumber,_that.subOrderIds,_that.addressSnapshot,_that.subtotalKobo,_that.deliveryTotalKobo,_that.totalKobo,_that.currency,_that.paymentStatus,_that.paymentId,_that.placedAt,_that.expiresAt,_that.subOrders,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String customerId,  String orderNumber,  List<String> subOrderIds,  AddressSnapshot? addressSnapshot,  int subtotalKobo,  int deliveryTotalKobo,  int totalKobo,  String currency,  PaymentStatus paymentStatus,  String? paymentId, @NullableDateTimeConverter()  DateTime? placedAt, @NullableDateTimeConverter()  DateTime? expiresAt,  List<SubOrder> subOrders, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.customerId,_that.orderNumber,_that.subOrderIds,_that.addressSnapshot,_that.subtotalKobo,_that.deliveryTotalKobo,_that.totalKobo,_that.currency,_that.paymentStatus,_that.paymentId,_that.placedAt,_that.expiresAt,_that.subOrders,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String customerId,  String orderNumber,  List<String> subOrderIds,  AddressSnapshot? addressSnapshot,  int subtotalKobo,  int deliveryTotalKobo,  int totalKobo,  String currency,  PaymentStatus paymentStatus,  String? paymentId, @NullableDateTimeConverter()  DateTime? placedAt, @NullableDateTimeConverter()  DateTime? expiresAt,  List<SubOrder> subOrders, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.customerId,_that.orderNumber,_that.subOrderIds,_that.addressSnapshot,_that.subtotalKobo,_that.deliveryTotalKobo,_that.totalKobo,_that.currency,_that.paymentStatus,_that.paymentId,_that.placedAt,_that.expiresAt,_that.subOrders,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order extends Order {
  const _Order({@JsonKey(readValue: readId) required this.id, required this.customerId, required this.orderNumber, final  List<String> subOrderIds = const <String>[], this.addressSnapshot, this.subtotalKobo = 0, this.deliveryTotalKobo = 0, this.totalKobo = 0, this.currency = 'NGN', this.paymentStatus = PaymentStatus.pending, this.paymentId, @NullableDateTimeConverter() this.placedAt, @NullableDateTimeConverter() this.expiresAt, final  List<SubOrder> subOrders = const <SubOrder>[], @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0}): _subOrderIds = subOrderIds,_subOrders = subOrders,super._();
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String customerId;
@override final  String orderNumber;
 final  List<String> _subOrderIds;
@override@JsonKey() List<String> get subOrderIds {
  if (_subOrderIds is EqualUnmodifiableListView) return _subOrderIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subOrderIds);
}

@override final  AddressSnapshot? addressSnapshot;
@override@JsonKey() final  int subtotalKobo;
@override@JsonKey() final  int deliveryTotalKobo;
@override@JsonKey() final  int totalKobo;
@override@JsonKey() final  String currency;
@override@JsonKey() final  PaymentStatus paymentStatus;
@override final  String? paymentId;
@override@NullableDateTimeConverter() final  DateTime? placedAt;
@override@NullableDateTimeConverter() final  DateTime? expiresAt;
/// Populated by some endpoints (`GET /orders/:id`); otherwise empty.
 final  List<SubOrder> _subOrders;
/// Populated by some endpoints (`GET /orders/:id`); otherwise empty.
@override@JsonKey() List<SubOrder> get subOrders {
  if (_subOrders is EqualUnmodifiableListView) return _subOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subOrders);
}

@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&const DeepCollectionEquality().equals(other._subOrderIds, _subOrderIds)&&(identical(other.addressSnapshot, addressSnapshot) || other.addressSnapshot == addressSnapshot)&&(identical(other.subtotalKobo, subtotalKobo) || other.subtotalKobo == subtotalKobo)&&(identical(other.deliveryTotalKobo, deliveryTotalKobo) || other.deliveryTotalKobo == deliveryTotalKobo)&&(identical(other.totalKobo, totalKobo) || other.totalKobo == totalKobo)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other._subOrders, _subOrders)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,orderNumber,const DeepCollectionEquality().hash(_subOrderIds),addressSnapshot,subtotalKobo,deliveryTotalKobo,totalKobo,currency,paymentStatus,paymentId,placedAt,expiresAt,const DeepCollectionEquality().hash(_subOrders),createdAt,updatedAt,deletedAt,version);

@override
String toString() {
  return 'Order(id: $id, customerId: $customerId, orderNumber: $orderNumber, subOrderIds: $subOrderIds, addressSnapshot: $addressSnapshot, subtotalKobo: $subtotalKobo, deliveryTotalKobo: $deliveryTotalKobo, totalKobo: $totalKobo, currency: $currency, paymentStatus: $paymentStatus, paymentId: $paymentId, placedAt: $placedAt, expiresAt: $expiresAt, subOrders: $subOrders, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String customerId, String orderNumber, List<String> subOrderIds, AddressSnapshot? addressSnapshot, int subtotalKobo, int deliveryTotalKobo, int totalKobo, String currency, PaymentStatus paymentStatus, String? paymentId,@NullableDateTimeConverter() DateTime? placedAt,@NullableDateTimeConverter() DateTime? expiresAt, List<SubOrder> subOrders,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});


@override $AddressSnapshotCopyWith<$Res>? get addressSnapshot;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? orderNumber = null,Object? subOrderIds = null,Object? addressSnapshot = freezed,Object? subtotalKobo = null,Object? deliveryTotalKobo = null,Object? totalKobo = null,Object? currency = null,Object? paymentStatus = null,Object? paymentId = freezed,Object? placedAt = freezed,Object? expiresAt = freezed,Object? subOrders = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,subOrderIds: null == subOrderIds ? _self._subOrderIds : subOrderIds // ignore: cast_nullable_to_non_nullable
as List<String>,addressSnapshot: freezed == addressSnapshot ? _self.addressSnapshot : addressSnapshot // ignore: cast_nullable_to_non_nullable
as AddressSnapshot?,subtotalKobo: null == subtotalKobo ? _self.subtotalKobo : subtotalKobo // ignore: cast_nullable_to_non_nullable
as int,deliveryTotalKobo: null == deliveryTotalKobo ? _self.deliveryTotalKobo : deliveryTotalKobo // ignore: cast_nullable_to_non_nullable
as int,totalKobo: null == totalKobo ? _self.totalKobo : totalKobo // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,placedAt: freezed == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subOrders: null == subOrders ? _self._subOrders : subOrders // ignore: cast_nullable_to_non_nullable
as List<SubOrder>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Order
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
mixin _$CheckoutPayload {

 Order get order; List<SubOrder> get subOrders; String? get paymentId; String? get clientSecret; String? get providerRef; String get provider; String? get publishableKey;
/// Create a copy of CheckoutPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutPayloadCopyWith<CheckoutPayload> get copyWith => _$CheckoutPayloadCopyWithImpl<CheckoutPayload>(this as CheckoutPayload, _$identity);

  /// Serializes this CheckoutPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutPayload&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.subOrders, subOrders)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.providerRef, providerRef) || other.providerRef == providerRef)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(subOrders),paymentId,clientSecret,providerRef,provider,publishableKey);

@override
String toString() {
  return 'CheckoutPayload(order: $order, subOrders: $subOrders, paymentId: $paymentId, clientSecret: $clientSecret, providerRef: $providerRef, provider: $provider, publishableKey: $publishableKey)';
}


}

/// @nodoc
abstract mixin class $CheckoutPayloadCopyWith<$Res>  {
  factory $CheckoutPayloadCopyWith(CheckoutPayload value, $Res Function(CheckoutPayload) _then) = _$CheckoutPayloadCopyWithImpl;
@useResult
$Res call({
 Order order, List<SubOrder> subOrders, String? paymentId, String? clientSecret, String? providerRef, String provider, String? publishableKey
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$CheckoutPayloadCopyWithImpl<$Res>
    implements $CheckoutPayloadCopyWith<$Res> {
  _$CheckoutPayloadCopyWithImpl(this._self, this._then);

  final CheckoutPayload _self;
  final $Res Function(CheckoutPayload) _then;

/// Create a copy of CheckoutPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? subOrders = null,Object? paymentId = freezed,Object? clientSecret = freezed,Object? providerRef = freezed,Object? provider = null,Object? publishableKey = freezed,}) {
  return _then(_self.copyWith(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,subOrders: null == subOrders ? _self.subOrders : subOrders // ignore: cast_nullable_to_non_nullable
as List<SubOrder>,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,clientSecret: freezed == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String?,providerRef: freezed == providerRef ? _self.providerRef : providerRef // ignore: cast_nullable_to_non_nullable
as String?,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,publishableKey: freezed == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CheckoutPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckoutPayload].
extension CheckoutPayloadPatterns on CheckoutPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutPayload value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Order order,  List<SubOrder> subOrders,  String? paymentId,  String? clientSecret,  String? providerRef,  String provider,  String? publishableKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutPayload() when $default != null:
return $default(_that.order,_that.subOrders,_that.paymentId,_that.clientSecret,_that.providerRef,_that.provider,_that.publishableKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Order order,  List<SubOrder> subOrders,  String? paymentId,  String? clientSecret,  String? providerRef,  String provider,  String? publishableKey)  $default,) {final _that = this;
switch (_that) {
case _CheckoutPayload():
return $default(_that.order,_that.subOrders,_that.paymentId,_that.clientSecret,_that.providerRef,_that.provider,_that.publishableKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Order order,  List<SubOrder> subOrders,  String? paymentId,  String? clientSecret,  String? providerRef,  String provider,  String? publishableKey)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutPayload() when $default != null:
return $default(_that.order,_that.subOrders,_that.paymentId,_that.clientSecret,_that.providerRef,_that.provider,_that.publishableKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckoutPayload implements CheckoutPayload {
  const _CheckoutPayload({required this.order, final  List<SubOrder> subOrders = const <SubOrder>[], this.paymentId, this.clientSecret, this.providerRef, this.provider = 'stripe', this.publishableKey}): _subOrders = subOrders;
  factory _CheckoutPayload.fromJson(Map<String, dynamic> json) => _$CheckoutPayloadFromJson(json);

@override final  Order order;
 final  List<SubOrder> _subOrders;
@override@JsonKey() List<SubOrder> get subOrders {
  if (_subOrders is EqualUnmodifiableListView) return _subOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subOrders);
}

@override final  String? paymentId;
@override final  String? clientSecret;
@override final  String? providerRef;
@override@JsonKey() final  String provider;
@override final  String? publishableKey;

/// Create a copy of CheckoutPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutPayloadCopyWith<_CheckoutPayload> get copyWith => __$CheckoutPayloadCopyWithImpl<_CheckoutPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckoutPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutPayload&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._subOrders, _subOrders)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.providerRef, providerRef) || other.providerRef == providerRef)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(_subOrders),paymentId,clientSecret,providerRef,provider,publishableKey);

@override
String toString() {
  return 'CheckoutPayload(order: $order, subOrders: $subOrders, paymentId: $paymentId, clientSecret: $clientSecret, providerRef: $providerRef, provider: $provider, publishableKey: $publishableKey)';
}


}

/// @nodoc
abstract mixin class _$CheckoutPayloadCopyWith<$Res> implements $CheckoutPayloadCopyWith<$Res> {
  factory _$CheckoutPayloadCopyWith(_CheckoutPayload value, $Res Function(_CheckoutPayload) _then) = __$CheckoutPayloadCopyWithImpl;
@override @useResult
$Res call({
 Order order, List<SubOrder> subOrders, String? paymentId, String? clientSecret, String? providerRef, String provider, String? publishableKey
});


@override $OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$CheckoutPayloadCopyWithImpl<$Res>
    implements _$CheckoutPayloadCopyWith<$Res> {
  __$CheckoutPayloadCopyWithImpl(this._self, this._then);

  final _CheckoutPayload _self;
  final $Res Function(_CheckoutPayload) _then;

/// Create a copy of CheckoutPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? subOrders = null,Object? paymentId = freezed,Object? clientSecret = freezed,Object? providerRef = freezed,Object? provider = null,Object? publishableKey = freezed,}) {
  return _then(_CheckoutPayload(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,subOrders: null == subOrders ? _self._subOrders : subOrders // ignore: cast_nullable_to_non_nullable
as List<SubOrder>,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,clientSecret: freezed == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String?,providerRef: freezed == providerRef ? _self.providerRef : providerRef // ignore: cast_nullable_to_non_nullable
as String?,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,publishableKey: freezed == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CheckoutPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
