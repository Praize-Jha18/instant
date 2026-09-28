import 'package:core_models/core_models.dart';
import 'package:dio/dio.dart' show ProgressCallback;

import 'base_api.dart';

/// Vendor routes (§5), scoped server-side to the caller's vendorId.
class VendorApi extends BaseApi {
  const VendorApi(super.client);

  // Profile

  /// `GET /vendor`.
  Future<Vendor> profile() async => Vendor.fromJson(unwrap(await client.get('/vendor')));

  /// `PATCH /vendor`.
  Future<Vendor> updateProfile(VendorInput input) async =>
      Vendor.fromJson(unwrap(await client.patch('/vendor', data: input.toJson())));

  // Products

  /// `GET /vendor/products?status=&q=&cursor=` (all statuses, own vendor).
  Future<Paginated<Product>> products({
    ProductStatus? status,
    String? q,
    String? cursor,
    int? limit,
  }) async =>
      asPage(
        await client.get('/vendor/products', query: {
          'status': status,
          'q': q,
          'cursor': cursor,
          'limit': limit,
        }),
        Product.fromJson,
      );

  /// `GET /vendor/products/:id`.
  Future<Product> product(String id) async =>
      Product.fromJson(unwrap(await client.get('/vendor/products/$id')));

  /// `POST /vendor/products`.
  Future<Product> createProduct(ProductInput input) async =>
      Product.fromJson(unwrap(await client.post('/vendor/products', data: input.toJson())));

  /// `PATCH /vendor/products/:id`.
  Future<Product> updateProduct(String id, ProductInput input) async =>
      Product.fromJson(unwrap(await client.patch('/vendor/products/$id', data: input.toJson())));

  /// `DELETE /vendor/products/:id` (soft delete).
  Future<void> deleteProduct(String id) => client.delete('/vendor/products/$id');

  /// `POST /vendor/logo` or `/vendor/cover` (multipart). Returns the updated vendor.
  Future<Vendor> uploadVendorImage({
    required String kind, // 'logo' | 'cover'
    required List<int> bytes,
    required String filename,
    String? contentType,
    ProgressCallback? onProgress,
  }) async {
    final body = await client.upload(
      '/vendor/$kind',
      bytes: bytes,
      filename: filename,
      contentType: contentType,
      onProgress: onProgress,
    );
    return Vendor.fromJson(unwrap(body));
  }

  /// `POST /vendor/products/:id/images` (multipart, field `file`, ≤ 2 MB).
  /// Returns the updated product.
  Future<Product> uploadProductImage(
    String productId, {
    required List<int> bytes,
    required String filename,
    String contentType = 'image/jpeg',
    int? sortOrder,
    void Function(int sent, int total)? onProgress,
  }) async {
    final body = await client.upload(
      '/vendor/products/$productId/images',
      bytes: bytes,
      filename: filename,
      contentType: contentType,
      fields: {'sortOrder': ?sortOrder},
      onProgress: onProgress,
    );
    return Product.fromJson(unwrap(body));
  }

  /// `DELETE /vendor/products/:id/images/:imageId`. Returns the updated product.
  Future<Product> deleteProductImage(String productId, String imageId) async =>
      Product.fromJson(unwrap(await client.delete('/vendor/products/$productId/images/$imageId')));

  // Stock

  /// `POST /vendor/products/:id/stock { variantId?, delta, reason, note }`.
  /// Deltas only; the server owns absolute stock.
  Future<Product> adjustStock(String productId, StockAdjustRequest request) async =>
      Product.fromJson(unwrap(await client.post('/vendor/products/$productId/stock', data: request.toJson())));

  /// `GET /vendor/inventory/movements?productId=&cursor=`.
  Future<Paginated<InventoryMovement>> inventoryMovements({
    String? productId,
    String? cursor,
    int? limit,
  }) async =>
      asPage(
        await client.get('/vendor/inventory/movements', query: {
          'productId': productId,
          'cursor': cursor,
          'limit': limit,
        }),
        InventoryMovement.fromJson,
      );

  // Orders

  /// `GET /vendor/orders?status=&cursor=` — own subOrders (never awaiting_payment).
  Future<Paginated<SubOrder>> orders({SubOrderStatus? status, String? cursor, int? limit}) async =>
      asPage(
        await client.get('/vendor/orders', query: {'status': status, 'cursor': cursor, 'limit': limit}),
        SubOrder.fromJson,
      );

  /// `POST /vendor/orders/:subOrderId/status { status }` following §6.
  Future<SubOrder> updateOrderStatus(String subOrderId, SubOrderStatus status, {String? note}) async =>
      SubOrder.fromJson(unwrap(await client.post(
        '/vendor/orders/$subOrderId/status',
        data: UpdateSubOrderStatusRequest(status: status, note: note).toJson(),
      )));

  // Riders

  /// `GET /vendor/riders?status=`.
  Future<List<RiderProfile>> riders({RiderStatus? status}) async =>
      asList(await client.get('/vendor/riders', query: {'status': status}), RiderProfile.fromJson);

  /// `POST /vendor/riders/:id/approve`.
  Future<RiderProfile> approveRider(String riderProfileId) async =>
      RiderProfile.fromJson(unwrap(await client.post('/vendor/riders/$riderProfileId/approve')));

  /// `POST /vendor/riders/:id/suspend`.
  Future<RiderProfile> suspendRider(String riderProfileId) async =>
      RiderProfile.fromJson(unwrap(await client.post('/vendor/riders/$riderProfileId/suspend')));

  // Deliveries

  /// `GET /vendor/deliveries?status=&cursor=`.
  Future<Paginated<Delivery>> deliveries({DeliveryStatus? status, String? cursor, int? limit}) async =>
      asPage(
        await client.get('/vendor/deliveries', query: {'status': status, 'cursor': cursor, 'limit': limit}),
        Delivery.fromJson,
      );

  /// `POST /vendor/deliveries/:id/assign { riderId }` — manual assignment.
  Future<Delivery> assignDelivery(String deliveryId, String riderId) async =>
      Delivery.fromJson(unwrap(await client.post(
        '/vendor/deliveries/$deliveryId/assign',
        data: AssignDeliveryRequest(riderId: riderId).toJson(),
      )));

  /// `POST /vendor/deliveries/:id/auto-assign` — nearest online rider.
  Future<Delivery> autoAssignDelivery(String deliveryId) async =>
      Delivery.fromJson(unwrap(await client.post('/vendor/deliveries/$deliveryId/auto-assign')));

  // Money

  /// `GET /vendor/ledger?cursor=`.
  Future<Paginated<VendorLedgerEntry>> ledger({String? cursor, int? limit}) async =>
      asPage(await client.get('/vendor/ledger', query: {'cursor': cursor, 'limit': limit}),
          VendorLedgerEntry.fromJson);

  /// `GET /vendor/payouts?cursor=`.
  Future<Paginated<Payout>> payouts({String? cursor, int? limit}) async =>
      asPage(await client.get('/vendor/payouts', query: {'cursor': cursor, 'limit': limit}), Payout.fromJson);

  /// `POST /vendor/payouts` — request a payout.
  Future<Payout> requestPayout([RequestPayoutRequest request = const RequestPayoutRequest()]) async =>
      Payout.fromJson(unwrap(await client.post('/vendor/payouts', data: request.toJson())));
}
