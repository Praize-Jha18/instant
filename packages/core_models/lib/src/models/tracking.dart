import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/enums.dart';
import 'rider.dart';

part 'tracking.freezed.dart';
part 'tracking.g.dart';

/// Tracking for one SubOrder inside `GET /orders/:id/tracking`.
@freezed
abstract class SubOrderTracking with _$SubOrderTracking {
  const factory SubOrderTracking({
    required String subOrderId,
    required String vendorId,
    String? vendorName,
    required SubOrderStatus status,
    String? deliveryId,
    DeliveryStatus? deliveryStatus,
    String? riderId,
    String? riderName,
    String? riderPhone,
    RiderLocation? riderLocation,
  }) = _SubOrderTracking;

  factory SubOrderTracking.fromJson(Map<String, dynamic> json) =>
      _$SubOrderTrackingFromJson(json);
}

/// Response of `GET /orders/:id/tracking`.
@freezed
abstract class OrderTracking with _$OrderTracking {
  const factory OrderTracking({
    required String orderId,
    @Default(<SubOrderTracking>[]) List<SubOrderTracking> subOrders,
  }) = _OrderTracking;

  factory OrderTracking.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingFromJson(json);
}
