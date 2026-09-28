import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';
import '../../../core/vendor_codec.dart';

/// Typed view over `AdminStats` used by the dashboard widgets.
@immutable
class AdminStatsView {
  const AdminStatsView({
    required this.users,
    required this.customers,
    required this.riders,
    required this.vendorsByStatus,
    required this.products,
    required this.activeProducts,
    required this.orders,
    required this.paidOrders,
    required this.openSubOrders,
    required this.today,
    required this.last7d,
    required this.last30d,
    this.generatedAt,
  });

  factory AdminStatsView.fromStats(AdminStats s) {
    final c = s.counts;
    return AdminStatsView(
      users: c.users,
      customers: c.customers,
      riders: c.riders,
      vendorsByStatus: c.vendors,
      products: c.products,
      activeProducts: c.activeProducts,
      orders: c.orders,
      paidOrders: c.paidOrders,
      openSubOrders: c.openSubOrders,
      today: s.revenue.today,
      last7d: s.revenue.last7d,
      last30d: s.revenue.last30d,
      generatedAt: s.generatedAt,
    );
  }

  final int users;
  final int customers;
  final int riders;
  final Map<String, int> vendorsByStatus;
  final int products;
  final int activeProducts;
  final int orders;
  final int paidOrders;
  final int openSubOrders;
  final RevenueWindow today;
  final RevenueWindow last7d;
  final RevenueWindow last30d;
  final DateTime? generatedAt;

  int get totalVendors => vendorsByStatus.values.fold(0, (a, b) => a + b);
}

/// Admin routes. Vendor-returning calls go through raw requests so the
/// backend's opening-hours shape can be normalised (see `VendorJson`).
class AdminRepository {
  AdminRepository(this._api, this._store);

  final ApiClient _api;
  final LocalStore _store;

  Future<AdminStatsView> stats() async => AdminStatsView.fromStats(await _api.admin.stats());

  Future<List<Vendor>> refreshVendors({VendorStatus? status, String? q}) async {
    final body = await _api.get('/admin/vendors', query: {'status': status, 'q': q, 'limit': 200});
    final raw = body is Map ? body['items'] : body;
    final vendors = <Vendor>[
      if (raw is List)
        for (final e in raw)
          if (e is Map) VendorJson.decode(e),
    ];
    await _store.upsertAll(Collections.vendors, vendors);
    return vendors;
  }

  Future<Vendor> approveVendor(String id) async {
    final v = VendorJson.decode(await _api.post('/admin/vendors/$id/approve'));
    await _store.upsert(Collections.vendors, v);
    return v;
  }

  Future<Vendor> suspendVendor(String id) async {
    final v = VendorJson.decode(await _api.post('/admin/vendors/$id/suspend'));
    await _store.upsert(Collections.vendors, v);
    return v;
  }

  Future<Vendor> updateVendor(String id, VendorInput input) async {
    final v = VendorJson.decode(await _api.patch('/admin/vendors/$id', data: VendorJson.patchBody(input)));
    await _store.upsert(Collections.vendors, v);
    return v;
  }

  Future<List<Order>> refreshOrders({PaymentStatus? paymentStatus}) async {
    final page = await _api.admin.orders(paymentStatus: paymentStatus, limit: 200);
    await _store.upsertAll(Collections.orders, page.items);
    return page.items;
  }

  Future<Paginated<User>> users({String? q, UserRole? role, String? cursor}) =>
      _api.admin.users(q: q, role: role, cursor: cursor, limit: 50);

  Future<List<Payout>> refreshPayouts({PayoutStatus? status}) async {
    final page = await _api.admin.payouts(status: status, limit: 200);
    await _store.upsertAll(Collections.payouts, page.items);
    return page.items;
  }

  Future<Payout> markPayoutPaid(String id, {String? reference}) async {
    final p = await _api.admin.markPayoutPaid(id, reference: reference);
    await _store.upsert(Collections.payouts, p);
    return p;
  }

  Future<List<Category>> refreshCategories() async {
    final list = await _api.admin.categories();
    await _store.upsertAll(Collections.categories, list);
    return list;
  }

  Future<Category> createCategory(CategoryInput input) async {
    final c = await _api.admin.createCategory(input);
    await _store.upsert(Collections.categories, c);
    return c;
  }

  Future<Category> updateCategory(String id, CategoryInput input) async {
    final c = await _api.admin.updateCategory(id, input);
    await _store.upsert(Collections.categories, c);
    return c;
  }

  Future<void> deleteCategory(String id) async {
    await _api.admin.deleteCategory(id);
    await _store.delete(Collections.categories, id);
  }
}

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepository(ref.watch(apiClientProvider), ref.watch(localStoreProvider)),
);

final adminStatsProvider = FutureProvider.autoDispose<AdminStatsView>((ref) => ref.watch(adminRepositoryProvider).stats());
