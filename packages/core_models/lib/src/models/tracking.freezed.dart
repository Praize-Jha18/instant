// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubOrderTracking {

 String get subOrderId; String get vendorId; String? get vendorName; SubOrderStatus get status; String? get deliveryId; DeliveryStatus? get deliveryStatus; String? get riderId; String? get riderName; String? get riderPhone; RiderLocation? get riderLocation;
/// Create a copy of SubOrderTracking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubOrderTrackingCopyWith<SubOrderTracking> get copyWith => _$SubOrderTrackingCopyWithImpl<SubOrderTracking>(this as SubOrderTracking, _$identity);

  /// Serializes this SubOrderTracking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubOrderTracking&&(identical(other.subOrderId, subOrderId) || other.subOrderId == subOrderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.riderName, riderName) || other.riderName == riderName)&&(identical(other.riderPhone, riderPhone) || other.riderPhone == riderPhone)&&(identical(other.riderLocation, riderLocation) || other.riderLocation == riderLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subOrderId,vendorId,vendorName,status,deliveryId,deliveryStatus,riderId,riderName,riderPhone,riderLocation);

@override
String toString() {
  return 'SubOrderTracking(subOrderId: $subOrderId, vendorId: $vendorId, vendorName: $vendorName, status: $status, deliveryId: $deliveryId, deliveryStatus: $deliveryStatus, riderId: $riderId, riderName: $riderName, riderPhone: $riderPhone, riderLocation: $riderLocation)';
}


}

/// @nodoc
abstract mixin class $SubOrderTrackingCopyWith<$Res>  {
  factory $SubOrderTrackingCopyWith(SubOrderTracking value, $Res Function(SubOrderTracking) _then) = _$SubOrderTrackingCopyWithImpl;
@useResult
$Res call({
 String subOrderId, String vendorId, String? vendorName, SubOrderStatus status, String? deliveryId, DeliveryStatus? deliveryStatus, String? riderId, String? riderName, String? riderPhone, RiderLocation? riderLocation
});


$RiderLocationCopyWith<$Res>? get riderLocation;

}
/// @nodoc
class _$SubOrderTrackingCopyWithImpl<$Res>
    implements $SubOrderTrackingCopyWith<$Res> {
  _$SubOrderTrackingCopyWithImpl(this._self, this._then);

  final SubOrderTracking _self;
  final $Res Function(SubOrderTracking) _then;

/// Create a copy of SubOrderTracking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subOrderId = null,Object? vendorId = null,Object? vendorName = freezed,Object? status = null,Object? deliveryId = freezed,Object? deliveryStatus = freezed,Object? riderId = freezed,Object? riderName = freezed,Object? riderPhone = freezed,Object? riderLocation = freezed,}) {
  return _then(_self.copyWith(
subOrderId: null == subOrderId ? _self.subOrderId : subOrderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubOrderStatus,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,deliveryStatus: freezed == deliveryStatus ? _self.deliveryStatus : deliveryStatus // ignore: cast_nullable_to_non_nullable
as DeliveryStatus?,riderId: freezed == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String?,riderName: freezed == riderName ? _self.riderName : riderName // ignore: cast_nullable_to_non_nullable
as String?,riderPhone: freezed == riderPhone ? _self.riderPhone : riderPhone // ignore: cast_nullable_to_non_nullable
as String?,riderLocation: freezed == riderLocation ? _self.riderLocation : riderLocation // ignore: cast_nullable_to_non_nullable
as RiderLocation?,
  ));
}
/// Create a copy of SubOrderTracking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderLocationCopyWith<$Res>? get riderLocation {
    if (_self.riderLocation == null) {
    return null;
  }

  return $RiderLocationCopyWith<$Res>(_self.riderLocation!, (value) {
    return _then(_self.copyWith(riderLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubOrderTracking].
extension SubOrderTrackingPatterns on SubOrderTracking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubOrderTracking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubOrderTracking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubOrderTracking value)  $default,){
final _that = this;
switch (_that) {
case _SubOrderTracking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubOrderTracking value)?  $default,){
final _that = this;
switch (_that) {
case _SubOrderTracking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subOrderId,  String vendorId,  String? vendorName,  SubOrderStatus status,  String? deliveryId,  DeliveryStatus? deliveryStatus,  String? riderId,  String? riderName,  String? riderPhone,  RiderLocation? riderLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubOrderTracking() when $default != null:
return $default(_that.subOrderId,_that.vendorId,_that.vendorName,_that.status,_that.deliveryId,_that.deliveryStatus,_that.riderId,_that.riderName,_that.riderPhone,_that.riderLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subOrderId,  String vendorId,  String? vendorName,  SubOrderStatus status,  String? deliveryId,  DeliveryStatus? deliveryStatus,  String? riderId,  String? riderName,  String? riderPhone,  RiderLocation? riderLocation)  $default,) {final _that = this;
switch (_that) {
case _SubOrderTracking():
return $default(_that.subOrderId,_that.vendorId,_that.vendorName,_that.status,_that.deliveryId,_that.deliveryStatus,_that.riderId,_that.riderName,_that.riderPhone,_that.riderLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subOrderId,  String vendorId,  String? vendorName,  SubOrderStatus status,  String? deliveryId,  DeliveryStatus? deliveryStatus,  String? riderId,  String? riderName,  String? riderPhone,  RiderLocation? riderLocation)?  $default,) {final _that = this;
switch (_that) {
case _SubOrderTracking() when $default != null:
return $default(_that.subOrderId,_that.vendorId,_that.vendorName,_that.status,_that.deliveryId,_that.deliveryStatus,_that.riderId,_that.riderName,_that.riderPhone,_that.riderLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubOrderTracking implements SubOrderTracking {
  const _SubOrderTracking({required this.subOrderId, required this.vendorId, this.vendorName, required this.status, this.deliveryId, this.deliveryStatus, this.riderId, this.riderName, this.riderPhone, this.riderLocation});
  factory _SubOrderTracking.fromJson(Map<String, dynamic> json) => _$SubOrderTrackingFromJson(json);

@override final  String subOrderId;
@override final  String vendorId;
@override final  String? vendorName;
@override final  SubOrderStatus status;
@override final  String? deliveryId;
@override final  DeliveryStatus? deliveryStatus;
@override final  String? riderId;
@override final  String? riderName;
@override final  String? riderPhone;
@override final  RiderLocation? riderLocation;

/// Create a copy of SubOrderTracking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubOrderTrackingCopyWith<_SubOrderTracking> get copyWith => __$SubOrderTrackingCopyWithImpl<_SubOrderTracking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubOrderTrackingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubOrderTracking&&(identical(other.subOrderId, subOrderId) || other.subOrderId == subOrderId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.riderName, riderName) || other.riderName == riderName)&&(identical(other.riderPhone, riderPhone) || other.riderPhone == riderPhone)&&(identical(other.riderLocation, riderLocation) || other.riderLocation == riderLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subOrderId,vendorId,vendorName,status,deliveryId,deliveryStatus,riderId,riderName,riderPhone,riderLocation);

@override
String toString() {
  return 'SubOrderTracking(subOrderId: $subOrderId, vendorId: $vendorId, vendorName: $vendorName, status: $status, deliveryId: $deliveryId, deliveryStatus: $deliveryStatus, riderId: $riderId, riderName: $riderName, riderPhone: $riderPhone, riderLocation: $riderLocation)';
}


}

/// @nodoc
abstract mixin class _$SubOrderTrackingCopyWith<$Res> implements $SubOrderTrackingCopyWith<$Res> {
  factory _$SubOrderTrackingCopyWith(_SubOrderTracking value, $Res Function(_SubOrderTracking) _then) = __$SubOrderTrackingCopyWithImpl;
@override @useResult
$Res call({
 String subOrderId, String vendorId, String? vendorName, SubOrderStatus status, String? deliveryId, DeliveryStatus? deliveryStatus, String? riderId, String? riderName, String? riderPhone, RiderLocation? riderLocation
});


@override $RiderLocationCopyWith<$Res>? get riderLocation;

}
/// @nodoc
class __$SubOrderTrackingCopyWithImpl<$Res>
    implements _$SubOrderTrackingCopyWith<$Res> {
  __$SubOrderTrackingCopyWithImpl(this._self, this._then);

  final _SubOrderTracking _self;
  final $Res Function(_SubOrderTracking) _then;

/// Create a copy of SubOrderTracking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subOrderId = null,Object? vendorId = null,Object? vendorName = freezed,Object? status = null,Object? deliveryId = freezed,Object? deliveryStatus = freezed,Object? riderId = freezed,Object? riderName = freezed,Object? riderPhone = freezed,Object? riderLocation = freezed,}) {
  return _then(_SubOrderTracking(
subOrderId: null == subOrderId ? _self.subOrderId : subOrderId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubOrderStatus,deliveryId: freezed == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String?,deliveryStatus: freezed == deliveryStatus ? _self.deliveryStatus : deliveryStatus // ignore: cast_nullable_to_non_nullable
as DeliveryStatus?,riderId: freezed == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String?,riderName: freezed == riderName ? _self.riderName : riderName // ignore: cast_nullable_to_non_nullable
as String?,riderPhone: freezed == riderPhone ? _self.riderPhone : riderPhone // ignore: cast_nullable_to_non_nullable
as String?,riderLocation: freezed == riderLocation ? _self.riderLocation : riderLocation // ignore: cast_nullable_to_non_nullable
as RiderLocation?,
  ));
}

/// Create a copy of SubOrderTracking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderLocationCopyWith<$Res>? get riderLocation {
    if (_self.riderLocation == null) {
    return null;
  }

  return $RiderLocationCopyWith<$Res>(_self.riderLocation!, (value) {
    return _then(_self.copyWith(riderLocation: value));
  });
}
}


/// @nodoc
mixin _$OrderTracking {

 String get orderId; List<SubOrderTracking> get subOrders;
/// Create a copy of OrderTracking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTrackingCopyWith<OrderTracking> get copyWith => _$OrderTrackingCopyWithImpl<OrderTracking>(this as OrderTracking, _$identity);

  /// Serializes this OrderTracking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTracking&&(identical(other.orderId, orderId) || other.orderId == orderId)&&const DeepCollectionEquality().equals(other.subOrders, subOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,const DeepCollectionEquality().hash(subOrders));

@override
String toString() {
  return 'OrderTracking(orderId: $orderId, subOrders: $subOrders)';
}


}

/// @nodoc
abstract mixin class $OrderTrackingCopyWith<$Res>  {
  factory $OrderTrackingCopyWith(OrderTracking value, $Res Function(OrderTracking) _then) = _$OrderTrackingCopyWithImpl;
@useResult
$Res call({
 String orderId, List<SubOrderTracking> subOrders
});




}
/// @nodoc
class _$OrderTrackingCopyWithImpl<$Res>
    implements $OrderTrackingCopyWith<$Res> {
  _$OrderTrackingCopyWithImpl(this._self, this._then);

  final OrderTracking _self;
  final $Res Function(OrderTracking) _then;

/// Create a copy of OrderTracking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? subOrders = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,subOrders: null == subOrders ? _self.subOrders : subOrders // ignore: cast_nullable_to_non_nullable
as List<SubOrderTracking>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTracking].
extension OrderTrackingPatterns on OrderTracking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTracking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTracking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTracking value)  $default,){
final _that = this;
switch (_that) {
case _OrderTracking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTracking value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTracking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  List<SubOrderTracking> subOrders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTracking() when $default != null:
return $default(_that.orderId,_that.subOrders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  List<SubOrderTracking> subOrders)  $default,) {final _that = this;
switch (_that) {
case _OrderTracking():
return $default(_that.orderId,_that.subOrders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  List<SubOrderTracking> subOrders)?  $default,) {final _that = this;
switch (_that) {
case _OrderTracking() when $default != null:
return $default(_that.orderId,_that.subOrders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderTracking implements OrderTracking {
  const _OrderTracking({required this.orderId, final  List<SubOrderTracking> subOrders = const <SubOrderTracking>[]}): _subOrders = subOrders;
  factory _OrderTracking.fromJson(Map<String, dynamic> json) => _$OrderTrackingFromJson(json);

@override final  String orderId;
 final  List<SubOrderTracking> _subOrders;
@override@JsonKey() List<SubOrderTracking> get subOrders {
  if (_subOrders is EqualUnmodifiableListView) return _subOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subOrders);
}


/// Create a copy of OrderTracking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTrackingCopyWith<_OrderTracking> get copyWith => __$OrderTrackingCopyWithImpl<_OrderTracking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderTrackingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTracking&&(identical(other.orderId, orderId) || other.orderId == orderId)&&const DeepCollectionEquality().equals(other._subOrders, _subOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,const DeepCollectionEquality().hash(_subOrders));

@override
String toString() {
  return 'OrderTracking(orderId: $orderId, subOrders: $subOrders)';
}


}

/// @nodoc
abstract mixin class _$OrderTrackingCopyWith<$Res> implements $OrderTrackingCopyWith<$Res> {
  factory _$OrderTrackingCopyWith(_OrderTracking value, $Res Function(_OrderTracking) _then) = __$OrderTrackingCopyWithImpl;
@override @useResult
$Res call({
 String orderId, List<SubOrderTracking> subOrders
});




}
/// @nodoc
class __$OrderTrackingCopyWithImpl<$Res>
    implements _$OrderTrackingCopyWith<$Res> {
  __$OrderTrackingCopyWithImpl(this._self, this._then);

  final _OrderTracking _self;
  final $Res Function(_OrderTracking) _then;

/// Create a copy of OrderTracking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? subOrders = null,}) {
  return _then(_OrderTracking(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,subOrders: null == subOrders ? _self._subOrders : subOrders // ignore: cast_nullable_to_non_nullable
as List<SubOrderTracking>,
  ));
}


}

// dart format on
