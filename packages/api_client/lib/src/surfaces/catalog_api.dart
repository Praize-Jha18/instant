import 'package:core_models/core_models.dart';

import 'base_api.dart';

/// Public catalogue routes (§5). No token required.
class CatalogApi extends BaseApi {
  const CatalogApi(super.client);

  /// `GET /vendors?near=lat,lng&q=&cursor=` — active vendors.
  Future<Paginated<Vendor>> vendors({
    double? lat,
    double? lng,
    String? q,
    String? cursor,
    int? limit,
  }) async {
    final body = await client.get('/vendors', query: {
      if (lat != null && lng != null) 'near': '$lat,$lng',
      'q': q,
      'cursor': cursor,
      'limit': limit,
    }, auth: false);
    return asPage(body, Vendor.fromJson);
  }

  /// `GET /vendors/:slug`.
  Future<Vendor> vendorBySlug(String slug) async =>
      Vendor.fromJson(unwrap(await client.get('/vendors/$slug', auth: false)));

  /// `GET /categories`.
  Future<List<Category>> categories() async =>
      asList(await client.get('/categories', auth: false), Category.fromJson);

  /// `GET /products?vendorId=&categoryId=&q=&cursor=` — active products.
  Future<Paginated<Product>> products({
    String? vendorId,
    String? categoryId,
    String? q,
    String? cursor,
    int? limit,
  }) async {
    final body = await client.get('/products', query: {
      'vendorId': vendorId,
      'categoryId': categoryId,
      'q': q,
      'cursor': cursor,
      'limit': limit,
    }, auth: false);
    return asPage(body, Product.fromJson);
  }

  /// `GET /products/:id`.
  Future<Product> product(String id) async =>
      Product.fromJson(unwrap(await client.get('/products/$id', auth: false)));

  /// Absolute URL of `GET /images/:id[?size=thumb]`.
  String imageUrl(String imageId, {bool thumb = false}) =>
      client.absoluteUrl('/images/$imageId${thumb ? '?size=thumb' : ''}');
}
