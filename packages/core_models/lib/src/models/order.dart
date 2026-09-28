import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';
import 'address.dart';
import 'sub_order.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// A customer order spanning one or more vendors (`orders` collection).
@freezed
abstract class Order with _$Order {
  const Order._();

  const factory Order({
    @JsonKey(readValue: readId) required String id,
    required String customerId,
    required String orderNumber,
    @Default(<String>[]) List<String> subOrderIds,
    AddressSnapshot? addressSnapshot,
    @Default(0) int subtotalKobo,
    @Default(0) int deliveryTotalKobo,
    @Default(0) int totalKobo,
    @Default('NGN') String currency,
    @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    String? paymentId,
    @NullableDateTimeConverter() DateTime? placedAt,
    @NullableDateTimeConverter() DateTime? expiresAt,

    /// Populated by some endpoints (`GET /orders/:id`); otherwise empty.
    @Default(<SubOrder>[]) List<SubOrder> subOrders,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  bool get isPaid => paymentStatus == PaymentStatus.paid;
  bool get awaitingPayment => paymentStatus == PaymentStatus.pending;
}

/// Response of `POST /orders`: the created order plus what the client needs to
/// complete payment with the provider (Stripe PaymentIntent client secret).
@freezed
abstract class CheckoutPayload with _$CheckoutPayload {
  const factory CheckoutPayload({
    required Order order,
    @Default(<SubOrder>[]) List<SubOrder> subOrders,
    String? paymentId,
    String? clientSecret,
    String? providerRef,
    @Default('stripe') String provider,
    String? publishableKey,
  }) = _CheckoutPayload;

  factory CheckoutPayload.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPayloadFromJson(json);
}
