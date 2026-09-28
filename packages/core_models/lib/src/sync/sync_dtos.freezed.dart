// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncOp {

 String get opId; String get entity; SyncOpAction get action;@JsonKey(name: 'customAction') String? get customAction; Map<String, Object?> get payload;@DateTimeConverter() DateTime get clientAt;
/// Create a copy of SyncOp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncOpCopyWith<SyncOp> get copyWith => _$SyncOpCopyWithImpl<SyncOp>(this as SyncOp, _$identity);

  /// Serializes this SyncOp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncOp&&(identical(other.opId, opId) || other.opId == opId)&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.action, action) || other.action == action)&&(identical(other.customAction, customAction) || other.customAction == customAction)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.clientAt, clientAt) || other.clientAt == clientAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opId,entity,action,customAction,const DeepCollectionEquality().hash(payload),clientAt);

@override
String toString() {
  return 'SyncOp(opId: $opId, entity: $entity, action: $action, customAction: $customAction, payload: $payload, clientAt: $clientAt)';
}


}

/// @nodoc
abstract mixin class $SyncOpCopyWith<$Res>  {
  factory $SyncOpCopyWith(SyncOp value, $Res Function(SyncOp) _then) = _$SyncOpCopyWithImpl;
@useResult
$Res call({
 String opId, String entity, SyncOpAction action,@JsonKey(name: 'customAction') String? customAction, Map<String, Object?> payload,@DateTimeConverter() DateTime clientAt
});




}
/// @nodoc
class _$SyncOpCopyWithImpl<$Res>
    implements $SyncOpCopyWith<$Res> {
  _$SyncOpCopyWithImpl(this._self, this._then);

  final SyncOp _self;
  final $Res Function(SyncOp) _then;

/// Create a copy of SyncOp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? opId = null,Object? entity = null,Object? action = null,Object? customAction = freezed,Object? payload = null,Object? clientAt = null,}) {
  return _then(_self.copyWith(
opId: null == opId ? _self.opId : opId // ignore: cast_nullable_to_non_nullable
as String,entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SyncOpAction,customAction: freezed == customAction ? _self.customAction : customAction // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,clientAt: null == clientAt ? _self.clientAt : clientAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncOp].
extension SyncOpPatterns on SyncOp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncOp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncOp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncOp value)  $default,){
final _that = this;
switch (_that) {
case _SyncOp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncOp value)?  $default,){
final _that = this;
switch (_that) {
case _SyncOp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String opId,  String entity,  SyncOpAction action, @JsonKey(name: 'customAction')  String? customAction,  Map<String, Object?> payload, @DateTimeConverter()  DateTime clientAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncOp() when $default != null:
return $default(_that.opId,_that.entity,_that.action,_that.customAction,_that.payload,_that.clientAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String opId,  String entity,  SyncOpAction action, @JsonKey(name: 'customAction')  String? customAction,  Map<String, Object?> payload, @DateTimeConverter()  DateTime clientAt)  $default,) {final _that = this;
switch (_that) {
case _SyncOp():
return $default(_that.opId,_that.entity,_that.action,_that.customAction,_that.payload,_that.clientAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String opId,  String entity,  SyncOpAction action, @JsonKey(name: 'customAction')  String? customAction,  Map<String, Object?> payload, @DateTimeConverter()  DateTime clientAt)?  $default,) {final _that = this;
switch (_that) {
case _SyncOp() when $default != null:
return $default(_that.opId,_that.entity,_that.action,_that.customAction,_that.payload,_that.clientAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncOp extends SyncOp {
  const _SyncOp({required this.opId, required this.entity, required this.action, @JsonKey(name: 'customAction') this.customAction, final  Map<String, Object?> payload = const <String, Object?>{}, @DateTimeConverter() required this.clientAt}): _payload = payload,super._();
  factory _SyncOp.fromJson(Map<String, dynamic> json) => _$SyncOpFromJson(json);

@override final  String opId;
@override final  String entity;
@override final  SyncOpAction action;
@override@JsonKey(name: 'customAction') final  String? customAction;
 final  Map<String, Object?> _payload;
@override@JsonKey() Map<String, Object?> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override@DateTimeConverter() final  DateTime clientAt;

/// Create a copy of SyncOp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncOpCopyWith<_SyncOp> get copyWith => __$SyncOpCopyWithImpl<_SyncOp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncOpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncOp&&(identical(other.opId, opId) || other.opId == opId)&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.action, action) || other.action == action)&&(identical(other.customAction, customAction) || other.customAction == customAction)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.clientAt, clientAt) || other.clientAt == clientAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opId,entity,action,customAction,const DeepCollectionEquality().hash(_payload),clientAt);

@override
String toString() {
  return 'SyncOp(opId: $opId, entity: $entity, action: $action, customAction: $customAction, payload: $payload, clientAt: $clientAt)';
}


}

/// @nodoc
abstract mixin class _$SyncOpCopyWith<$Res> implements $SyncOpCopyWith<$Res> {
  factory _$SyncOpCopyWith(_SyncOp value, $Res Function(_SyncOp) _then) = __$SyncOpCopyWithImpl;
@override @useResult
$Res call({
 String opId, String entity, SyncOpAction action,@JsonKey(name: 'customAction') String? customAction, Map<String, Object?> payload,@DateTimeConverter() DateTime clientAt
});




}
/// @nodoc
class __$SyncOpCopyWithImpl<$Res>
    implements _$SyncOpCopyWith<$Res> {
  __$SyncOpCopyWithImpl(this._self, this._then);

  final _SyncOp _self;
  final $Res Function(_SyncOp) _then;

/// Create a copy of SyncOp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? opId = null,Object? entity = null,Object? action = null,Object? customAction = freezed,Object? payload = null,Object? clientAt = null,}) {
  return _then(_SyncOp(
opId: null == opId ? _self.opId : opId // ignore: cast_nullable_to_non_nullable
as String,entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as SyncOpAction,customAction: freezed == customAction ? _self.customAction : customAction // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,clientAt: null == clientAt ? _self.clientAt : clientAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SyncPushRequest {

 List<SyncOp> get ops;
/// Create a copy of SyncPushRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncPushRequestCopyWith<SyncPushRequest> get copyWith => _$SyncPushRequestCopyWithImpl<SyncPushRequest>(this as SyncPushRequest, _$identity);

  /// Serializes this SyncPushRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncPushRequest&&const DeepCollectionEquality().equals(other.ops, ops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ops));

@override
String toString() {
  return 'SyncPushRequest(ops: $ops)';
}


}

/// @nodoc
abstract mixin class $SyncPushRequestCopyWith<$Res>  {
  factory $SyncPushRequestCopyWith(SyncPushRequest value, $Res Function(SyncPushRequest) _then) = _$SyncPushRequestCopyWithImpl;
@useResult
$Res call({
 List<SyncOp> ops
});




}
/// @nodoc
class _$SyncPushRequestCopyWithImpl<$Res>
    implements $SyncPushRequestCopyWith<$Res> {
  _$SyncPushRequestCopyWithImpl(this._self, this._then);

  final SyncPushRequest _self;
  final $Res Function(SyncPushRequest) _then;

/// Create a copy of SyncPushRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ops = null,}) {
  return _then(_self.copyWith(
ops: null == ops ? _self.ops : ops // ignore: cast_nullable_to_non_nullable
as List<SyncOp>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncPushRequest].
extension SyncPushRequestPatterns on SyncPushRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncPushRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncPushRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncPushRequest value)  $default,){
final _that = this;
switch (_that) {
case _SyncPushRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncPushRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SyncPushRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SyncOp> ops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncPushRequest() when $default != null:
return $default(_that.ops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SyncOp> ops)  $default,) {final _that = this;
switch (_that) {
case _SyncPushRequest():
return $default(_that.ops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SyncOp> ops)?  $default,) {final _that = this;
switch (_that) {
case _SyncPushRequest() when $default != null:
return $default(_that.ops);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncPushRequest implements SyncPushRequest {
  const _SyncPushRequest({required final  List<SyncOp> ops}): _ops = ops;
  factory _SyncPushRequest.fromJson(Map<String, dynamic> json) => _$SyncPushRequestFromJson(json);

 final  List<SyncOp> _ops;
@override List<SyncOp> get ops {
  if (_ops is EqualUnmodifiableListView) return _ops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ops);
}


/// Create a copy of SyncPushRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncPushRequestCopyWith<_SyncPushRequest> get copyWith => __$SyncPushRequestCopyWithImpl<_SyncPushRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncPushRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncPushRequest&&const DeepCollectionEquality().equals(other._ops, _ops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ops));

@override
String toString() {
  return 'SyncPushRequest(ops: $ops)';
}


}

/// @nodoc
abstract mixin class _$SyncPushRequestCopyWith<$Res> implements $SyncPushRequestCopyWith<$Res> {
  factory _$SyncPushRequestCopyWith(_SyncPushRequest value, $Res Function(_SyncPushRequest) _then) = __$SyncPushRequestCopyWithImpl;
@override @useResult
$Res call({
 List<SyncOp> ops
});




}
/// @nodoc
class __$SyncPushRequestCopyWithImpl<$Res>
    implements _$SyncPushRequestCopyWith<$Res> {
  __$SyncPushRequestCopyWithImpl(this._self, this._then);

  final _SyncPushRequest _self;
  final $Res Function(_SyncPushRequest) _then;

/// Create a copy of SyncPushRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ops = null,}) {
  return _then(_SyncPushRequest(
ops: null == ops ? _self._ops : ops // ignore: cast_nullable_to_non_nullable
as List<SyncOp>,
  ));
}


}


/// @nodoc
mixin _$SyncPushResult {

 String get opId; SyncOpStatus get status; String? get code; String? get message; Map<String, Object?>? get doc;
/// Create a copy of SyncPushResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncPushResultCopyWith<SyncPushResult> get copyWith => _$SyncPushResultCopyWithImpl<SyncPushResult>(this as SyncPushResult, _$identity);

  /// Serializes this SyncPushResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncPushResult&&(identical(other.opId, opId) || other.opId == opId)&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.doc, doc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opId,status,code,message,const DeepCollectionEquality().hash(doc));

@override
String toString() {
  return 'SyncPushResult(opId: $opId, status: $status, code: $code, message: $message, doc: $doc)';
}


}

/// @nodoc
abstract mixin class $SyncPushResultCopyWith<$Res>  {
  factory $SyncPushResultCopyWith(SyncPushResult value, $Res Function(SyncPushResult) _then) = _$SyncPushResultCopyWithImpl;
@useResult
$Res call({
 String opId, SyncOpStatus status, String? code, String? message, Map<String, Object?>? doc
});




}
/// @nodoc
class _$SyncPushResultCopyWithImpl<$Res>
    implements $SyncPushResultCopyWith<$Res> {
  _$SyncPushResultCopyWithImpl(this._self, this._then);

  final SyncPushResult _self;
  final $Res Function(SyncPushResult) _then;

/// Create a copy of SyncPushResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? opId = null,Object? status = null,Object? code = freezed,Object? message = freezed,Object? doc = freezed,}) {
  return _then(_self.copyWith(
opId: null == opId ? _self.opId : opId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncOpStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,doc: freezed == doc ? _self.doc : doc // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncPushResult].
extension SyncPushResultPatterns on SyncPushResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncPushResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncPushResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncPushResult value)  $default,){
final _that = this;
switch (_that) {
case _SyncPushResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncPushResult value)?  $default,){
final _that = this;
switch (_that) {
case _SyncPushResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String opId,  SyncOpStatus status,  String? code,  String? message,  Map<String, Object?>? doc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncPushResult() when $default != null:
return $default(_that.opId,_that.status,_that.code,_that.message,_that.doc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String opId,  SyncOpStatus status,  String? code,  String? message,  Map<String, Object?>? doc)  $default,) {final _that = this;
switch (_that) {
case _SyncPushResult():
return $default(_that.opId,_that.status,_that.code,_that.message,_that.doc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String opId,  SyncOpStatus status,  String? code,  String? message,  Map<String, Object?>? doc)?  $default,) {final _that = this;
switch (_that) {
case _SyncPushResult() when $default != null:
return $default(_that.opId,_that.status,_that.code,_that.message,_that.doc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncPushResult extends SyncPushResult {
  const _SyncPushResult({required this.opId, required this.status, this.code, this.message, final  Map<String, Object?>? doc}): _doc = doc,super._();
  factory _SyncPushResult.fromJson(Map<String, dynamic> json) => _$SyncPushResultFromJson(json);

@override final  String opId;
@override final  SyncOpStatus status;
@override final  String? code;
@override final  String? message;
 final  Map<String, Object?>? _doc;
@override Map<String, Object?>? get doc {
  final value = _doc;
  if (value == null) return null;
  if (_doc is EqualUnmodifiableMapView) return _doc;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SyncPushResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncPushResultCopyWith<_SyncPushResult> get copyWith => __$SyncPushResultCopyWithImpl<_SyncPushResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncPushResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncPushResult&&(identical(other.opId, opId) || other.opId == opId)&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._doc, _doc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opId,status,code,message,const DeepCollectionEquality().hash(_doc));

@override
String toString() {
  return 'SyncPushResult(opId: $opId, status: $status, code: $code, message: $message, doc: $doc)';
}


}

/// @nodoc
abstract mixin class _$SyncPushResultCopyWith<$Res> implements $SyncPushResultCopyWith<$Res> {
  factory _$SyncPushResultCopyWith(_SyncPushResult value, $Res Function(_SyncPushResult) _then) = __$SyncPushResultCopyWithImpl;
@override @useResult
$Res call({
 String opId, SyncOpStatus status, String? code, String? message, Map<String, Object?>? doc
});




}
/// @nodoc
class __$SyncPushResultCopyWithImpl<$Res>
    implements _$SyncPushResultCopyWith<$Res> {
  __$SyncPushResultCopyWithImpl(this._self, this._then);

  final _SyncPushResult _self;
  final $Res Function(_SyncPushResult) _then;

/// Create a copy of SyncPushResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? opId = null,Object? status = null,Object? code = freezed,Object? message = freezed,Object? doc = freezed,}) {
  return _then(_SyncPushResult(
opId: null == opId ? _self.opId : opId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncOpStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,doc: freezed == doc ? _self._doc : doc // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}


/// @nodoc
mixin _$SyncPushResponse {

 List<SyncPushResult> get results;
/// Create a copy of SyncPushResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncPushResponseCopyWith<SyncPushResponse> get copyWith => _$SyncPushResponseCopyWithImpl<SyncPushResponse>(this as SyncPushResponse, _$identity);

  /// Serializes this SyncPushResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncPushResponse&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SyncPushResponse(results: $results)';
}


}

/// @nodoc
abstract mixin class $SyncPushResponseCopyWith<$Res>  {
  factory $SyncPushResponseCopyWith(SyncPushResponse value, $Res Function(SyncPushResponse) _then) = _$SyncPushResponseCopyWithImpl;
@useResult
$Res call({
 List<SyncPushResult> results
});




}
/// @nodoc
class _$SyncPushResponseCopyWithImpl<$Res>
    implements $SyncPushResponseCopyWith<$Res> {
  _$SyncPushResponseCopyWithImpl(this._self, this._then);

  final SyncPushResponse _self;
  final $Res Function(SyncPushResponse) _then;

/// Create a copy of SyncPushResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SyncPushResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncPushResponse].
extension SyncPushResponsePatterns on SyncPushResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncPushResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncPushResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncPushResponse value)  $default,){
final _that = this;
switch (_that) {
case _SyncPushResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncPushResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SyncPushResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SyncPushResult> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncPushResponse() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SyncPushResult> results)  $default,) {final _that = this;
switch (_that) {
case _SyncPushResponse():
return $default(_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SyncPushResult> results)?  $default,) {final _that = this;
switch (_that) {
case _SyncPushResponse() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncPushResponse implements SyncPushResponse {
  const _SyncPushResponse({final  List<SyncPushResult> results = const <SyncPushResult>[]}): _results = results;
  factory _SyncPushResponse.fromJson(Map<String, dynamic> json) => _$SyncPushResponseFromJson(json);

 final  List<SyncPushResult> _results;
@override@JsonKey() List<SyncPushResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SyncPushResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncPushResponseCopyWith<_SyncPushResponse> get copyWith => __$SyncPushResponseCopyWithImpl<_SyncPushResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncPushResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncPushResponse&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SyncPushResponse(results: $results)';
}


}

/// @nodoc
abstract mixin class _$SyncPushResponseCopyWith<$Res> implements $SyncPushResponseCopyWith<$Res> {
  factory _$SyncPushResponseCopyWith(_SyncPushResponse value, $Res Function(_SyncPushResponse) _then) = __$SyncPushResponseCopyWithImpl;
@override @useResult
$Res call({
 List<SyncPushResult> results
});




}
/// @nodoc
class __$SyncPushResponseCopyWithImpl<$Res>
    implements _$SyncPushResponseCopyWith<$Res> {
  __$SyncPushResponseCopyWithImpl(this._self, this._then);

  final _SyncPushResponse _self;
  final $Res Function(_SyncPushResponse) _then;

/// Create a copy of SyncPushResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_SyncPushResponse(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SyncPushResult>,
  ));
}


}


/// @nodoc
mixin _$SyncPullResponse {

 Map<String, List<Map<String, Object?>>> get changes; Map<String, List<String>> get tombstones;@DateTimeConverter() DateTime get serverTime;/// Present when large collections are paged inside the same call.
 String? get nextCursor;
/// Create a copy of SyncPullResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncPullResponseCopyWith<SyncPullResponse> get copyWith => _$SyncPullResponseCopyWithImpl<SyncPullResponse>(this as SyncPullResponse, _$identity);

  /// Serializes this SyncPullResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncPullResponse&&const DeepCollectionEquality().equals(other.changes, changes)&&const DeepCollectionEquality().equals(other.tombstones, tombstones)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(changes),const DeepCollectionEquality().hash(tombstones),serverTime,nextCursor);

@override
String toString() {
  return 'SyncPullResponse(changes: $changes, tombstones: $tombstones, serverTime: $serverTime, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $SyncPullResponseCopyWith<$Res>  {
  factory $SyncPullResponseCopyWith(SyncPullResponse value, $Res Function(SyncPullResponse) _then) = _$SyncPullResponseCopyWithImpl;
@useResult
$Res call({
 Map<String, List<Map<String, Object?>>> changes, Map<String, List<String>> tombstones,@DateTimeConverter() DateTime serverTime, String? nextCursor
});




}
/// @nodoc
class _$SyncPullResponseCopyWithImpl<$Res>
    implements $SyncPullResponseCopyWith<$Res> {
  _$SyncPullResponseCopyWithImpl(this._self, this._then);

  final SyncPullResponse _self;
  final $Res Function(SyncPullResponse) _then;

/// Create a copy of SyncPullResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? changes = null,Object? tombstones = null,Object? serverTime = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as Map<String, List<Map<String, Object?>>>,tombstones: null == tombstones ? _self.tombstones : tombstones // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,serverTime: null == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncPullResponse].
extension SyncPullResponsePatterns on SyncPullResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncPullResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncPullResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncPullResponse value)  $default,){
final _that = this;
switch (_that) {
case _SyncPullResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncPullResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SyncPullResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, List<Map<String, Object?>>> changes,  Map<String, List<String>> tombstones, @DateTimeConverter()  DateTime serverTime,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncPullResponse() when $default != null:
return $default(_that.changes,_that.tombstones,_that.serverTime,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, List<Map<String, Object?>>> changes,  Map<String, List<String>> tombstones, @DateTimeConverter()  DateTime serverTime,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _SyncPullResponse():
return $default(_that.changes,_that.tombstones,_that.serverTime,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, List<Map<String, Object?>>> changes,  Map<String, List<String>> tombstones, @DateTimeConverter()  DateTime serverTime,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _SyncPullResponse() when $default != null:
return $default(_that.changes,_that.tombstones,_that.serverTime,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncPullResponse extends SyncPullResponse {
  const _SyncPullResponse({final  Map<String, List<Map<String, Object?>>> changes = const <String, List<Map<String, Object?>>>{}, final  Map<String, List<String>> tombstones = const <String, List<String>>{}, @DateTimeConverter() required this.serverTime, this.nextCursor}): _changes = changes,_tombstones = tombstones,super._();
  factory _SyncPullResponse.fromJson(Map<String, dynamic> json) => _$SyncPullResponseFromJson(json);

 final  Map<String, List<Map<String, Object?>>> _changes;
@override@JsonKey() Map<String, List<Map<String, Object?>>> get changes {
  if (_changes is EqualUnmodifiableMapView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_changes);
}

 final  Map<String, List<String>> _tombstones;
@override@JsonKey() Map<String, List<String>> get tombstones {
  if (_tombstones is EqualUnmodifiableMapView) return _tombstones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tombstones);
}

@override@DateTimeConverter() final  DateTime serverTime;
/// Present when large collections are paged inside the same call.
@override final  String? nextCursor;

/// Create a copy of SyncPullResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncPullResponseCopyWith<_SyncPullResponse> get copyWith => __$SyncPullResponseCopyWithImpl<_SyncPullResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncPullResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncPullResponse&&const DeepCollectionEquality().equals(other._changes, _changes)&&const DeepCollectionEquality().equals(other._tombstones, _tombstones)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_changes),const DeepCollectionEquality().hash(_tombstones),serverTime,nextCursor);

@override
String toString() {
  return 'SyncPullResponse(changes: $changes, tombstones: $tombstones, serverTime: $serverTime, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$SyncPullResponseCopyWith<$Res> implements $SyncPullResponseCopyWith<$Res> {
  factory _$SyncPullResponseCopyWith(_SyncPullResponse value, $Res Function(_SyncPullResponse) _then) = __$SyncPullResponseCopyWithImpl;
@override @useResult
$Res call({
 Map<String, List<Map<String, Object?>>> changes, Map<String, List<String>> tombstones,@DateTimeConverter() DateTime serverTime, String? nextCursor
});




}
/// @nodoc
class __$SyncPullResponseCopyWithImpl<$Res>
    implements _$SyncPullResponseCopyWith<$Res> {
  __$SyncPullResponseCopyWithImpl(this._self, this._then);

  final _SyncPullResponse _self;
  final $Res Function(_SyncPullResponse) _then;

/// Create a copy of SyncPullResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? changes = null,Object? tombstones = null,Object? serverTime = null,Object? nextCursor = freezed,}) {
  return _then(_SyncPullResponse(
changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as Map<String, List<Map<String, Object?>>>,tombstones: null == tombstones ? _self._tombstones : tombstones // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,serverTime: null == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
