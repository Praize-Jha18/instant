import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../catalog/data/catalog_providers.dart';
import '../domain/product_filter.dart';

class SearchState {
  const SearchState({
    this.query = '',
    this.categoryId,
    this.results = const [],
    this.loading = false,
    this.fromLocal = true,
    this.searched = false,
  });

  final String query;
  final String? categoryId;
  final List<Product> results;
  final bool loading;

  /// True when [results] came from the local store (offline or fallback).
  final bool fromLocal;

  /// False until the first query/category has been applied.
  final bool searched;

  bool get hasFilter => query.trim().isNotEmpty || categoryId != null;

  SearchState copyWith({
    String? query,
    String? categoryId,
    bool clearCategory = false,
    List<Product>? results,
    bool? loading,
    bool? fromLocal,
    bool? searched,
  }) =>
      SearchState(
        query: query ?? this.query,
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        results: results ?? this.results,
        loading: loading ?? this.loading,
        fromLocal: fromLocal ?? this.fromLocal,
        searched: searched ?? this.searched,
      );
}

/// Debounced product search: `GET /products?q=` online (results are cached in
/// the store), local filtering offline or when the request fails.
class ProductSearchNotifier extends Notifier<SearchState> {
  static const Duration debounce = Duration(milliseconds: 350);
  Timer? _timer;
  int _generation = 0;

  @override
  SearchState build() {
    ref.onDispose(() => _timer?.cancel());
    // Re-run local filtering when the store changes (e.g. a pull completes).
    ref.listen(productsProvider, (_, _) {
      if (state.hasFilter && state.fromLocal) _runLocal();
    });
    return const SearchState();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query, loading: query.trim().isNotEmpty || state.categoryId != null);
    _timer?.cancel();
    _timer = Timer(debounce, run);
  }

  void setCategory(String? categoryId) {
    state = categoryId == null ? state.copyWith(clearCategory: true) : state.copyWith(categoryId: categoryId);
    _timer?.cancel();
    run();
  }

  void clear() {
    _timer?.cancel();
    _generation++;
    state = const SearchState();
  }

  Future<void> run() async {
    final gen = ++_generation;
    if (!state.hasFilter) {
      state = state.copyWith(results: const [], loading: false, searched: false);
      return;
    }
    state = state.copyWith(loading: true, searched: true);
    if (!ref.read(isOnlineProvider)) {
      _runLocal();
      return;
    }
    try {
      final catalog = ref.read(apiClientProvider).catalog;
      final page = await catalog.products(
        q: state.query.trim().isEmpty ? null : state.query.trim(),
        categoryId: state.categoryId,
        limit: 50,
      );
      if (gen != _generation) return;
      final items = page.items.where((p) => p.status == ProductStatus.active).toList();
      // Network only fills the store; keep it warm for offline.
      unawaited(ref.read(localStoreProvider).upsertAll(Collections.products, items));
      state = state.copyWith(results: items, loading: false, fromLocal: false);
    } catch (_) {
      if (gen != _generation) return;
      _runLocal();
    }
  }

  void _runLocal() {
    final all = ref.read(productsProvider).value ?? const <Product>[];
    state = state.copyWith(
      results: filterProducts(all, query: state.query, categoryId: state.categoryId),
      loading: false,
      fromLocal: true,
    );
  }
}

final productSearchProvider = NotifierProvider<ProductSearchNotifier, SearchState>(ProductSearchNotifier.new);
