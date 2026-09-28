import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

/// Active vendors from the local store.
final vendorsProvider = StreamProvider<List<Vendor>>((ref) {
  final store = ref.watch(localStoreProvider);
  return store.watchAll<Vendor>(
    Collections.vendors,
    filter: (v) => v.isActive && v.deletedAt == null,
    sortBy: (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
  );
});

final vendorsByIdProvider = Provider<Map<String, Vendor>>((ref) {
  final list = ref.watch(vendorsProvider).value ?? const [];
  return {for (final v in list) v.id: v};
});

final vendorProvider = StreamProvider.family<Vendor?, String>((ref, id) {
  final store = ref.watch(localStoreProvider);
  return store.watchById<Vendor>(Collections.vendors, id);
});

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final store = ref.watch(localStoreProvider);
  return store.watchAll<Category>(
    Collections.categories,
    filter: (c) => c.deletedAt == null,
    sortBy: (a, b) {
      final byOrder = a.sortOrder.compareTo(b.sortOrder);
      return byOrder != 0 ? byOrder : a.name.compareTo(b.name);
    },
  );
});

final categoriesByIdProvider = Provider<Map<String, Category>>((ref) {
  final list = ref.watch(categoriesProvider).value ?? const [];
  return {for (final c in list) c.id: c};
});

/// Active products from the local store.
final productsProvider = StreamProvider<List<Product>>((ref) {
  final store = ref.watch(localStoreProvider);
  return store.watchAll<Product>(
    Collections.products,
    filter: (p) => p.status == ProductStatus.active && p.deletedAt == null,
    sortBy: (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
  );
});

final productProvider = StreamProvider.family<Product?, String>((ref, id) {
  final store = ref.watch(localStoreProvider);
  return store.watchById<Product>(Collections.products, id);
});

/// Products of one vendor.
final vendorProductsProvider = Provider.family<List<Product>, String>((ref, vendorId) {
  final all = ref.watch(productsProvider).value ?? const [];
  return all.where((p) => p.vendorId == vendorId).toList();
});

/// Highest rated products first, then most reviewed; used on Home.
final featuredProductsProvider = Provider<List<Product>>((ref) {
  final all = [...(ref.watch(productsProvider).value ?? const <Product>[])];
  all.sort((a, b) {
    final byAvg = b.rating.avg.compareTo(a.rating.avg);
    if (byAvg != 0) return byAvg;
    final byCount = b.rating.count.compareTo(a.rating.count);
    if (byCount != 0) return byCount;
    return (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0));
  });
  return all.take(12).toList();
});
