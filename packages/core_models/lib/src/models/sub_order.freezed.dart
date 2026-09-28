// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubOrder {

@JsonKey(readValue: readId) String get id; String get orderId; String get vendorId; String get customerId; List<OrderItem> get items; int get subtotalKobo; int get deliveryFeeKobo; int get commissionKobo; int get vendorNetKobo; SubOrderStatus get status; String? get deliveryId; List<TimelineEntry> get timeline; String? get orderNumber; String? get vendorName; String? get vendorNameSnapshot; String? get customerName;/// Hand-over code the customer shows the rider (§11). Visible to customer and vendor.
 String? get deliveryOtp; int get refundedKobo;@NullableDateTimeConverter() DateTime? get createdAt;@NullableDateTimeConverter() DateTime? get updatedAt;@NullableDateTimeConverter() DateTime? get deletedAt; int get version;
/// Create a copy of SubOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubOrderCopyWith<SubOrder> get copyWith => _$SubOrderCopyWithImpl<SubOrder>(this as SubOrder, _$identity);

  /// Serializes this SubOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalKobo, subtotalKobo) || other.subtotalKobo == subtotalKobo)&&(identical(other.deliveryFeeKobo, deliveryFeeKobo) || other.deliveryFeeKobo == deliveryFeeKobo)&&(identical(other.commissionKobo, commissionKobo) || other.commissionKobo == commissionKobo)&&(identical(other.vendorNetKobo, vendorNetKobo) || other.vendorNetKobo == vendorNetKobo)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&const DeepCollectionEquality().equals(other.timeline, timeline)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.vendorNameSnapshot, vendorNameSnapshot) || other.vendorNameSnapshot == vendorNameSnapshot)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.deliveryOtp, deliveryOtp) || other.deliveryOtp == deliveryOtp)&&(identical(other.refundedKobo, refundedKobo) || other.refundedKobo == refundedKobo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,vendorId,customerId,const DeepCollectionEquality().hash(items),subtotalKobo,deliveryFeeKobo,commissionKobo,vendorNetKobo,status,deliveryId,const DeepCollectionEquality().hash(timeline),orderNumber,vendorName,vendorNameSnapshot,customerName,deliveryOtp,refundedKobo,createdAt,updatedAt,deletedAt,version]);

@override
String toString() {
  return 'SubOrder(id: $id, orderId: $orderId, vendorId: $vendorId, customerId: $customerId, items: $items, subtotalKobo: $subtotalKobo, deliveryFeeKobo: $deliveryFeeKobo, commissionKobo: $commissionKobo, vendorNetKobo: $vendorNetKobo, status: $status, deliveryId: $deliveryId, timeline: $timeline, orderNumber: $orderNumber, vendorName: $vendorName, vendorNameSnapshot: $vendorNameSnapshot, customerName: $customerName, deliveryOtp: $deliveryOtp, refundedKobo: $refundedKobo, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $SubOrderCopyWith<$Res>  {
  factory $SubOrderCopyWith(SubOrder value, $Res Function(SubOrder) _then) = _$SubOrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: readId) String id, String orderId, String vendorId, String customerId, List<OrderItem> items, int subtotalKobo, int deliveryFeeKobo, int commissionKobo, int vendorNetKobo, SubOrderStatus status, String? deliveryId, List<TimelineEntry> timeline, String? orderNumber, String? vendorName, String? vendorNameSnapshot, String? customerName, String? deliveryOtp, int refundedKobo,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class _$SubOrderCopyWithImpl<$Res>
    implements $SubOrderCopyWith<$Res> {
  _$SubOrderCopyWithImpl(this._self, this._then);

  final SubOrder _self;
  final $Res Function(SubOrder) _then;

/// Create a copy of SubOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? vendorId = null,Object? customerId = null,Object? items = null,Object? subtotalKobo = null,Object? deliveryFeeKobo = null,Object? commissionKobo = null,Object? vendorNetKobo = null,Object? status = null,Object? deliveryId = freezed,Object? timeline = null,Object? orderNumber = freezed,Object? vendorName = freezed,Object? vendorNameSnapshot = freezed,Object? customerName = freezed,Object? deliveryOtp = freezed,Object? refundedKobo = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,subtotalKobo: null == subtotalKobo ? _self.subtotalKobo : subtotalKobo // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeKobo: null == deliveryFeeKobo ? _self.deliveryFeeKobo : deliveryFeeKobo // ignore: cast_nullable_to_non_nullable
as int,commissionKobo: null == commissionKobo ? _self.commissionKobo : commissionKobo // ignore: cast_nullable_to_non_nullable
as int,vendorNetKobo: null == vendorNetKobo ? _self.vendorNetKobo : vendorNetKobo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubOrderStatus,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEntry>,orderNumber: freezed == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,vendorNameSnapshot: freezed == vendorNameSnapshot ? _self.vendorNameSnapshot : vendorNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,deliveryOtp: freezed == deliveryOtp ? _self.deliveryOtp : deliveryOtp // ignore: cast_nullable_to_non_nullable
as String?,refundedKobo: null == refundedKobo ? _self.refundedKobo : refundedKobo // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SubOrder].
extension SubOrderPatterns on SubOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubOrder value)  $default,){
final _that = this;
switch (_that) {
case _SubOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubOrder value)?  $default,){
final _that = this;
switch (_that) {
case _SubOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String orderId,  String vendorId,  String customerId,  List<OrderItem> items,  int subtotalKobo,  int deliveryFeeKobo,  int commissionKobo,  int vendorNetKobo,  SubOrderStatus status,  String? deliveryId,  List<TimelineEntry> timeline,  String? orderNumber,  String? vendorName,  String? vendorNameSnapshot,  String? customerName,  String? deliveryOtp,  int refundedKobo, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubOrder() when $default != null:
return $default(_that.id,_that.orderId,_that.vendorId,_that.customerId,_that.items,_that.subtotalKobo,_that.deliveryFeeKobo,_that.commissionKobo,_that.vendorNetKobo,_that.status,_that.deliveryId,_that.timeline,_that.orderNumber,_that.vendorName,_that.vendorNameSnapshot,_that.customerName,_that.deliveryOtp,_that.refundedKobo,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: readId)  String id,  String orderId,  String vendorId,  String customerId,  List<OrderItem> items,  int subtotalKobo,  int deliveryFeeKobo,  int commissionKobo,  int vendorNetKobo,  SubOrderStatus status,  String? deliveryId,  List<TimelineEntry> timeline,  String? orderNumber,  String? vendorName,  String? vendorNameSnapshot,  String? customerName,  String? deliveryOtp,  int refundedKobo, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _SubOrder():
return $default(_that.id,_that.orderId,_that.vendorId,_that.customerId,_that.items,_that.subtotalKobo,_that.deliveryFeeKobo,_that.commissionKobo,_that.vendorNetKobo,_that.status,_that.deliveryId,_that.timeline,_that.orderNumber,_that.vendorName,_that.vendorNameSnapshot,_that.customerName,_that.deliveryOtp,_that.refundedKobo,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: readId)  String id,  String orderId,  String vendorId,  String customerId,  List<OrderItem> items,  int subtotalKobo,  int deliveryFeeKobo,  int commissionKobo,  int vendorNetKobo,  SubOrderStatus status,  String? deliveryId,  List<TimelineEntry> timeline,  String? orderNumber,  String? vendorName,  String? vendorNameSnapshot,  String? customerName,  String? deliveryOtp,  int refundedKobo, @NullableDateTimeConverter()  DateTime? createdAt, @NullableDateTimeConverter()  DateTime? updatedAt, @NullableDateTimeConverter()  DateTime? deletedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _SubOrder() when $default != null:
return $default(_that.id,_that.orderId,_that.vendorId,_that.customerId,_that.items,_that.subtotalKobo,_that.deliveryFeeKobo,_that.commissionKobo,_that.vendorNetKobo,_that.status,_that.deliveryId,_that.timeline,_that.orderNumber,_that.vendorName,_that.vendorNameSnapshot,_that.customerName,_that.deliveryOtp,_that.refundedKobo,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubOrder extends SubOrder {
  const _SubOrder({@JsonKey(readValue: readId) required this.id, required this.orderId, required this.vendorId, required this.customerId, final  List<OrderItem> items = const <OrderItem>[], this.subtotalKobo = 0, this.deliveryFeeKobo = 0, this.commissionKobo = 0, this.vendorNetKobo = 0, this.status = SubOrderStatus.awaitingPayment, this.deliveryId, final  List<TimelineEntry> timeline = const <TimelineEntry>[], this.orderNumber, this.vendorName, this.vendorNameSnapshot, this.customerName, this.deliveryOtp, this.refundedKobo = 0, @NullableDateTimeConverter() this.createdAt, @NullableDateTimeConverter() this.updatedAt, @NullableDateTimeConverter() this.deletedAt, this.version = 0}): _items = items,_timeline = timeline,super._();
  factory _SubOrder.fromJson(Map<String, dynamic> json) => _$SubOrderFromJson(json);

@override@JsonKey(readValue: readId) final  String id;
@override final  String orderId;
@override final  String vendorId;
@override final  String customerId;
 final  List<OrderItem> _items;
@override@JsonKey() List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int subtotalKobo;
@override@JsonKey() final  int deliveryFeeKobo;
@override@JsonKey() final  int commissionKobo;
@override@JsonKey() final  int vendorNetKobo;
@override@JsonKey() final  SubOrderStatus status;
@override final  String? deliveryId;
 final  List<TimelineEntry> _timeline;
@override@JsonKey() List<TimelineEntry> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}

@override final  String? orderNumber;
@override final  String? vendorName;
@override final  String? vendorNameSnapshot;
@override final  String? customerName;
/// Hand-over code the customer shows the rider (§11). Visible to customer and vendor.
@override final  String? deliveryOtp;
@override@JsonKey() final  int refundedKobo;
@override@NullableDateTimeConverter() final  DateTime? createdAt;
@override@NullableDateTimeConverter() final  DateTime? updatedAt;
@override@NullableDateTimeConverter() final  DateTime? deletedAt;
@override@JsonKey() final  int version;

/// Create a copy of SubOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubOrderCopyWith<_SubOrder> get copyWith => __$SubOrderCopyWithImpl<_SubOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalKobo, subtotalKobo) || other.subtotalKobo == subtotalKobo)&&(identical(other.deliveryFeeKobo, deliveryFeeKobo) || other.deliveryFeeKobo == deliveryFeeKobo)&&(identical(other.commissionKobo, commissionKobo) || other.commissionKobo == commissionKobo)&&(identical(other.vendorNetKobo, vendorNetKobo) || other.vendorNetKobo == vendorNetKobo)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&const DeepCollectionEquality().equals(other._timeline, _timeline)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.vendorNameSnapshot, vendorNameSnapshot) || other.vendorNameSnapshot == vendorNameSnapshot)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.deliveryOtp, deliveryOtp) || other.deliveryOtp == deliveryOtp)&&(identical(other.refundedKobo, refundedKobo) || other.refundedKobo == refundedKobo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,vendorId,customerId,const DeepCollectionEquality().hash(_items),subtotalKobo,deliveryFeeKobo,commissionKobo,vendorNetKobo,status,deliveryId,const DeepCollectionEquality().hash(_timeline),orderNumber,vendorName,vendorNameSnapshot,customerName,deliveryOtp,refundedKobo,createdAt,updatedAt,deletedAt,version]);

@override
String toString() {
  return 'SubOrder(id: $id, orderId: $orderId, vendorId: $vendorId, customerId: $customerId, items: $items, subtotalKobo: $subtotalKobo, deliveryFeeKobo: $deliveryFeeKobo, commissionKobo: $commissionKobo, vendorNetKobo: $vendorNetKobo, status: $status, deliveryId: $deliveryId, timeline: $timeline, orderNumber: $orderNumber, vendorName: $vendorName, vendorNameSnapshot: $vendorNameSnapshot, customerName: $customerName, deliveryOtp: $deliveryOtp, refundedKobo: $refundedKobo, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$SubOrderCopyWith<$Res> implements $SubOrderCopyWith<$Res> {
  factory _$SubOrderCopyWith(_SubOrder value, $Res Function(_SubOrder) _then) = __$SubOrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: readId) String id, String orderId, String vendorId, String customerId, List<OrderItem> items, int subtotalKobo, int deliveryFeeKobo, int commissionKobo, int vendorNetKobo, SubOrderStatus status, String? deliveryId, List<TimelineEntry> timeline, String? orderNumber, String? vendorName, String? vendorNameSnapshot, String? customerName, String? deliveryOtp, int refundedKobo,@NullableDateTimeConverter() DateTime? createdAt,@NullableDateTimeConverter() DateTime? updatedAt,@NullableDateTimeConverter() DateTime? deletedAt, int version
});




}
/// @nodoc
class __$SubOrderCopyWithImpl<$Res>
    implements _$SubOrderCopyWith<$Res> {
  __$SubOrderCopyWithImpl(this._self, this._then);

  final _SubOrder _self;
  final $Res Function(_SubOrder) _then;

/// Create a copy of SubOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? vendorId = null,Object? customerId = null,Object? items = null,Object? subtotalKobo = null,Object? deliveryFeeKobo = null,Object? commissionKobo = null,Object? vendorNetKobo = null,Object? status = null,Object? deliveryId = freezed,Object? timeline = null,Object? orderNumber = freezed,Object? vendorName = freezed,Object? vendorNameSnapshot = freezed,Object? customerName = freezed,Object? deliveryOtp = freezed,Object? refundedKobo = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? version = null,}) {
  return _then(_SubOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,subtotalKobo: null == subtotalKobo ? _self.subtotalKobo : subtotalKobo // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeKobo: null == deliveryFeeKobo ? _self.deliveryFeeKobo : deliveryFeeKobo // ignore: cast_nullable_to_non_nullable
as int,commissionKobo: null == commissionKobo ? _self.commissionKobo : commissionKobo // ignore: cast_nullable_to_non_nullable
as int,vendorNetKobo: null == vendorNetKobo ? _self.vendorNetKobo : vendorNetKobo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubOrderStatus,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEntry>,orderNumber: freezed == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,vendorNameSnapshot: freezed == vendorNameSnapshot ? _self.vendorNameSnapshot : vendorNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,deliveryOtp: freezed == deliveryOtp ? _self.deliveryOtp : deliveryOtp // ignore: cast_nullable_to_non_nullable
as String?,refundedKobo: null == refundedKobo ? _self.refundedKobo : refundedKobo // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
