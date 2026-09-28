import 'package:core_models/core_models.dart';

/// Offline search: case-insensitive match on name, description and tags,
/// every whitespace-separated term must match; optional category filter.
List<Product> filterProducts(Iterable<Product> products, {String query = '', String? categoryId}) {
  final terms = query.toLowerCase().split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
  final out = <Product>[];
  for (final p in products) {
    if (categoryId != null && !p.categoryIds.contains(categoryId)) continue;
    if (terms.isNotEmpty) {
      final hay = '${p.name} ${p.description ?? ''} ${p.tags.join(' ')}'.toLowerCase();
      if (!terms.every(hay.contains)) continue;
    }
    out.add(p);
  }
  out.sort((a, b) {
    // Name matches first.
    final q = query.toLowerCase().trim();
    if (q.isNotEmpty) {
      final an = a.name.toLowerCase().contains(q) ? 0 : 1;
      final bn = b.name.toLowerCase().contains(q) ? 0 : 1;
      if (an != bn) return an.compareTo(bn);
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return out;
}
