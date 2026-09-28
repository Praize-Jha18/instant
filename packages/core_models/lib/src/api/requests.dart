import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';
import '../enums/enums.dart';
import '../models/models.dart';

part 'requests.freezed.dart';
part 'requests.g.dart';

/// `POST /auth/register`. [vendorId] is required for `rider`; [vendorName]
/// seeds the pending vendor for `vendor_owner`.
@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    required UserRole role,
    String? vendorId,
    String? vendorName,
    String? deviceId,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// `POST /auth/login`.
@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
    String? deviceId,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// `POST /auth/refresh` and `POST /auth/logout`.
@freezed
abstract class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    required String refreshToken,
    String? deviceId,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

/// `POST /orders`: creates an order from the server-side cart.
@freezed
abstract class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    required String addressId,
    String? note,
    @Default('stripe') String paymentProvider,

    /// Idempotency key so a retried checkout does not create two orders.
    String? idempotencyKey,
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}

/// `POST /vendor/products/:id/stock` and the `stock.adjust` custom sync op.
@freezed
abstract class StockAdjustRequest with _$StockAdjustRequest {
  const factory StockAdjustRequest({
    String? variantId,
    required int delta,
    @Default(InventoryReason.adjustment) InventoryReason reason,
    String? note,
  }) = _StockAdjustRequest;

  factory StockAdjustRequest.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustRequestFromJson(json);
}

/// `POST /vendor/orders/:subOrderId/status`.
@freezed
abstract class UpdateSubOrderStatusRequest with _$UpdateSubOrderStatusRequest {
  const factory UpdateSubOrderStatusRequest({
    required SubOrderStatus status,
    String? note,
  }) = _UpdateSubOrderStatusRequest;

  factory UpdateSubOrderStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSubOrderStatusRequestFromJson(json);
}

/// `POST /vendor/deliveries/:id/assign`.
@freezed
abstract class AssignDeliveryRequest with _$AssignDeliveryRequest {
  const factory AssignDeliveryRequest({required String riderId}) =
      _AssignDeliveryRequest;

  factory AssignDeliveryRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignDeliveryRequestFromJson(json);
}

/// `POST /rider/location` and the `rider.location` socket event.
@freezed
abstract class RiderLocationUpdate with _$RiderLocationUpdate {
  const factory RiderLocationUpdate({
    required double lat,
    required double lng,
    double? heading,
    double? speed,
    @DateTimeConverter() required DateTime at,
    String? deliveryId,
  }) = _RiderLocationUpdate;

  factory RiderLocationUpdate.fromJson(Map<String, dynamic> json) =>
      _$RiderLocationUpdateFromJson(json);
}

/// `PATCH /rider/profile`.
@freezed
abstract class UpdateRiderProfileRequest with _$UpdateRiderProfileRequest {
  const factory UpdateRiderProfileRequest({
    bool? isOnline,
    String? vehicleType,
    String? plateNumber,
  }) = _UpdateRiderProfileRequest;

  factory UpdateRiderProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateRiderProfileRequestFromJson(json);
}

/// `POST /rider/deliveries/:id/respond`.
@freezed
abstract class RespondDeliveryRequest with _$RespondDeliveryRequest {
  const factory RespondDeliveryRequest({required bool accept}) =
      _RespondDeliveryRequest;

  factory RespondDeliveryRequest.fromJson(Map<String, dynamic> json) =>
      _$RespondDeliveryRequestFromJson(json);
}

/// `POST /rider/deliveries/:id/deliver` (JSON form; photo goes multipart).
@freezed
abstract class DeliverRequest with _$DeliverRequest {
  const factory DeliverRequest({String? otp, String? note}) = _DeliverRequest;

  factory DeliverRequest.fromJson(Map<String, dynamic> json) =>
      _$DeliverRequestFromJson(json);
}

/// `POST /vendor/payouts`. When [amountKobo] is null the server pays out the
/// full available balance.
@freezed
abstract class RequestPayoutRequest with _$RequestPayoutRequest {
  const factory RequestPayoutRequest({int? amountKobo, String? note}) =
      _RequestPayoutRequest;

  factory RequestPayoutRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestPayoutRequestFromJson(json);
}

/// `POST /admin/payouts/:id/mark-paid`.
@freezed
abstract class MarkPayoutPaidRequest with _$MarkPayoutPaidRequest {
  const factory MarkPayoutPaidRequest({String? reference}) = _MarkPayoutPaidRequest;

  factory MarkPayoutPaidRequest.fromJson(Map<String, dynamic> json) =>
      _$MarkPayoutPaidRequestFromJson(json);
}

/// Body for creating/updating a product (`/vendor/products`). Null fields are
/// omitted so the same shape works for PATCH.
@freezed
abstract class ProductInput with _$ProductInput {
  const factory ProductInput({
    String? name,
    String? description,
    List<String>? categoryIds,
    int? basePriceKobo,
    List<ProductVariant>? variants,
    bool? hasVariants,
    int? stock,
    ProductStatus? status,
    List<String>? tags,
    List<ProductImage>? images,
  }) = _ProductInput;

  factory ProductInput.fromJson(Map<String, dynamic> json) =>
      _$ProductInputFromJson(json);
}

/// Body for creating/updating an address (`/me/addresses`).
@freezed
abstract class AddressInput with _$AddressInput {
  const factory AddressInput({
    String? id,
    String? label,
    String? line1,
    String? line2,
    String? city,
    String? state,
    double? lat,
    double? lng,
    String? phone,
    bool? isDefault,
  }) = _AddressInput;

  factory AddressInput.fromJson(Map<String, dynamic> json) =>
      _$AddressInputFromJson(json);
}

/// Body for `PATCH /vendor` and `PATCH /admin/vendors/:id`.
@freezed
abstract class VendorInput with _$VendorInput {
  const factory VendorInput({
    String? name,
    String? description,
    String? logoImageId,
    String? coverImageId,
    VendorAddress? address,
    DeliveryFeeConfig? deliveryFee,
    double? deliveryRadiusKm,
    List<OpeningHours>? openingHours,
    int? commissionBps,
    PayoutAccount? payout,
    VendorStatus? status,
  }) = _VendorInput;

  factory VendorInput.fromJson(Map<String, dynamic> json) => _$VendorInputFromJson(json);
}

/// Body for `/admin/categories`.
@freezed
abstract class CategoryInput with _$CategoryInput {
  const factory CategoryInput({
    String? name,
    String? slug,
    String? parentId,
    int? sortOrder,
    String? imageId,
  }) = _CategoryInput;

  factory CategoryInput.fromJson(Map<String, dynamic> json) =>
      _$CategoryInputFromJson(json);
}

/// Body for `PUT /me/cart` (full replace).
@freezed
abstract class CartInput with _$CartInput {
  const factory CartInput({
    @Default(<CartItem>[]) List<CartItem> items,
    @NullableDateTimeConverter() DateTime? updatedAt,
  }) = _CartInput;

  factory CartInput.fromJson(Map<String, dynamic> json) => _$CartInputFromJson(json);
}

/// One revenue window of `GET /admin/stats`.
@freezed
abstract class RevenueWindow with _$RevenueWindow {
  const factory RevenueWindow({
    @Default(0) int revenueKobo,
    @Default(0) int orders,
    @Default(0) int commissionKobo,
  }) = _RevenueWindow;

  factory RevenueWindow.fromJson(Map<String, dynamic> json) =>
      _$RevenueWindowFromJson(json);
}

/// Counts block of `GET /admin/stats`. [vendors] is keyed by VendorStatus json value.
@freezed
abstract class AdminCounts with _$AdminCounts {
  const AdminCounts._();

  const factory AdminCounts({
    @Default(0) int users,
    @Default(0) int customers,
    @Default(0) int riders,
    @Default(<String, int>{}) Map<String, int> vendors,
    @Default(0) int products,
    @Default(0) int activeProducts,
    @Default(0) int orders,
    @Default(0) int paidOrders,
    @Default(0) int openSubOrders,
  }) = _AdminCounts;

  factory AdminCounts.fromJson(Map<String, dynamic> json) =>
      _$AdminCountsFromJson(json);

  int get totalVendors => vendors.values.fold(0, (a, b) => a + b);
  int get pendingVendors => vendors['pending'] ?? 0;
}

/// Revenue block of `GET /admin/stats`.
@freezed
abstract class AdminRevenue with _$AdminRevenue {
  const factory AdminRevenue({
    @Default(RevenueWindow()) RevenueWindow today,
    @Default(RevenueWindow()) RevenueWindow last7d,
    @Default(RevenueWindow()) RevenueWindow last30d,
  }) = _AdminRevenue;

  factory AdminRevenue.fromJson(Map<String, dynamic> json) =>
      _$AdminRevenueFromJson(json);
}

/// Response of `GET /admin/stats`: `{ counts, revenue, generatedAt }`.
@freezed
abstract class AdminStats with _$AdminStats {
  const factory AdminStats({
    @Default(AdminCounts()) AdminCounts counts,
    @Default(AdminRevenue()) AdminRevenue revenue,
    @NullableDateTimeConverter() DateTime? generatedAt,
  }) = _AdminStats;

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);
}

/// Standard backend error body: `{ statusCode, code, message, details? }`.
@freezed
abstract class ApiErrorBody with _$ApiErrorBody {
  const factory ApiErrorBody({
    required int statusCode,
    @Default('UNKNOWN') String code,
    @Default('') String message,
    Object? details,
  }) = _ApiErrorBody;

  factory ApiErrorBody.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorBodyFromJson(json);
}

/// Response of image upload endpoints.
@freezed
abstract class UploadedImage with _$UploadedImage {
  const factory UploadedImage({
    @JsonKey(readValue: readId) required String id,
    String? contentType,
    int? size,
    int? width,
    int? height,
  }) = _UploadedImage;

  factory UploadedImage.fromJson(Map<String, dynamic> json) =>
      _$UploadedImageFromJson(json);
}
