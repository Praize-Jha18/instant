import 'package:core_models/core_models.dart';

/// Mutable editing model for a variant row.
class VariantDraft {
  VariantDraft({this.id, this.name = '', this.sku = '', this.priceKobo, this.stock = 0, Map<String, String>? attributes})
      : attributes = attributes ?? {};

  String? id;
  String name;
  String sku;
  int? priceKobo;
  int stock;
  final Map<String, String> attributes;

  factory VariantDraft.fromVariant(ProductVariant v) => VariantDraft(
        id: v.id,
        name: v.name,
        sku: v.sku ?? '',
        priceKobo: v.priceKobo,
        stock: v.stock,
        attributes: {for (final e in v.attributes.entries) e.key: e.value?.toString() ?? ''},
      );

  ProductVariant toVariant() => ProductVariant(
        id: id ?? '',
        name: name.trim(),
        sku: sku.trim().isEmpty ? null : sku.trim(),
        priceKobo: priceKobo ?? 0,
        stock: stock,
        attributes: Map<String, Object?>.from(attributes),
      );
}

/// Mutable editing model for the product form. Pure Dart so it can be unit
/// tested; the widget layer binds controllers to it.
class ProductDraft {
  ProductDraft({
    this.name = '',
    this.description = '',
    List<String>? categoryIds,
    this.basePriceKobo,
    this.hasVariants = false,
    List<VariantDraft>? variants,
    this.stock = 0,
    List<String>? tags,
    this.status = ProductStatus.draft,
  })  : categoryIds = categoryIds ?? [],
        variants = variants ?? [],
        tags = tags ?? [];

  factory ProductDraft.fromProduct(Product p) => ProductDraft(
        name: p.name,
        description: p.description ?? '',
        categoryIds: [...p.categoryIds],
        basePriceKobo: p.basePriceKobo,
        hasVariants: p.hasVariants,
        variants: p.variants.map(VariantDraft.fromVariant).toList(),
        stock: p.stock,
        tags: [...p.tags],
        status: p.status,
      );

  String name;
  String description;
  final List<String> categoryIds;
  int? basePriceKobo;
  bool hasVariants;
  final List<VariantDraft> variants;
  int stock;
  final List<String> tags;
  ProductStatus status;

  /// Field-keyed validation errors; empty when valid.
  Map<String, String> validate() {
    final errors = <String, String>{};
    if (name.trim().isEmpty) errors['name'] = 'Name is required';
    if (name.trim().length > 160) errors['name'] = 'At most 160 characters';
    if (basePriceKobo == null) errors['basePrice'] = 'Enter a valid price';
    if (hasVariants) {
      if (variants.isEmpty) errors['variants'] = 'Add at least one variant';
      for (var i = 0; i < variants.length; i++) {
        final v = variants[i];
        if (v.name.trim().isEmpty) errors['variant.$i.name'] = 'Variant name is required';
        if (v.priceKobo == null) errors['variant.$i.price'] = 'Enter a valid price';
        if (v.stock < 0) errors['variant.$i.stock'] = 'Stock cannot be negative';
      }
    } else if (stock < 0) {
      errors['stock'] = 'Stock cannot be negative';
    }
    return errors;
  }

  /// Body for `POST/PATCH /vendor/products`. Stock is only meaningful on
  /// creation (the server owns stock afterwards; use stock adjustments).
  ProductInput toInput({bool creating = false}) => ProductInput(
        name: name.trim(),
        description: description.trim(),
        categoryIds: [...categoryIds],
        basePriceKobo: basePriceKobo ?? 0,
        hasVariants: hasVariants,
        variants: hasVariants ? variants.map((v) => v.toVariant()).toList() : const [],
        stock: creating && !hasVariants ? stock : null,
        status: status,
        tags: tags.map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
      );

  /// True when only the offline-safe text fields (name, description, tags)
  /// differ from [original]. Such edits go through the outbox.
  bool isTextOnlyChangeFrom(Product original) {
    final o = ProductDraft.fromProduct(original);
    bool sameList(List<String> a, List<String> b) => a.length == b.length && a.every(b.contains);
    if (basePriceKobo != o.basePriceKobo) return false;
    if (hasVariants != o.hasVariants) return false;
    if (status != o.status) return false;
    if (!sameList(categoryIds, o.categoryIds)) return false;
    if (variants.length != o.variants.length) return false;
    for (var i = 0; i < variants.length; i++) {
      final a = variants[i], b = o.variants[i];
      if (a.id != b.id || a.name != b.name || a.sku != b.sku || a.priceKobo != b.priceKobo || a.stock != b.stock) return false;
      if (a.attributes.length != b.attributes.length || a.attributes.entries.any((e) => b.attributes[e.key] != e.value)) return false;
    }
    return true;
  }

  /// Copy of [original] with this draft's fields applied (local upsert).
  Product applyTo(Product original) => original.copyWith(
        name: name.trim(),
        description: description.trim(),
        categoryIds: [...categoryIds],
        basePriceKobo: basePriceKobo ?? original.basePriceKobo,
        hasVariants: hasVariants,
        variants: hasVariants ? variants.map((v) => v.toVariant()).toList() : const [],
        tags: tags.map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
        status: status,
        updatedAt: DateTime.now().toUtc(),
      );
}
