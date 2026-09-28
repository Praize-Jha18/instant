import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';
import '../enums/transitions.dart';
import 'cart.dart';
import 'timeline_entry.dart';

part 'sub_order.freezed.dart';
part 'sub_order.g.dart';

/// The per-vendor part of an order (`subOrders` collection).
@freezed
abstract class SubOrder with _$SubOrder {
  const SubOrder._();

  const factory SubOrder({
    @JsonKey(readValue: readId) required String id,
    required String orderId,
    required String vendorId,
    required String customerId,
    @Default(<OrderItem>[]) List<OrderItem> items,
    @Default(0) int subtotalKobo,
    @Default(0) int deliveryFeeKobo,
    @Default(0) int commissionKobo,
    @Default(0) int vendorNetKobo,
    @Default(SubOrderStatus.awaitingPayment) SubOrderStatus status,
    String? deliveryId,
    @Default(<TimelineEntry>[]) List<TimelineEntry> timeline,
    String? orderNumber,
    String? vendorName,
    String? vendorNameSnapshot,
    String? customerName,
    /// Hand-over code the customer shows the rider (§11). Visible to customer and vendor.
    String? deliveryOtp,
    @Default(0) int refundedKobo,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _SubOrder;

  factory SubOrder.fromJson(Map<String, dynamic> json) => _$SubOrderFromJson(json);

  int get totalKobo => subtotalKobo + deliveryFeeKobo;
  int get itemCount => items.fold(0, (acc, i) => acc + i.qty);
  bool canMoveTo(SubOrderStatus next) => canTransition(status, next);
  bool get customerCancellable => customerCanCancel(status);
}
