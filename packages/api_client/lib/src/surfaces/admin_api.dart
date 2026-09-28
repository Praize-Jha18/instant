import 'package:core_models/core_models.dart';

import 'base_api.dart';

/// Admin routes (§5), role `admin`.
class AdminApi extends BaseApi {
  const AdminApi(super.client);

  /// `GET /admin/vendors?status=&q=&cursor=`.
  Future<Paginated<Vendor>> vendors({VendorStatus? status, String? q, String? cursor, int? limit}) async =>
      asPage(
        await client.get('/admin/vendors', query: {'status': status, 'q': q, 'cursor': cursor, 'limit': limit}),
        Vendor.fromJson,
      );

  /// `PATCH /admin/vendors/:id`.
  Future<Vendor> updateVendor(String id, VendorInput input) async =>
      Vendor.fromJson(unwrap(await client.patch('/admin/vendors/$id', data: input.toJson())));

  /// `POST /admin/vendors/:id/approve`.
  Future<Vendor> approveVendor(String id) async =>
      Vendor.fromJson(unwrap(await client.post('/admin/vendors/$id/approve')));

  /// `POST /admin/vendors/:id/suspend`.
  Future<Vendor> suspendVendor(String id) async =>
      Vendor.fromJson(unwrap(await client.post('/admin/vendors/$id/suspend')));

  /// `GET /admin/orders?cursor=`.
  Future<Paginated<Order>> orders({String? cursor, int? limit, PaymentStatus? paymentStatus}) async =>
      asPage(
        await client.get('/admin/orders', query: {'cursor': cursor, 'limit': limit, 'paymentStatus': paymentStatus}),
        Order.fromJson,
      );

  /// `GET /admin/users?q=&role=&cursor=`.
  Future<Paginated<User>> users({String? q, UserRole? role, String? cursor, int? limit}) async =>
      asPage(
        await client.get('/admin/users', query: {'q': q, 'role': role, 'cursor': cursor, 'limit': limit}),
        User.fromJson,
      );

  /// `GET /admin/payouts?status=&cursor=`.
  Future<Paginated<Payout>> payouts({PayoutStatus? status, String? cursor, int? limit}) async =>
      asPage(
        await client.get('/admin/payouts', query: {'status': status, 'cursor': cursor, 'limit': limit}),
        Payout.fromJson,
      );

  /// `POST /admin/payouts/:id/mark-paid { reference? }`.
  Future<Payout> markPayoutPaid(String id, {String? reference}) async =>
      Payout.fromJson(unwrap(await client.post(
        '/admin/payouts/$id/mark-paid',
        data: MarkPayoutPaidRequest(reference: reference).toJson(),
      )));

  /// `GET /admin/categories`.
  Future<List<Category>> categories() async =>
      asList(await client.get('/admin/categories'), Category.fromJson);

  /// `POST /admin/categories`.
  Future<Category> createCategory(CategoryInput input) async =>
      Category.fromJson(unwrap(await client.post('/admin/categories', data: input.toJson())));

  /// `PATCH /admin/categories/:id`.
  Future<Category> updateCategory(String id, CategoryInput input) async =>
      Category.fromJson(unwrap(await client.patch('/admin/categories/$id', data: input.toJson())));

  /// `DELETE /admin/categories/:id`.
  Future<void> deleteCategory(String id) => client.delete('/admin/categories/$id');

  /// `GET /admin/stats`.
  Future<AdminStats> stats() async {
    return AdminStats.fromJson(unwrap(await client.get('/admin/stats')));
  }
}
