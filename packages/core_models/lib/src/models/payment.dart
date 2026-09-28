import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// Client-safe view of a payment (`payments` collection without rawEvents or
/// idempotencyKey).
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    @JsonKey(readValue: readId) required String id,
    required String orderId,
    @Default('stripe') String provider,
    String? providerRef,
    required int amountKobo,
    @Default('NGN') String currency,
    @Default(PaymentStatus.pending) PaymentStatus status,
    String? clientSecret,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}
