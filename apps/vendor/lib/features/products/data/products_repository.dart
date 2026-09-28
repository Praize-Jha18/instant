import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';
import '../domain/product_draft.dart';

/// Product catalogue actions.
///
/// - Text edits (name, description, tags) are offline-safe through the outbox
///   (`products.upsert`, last-write-wins by `clientAt`).
/// - Creation, price/variant/status/category changes and images are online
///   only (server-authoritative), so they call REST directly.
/// - Stock changes are deltas via the `stock.adjust` custom op so they replay
///   safely and work offline.
class ProductsRepository {
  ProductsRepository(this._api, this._store, this._engine);

  final ApiClient _api;
  final LocalStore _store;
  final SyncEngine? _engine;

  Future<Product> create(ProductInput input) async {
    final p = _decodeProduct(await _api.post('/vendor/products', data: productInputBody(input)));
    await _store.upsert(Collections.products, p);
    return p;
  }

  Future<Product> updateOnline(String id, ProductInput input) async {
    final p = _decodeProduct(await _api.patch('/vendor/products/$id', data: productInputBody(input)));
    await _store.upsert(Collections.products, p);
    return p;
  }

  /// `ProductInput.toJson()` with empty variant ids removed. `ProductVariant.id`
  /// is a required String in core_models, so new variants serialise as
  /// `id: ''`, which the backend's `@IsMongoId()` check rejects.
  static Map<String, Object?> productInputBody(ProductInput input) {
    final body = Map<String, Object?>.from(input.toJson());
    final variants = body['variants'];
    if (variants is List) {
      body['variants'] = [
        for (final v in variants)
          if (v is Map) (Map<String, Object?>.from(v)..removeWhere((k, val) => k == 'id' && (val == null || val == ''))),
      ];
    }
    return body;
  }

  static Product _decodeProduct(Object? body) {
    final map = body is Map<String, dynamic> ? body : Map<String, dynamic>.from(body as Map);
    final data = map['data'];
    return Product.fromJson(map.length == 1 && data is Map ? Map<String, dynamic>.from(data) : map);
  }

  /// Applies the draft locally and queues an upsert. Works offline.
  Future<Product> updateOffline(Product original, ProductDraft draft) async {
    final updated = draft.applyTo(original);
    final engine = _engine;
    if (engine == null) {
      await _store.upsert(Collections.products, updated);
    } else {
      await engine.enqueueUpsert(Collections.products, updated);
    }
    return updated;
  }

  Future<void> delete(String id) async {
    await _api.vendor.deleteProduct(id);
    await _store.delete(Collections.products, id);
  }

  /// Queues a `stock.adjust` delta and applies it optimistically to the
  /// local copy so the list reflects it immediately.
  Future<void> adjustStock(
    Product product, {
    String? variantId,
    required int delta,
    required InventoryReason reason,
    String? note,
  }) async {
    final trimmedNote = (note ?? '').trim();
    final payload = <String, Object?>{
      // The backend resolves custom ops by `payload.name`; `customAction` is
      // sent too via SyncOp.toJson for forward compatibility.
      'name': 'stock.adjust',
      'productId': product.id,
      'variantId': ?variantId,
      'delta': delta,
      'reason': reason.json,
      if (trimmedNote.isNotEmpty) 'note': trimmedNote,
    };
    final engine = _engine;
    if (engine != null) {
      await engine.enqueueCustom(Collections.products, 'stock.adjust', payload);
    } else {
      await _api.vendor.adjustStock(
        product.id,
        StockAdjustRequest(variantId: variantId, delta: delta, reason: reason, note: note),
      );
    }
    final optimistic = variantId == null
        ? product.copyWith(stock: (product.stock + delta).clamp(0, 1 << 31))
        : product.copyWith(
            variants: [
              for (final v in product.variants)
                if (v.id == variantId) v.copyWith(stock: (v.stock + delta).clamp(0, 1 << 31)) else v,
            ],
          );
    await _store.upsert(Collections.products, optimistic);
  }

  Future<Product> uploadImage(
    String productId, {
    required List<int> bytes,
    required String filename,
    required String contentType,
    int? sortOrder,
    void Function(int sent, int total)? onProgress,
  }) async {
    final p = await _api.vendor.uploadProductImage(
      productId,
      bytes: bytes,
      filename: filename,
      contentType: contentType,
      sortOrder: sortOrder,
      onProgress: onProgress,
    );
    await _store.upsert(Collections.products, p);
    return p;
  }

  Future<Product> deleteImage(String productId, String imageId) async {
    final p = await _api.vendor.deleteProductImage(productId, imageId);
    await _store.upsert(Collections.products, p);
    return p;
  }

  /// Persists a new image order. The contract's `ProductInput.images` carries
  /// it; the current backend ignores the field, so the local copy is updated
  /// too and the order is at least stable in this app.
  Future<Product> reorderImages(Product product, List<ProductImage> images) async {
    final ordered = [for (var i = 0; i < images.length; i++) images[i].copyWith(sortOrder: i)];
    Product updated = product.copyWith(images: ordered);
    try {
      final fromServer = await _api.vendor.updateProduct(product.id, ProductInput(images: ordered));
      final serverOrder = {for (final img in fromServer.images) img.imageId: img.sortOrder};
      final persisted = ordered.every((img) => serverOrder[img.imageId] == img.sortOrder);
      updated = persisted ? fromServer : fromServer.copyWith(images: ordered);
    } catch (_) {
      // Keep the local order.
    }
    await _store.upsert(Collections.products, updated);
    return updated;
  }

  Future<void> refreshMovements(String productId) async {
    final page = await _api.vendor.inventoryMovements(productId: productId, limit: 100);
    await _store.upsertAll(Collections.inventoryMovements, page.items);
  }
}

final productsRepositoryProvider = Provider<ProductsRepository>(
  (ref) => ProductsRepository(ref.watch(apiClientProvider), ref.watch(localStoreProvider), ref.watch(syncEngineProvider)),
);
