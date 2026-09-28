import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/money_input.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/image_picker_button.dart';
import '../data/products_repository.dart';
import '../domain/product_draft.dart';
import 'stock_adjust_sheet.dart';

/// Create (productId null) or edit a product.
class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.productId});

  final String? productId;

  bool get isNew => productId == null;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  ProductDraft _draft = ProductDraft();
  Product? _product;
  bool _initialised = false;
  bool _busy = false;
  Map<String, String> _errors = const {};

  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController(text: '0');
  final _tags = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isNew) _initialised = true;
  }

  @override
  void dispose() {
    for (final c in [_name, _description, _price, _stock, _tags]) {
      c.dispose();
    }
    super.dispose();
  }

  void _initFrom(Product p) {
    _product = p;
    if (_initialised) return;
    _initialised = true;
    _draft = ProductDraft.fromProduct(p);
    _name.text = p.name;
    _description.text = p.description ?? '';
    _price.text = koboToNairaText(p.basePriceKobo);
    _stock.text = p.stock.toString();
    _tags.text = p.tags.join(', ');
  }

  void _syncDraft() {
    _draft
      ..name = _name.text
      ..description = _description.text
      ..basePriceKobo = parseNairaToKobo(_price.text)
      ..stock = int.tryParse(_stock.text.trim()) ?? -1
      ..tags.clear()
      ..tags.addAll(_tags.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty));
  }

  Future<void> _save() async {
    if (_busy) return;
    _syncDraft();
    final errors = _draft.validate();
    setState(() => _errors = errors);
    if (errors.isNotEmpty) {
      showSnack(context, 'Please fix the highlighted fields', error: true);
      return;
    }
    final online = ref.read(isOnlineProvider);
    final repo = ref.read(productsRepositoryProvider);
    setState(() => _busy = true);
    try {
      if (widget.isNew) {
        if (!online) {
          showSnack(context, 'Creating a product requires a connection', error: true);
          return;
        }
        final created = await repo.create(_draft.toInput(creating: true));
        if (!mounted) return;
        showSnack(context, 'Product created. You can add photos now.');
        context.go('/products/${created.id}');
      } else {
        final original = _product!;
        if (_draft.isTextOnlyChangeFrom(original)) {
          await repo.updateOffline(original, _draft);
          if (mounted) showSnack(context, online ? 'Saved' : 'Saved offline. It will sync when you reconnect.');
        } else {
          if (!online) {
            showSnack(context, 'Price, variants, status and categories can only be changed while online. Name, description and tags save offline.', error: true);
            return;
          }
          final updated = await repo.updateOnline(original.id, _draft.toInput());
          _draft = ProductDraft.fromProduct(updated);
          if (mounted) showSnack(context, 'Saved');
        }
      }
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final p = _product;
    if (p == null) return;
    final ok = await AppBottomSheet.confirm(context,
        title: 'Delete ${p.name}?', message: 'Customers will no longer see it. This cannot be undone.', confirmLabel: 'Delete', destructive: true);
    if (!ok) return;
    try {
      await ref.read(productsRepositoryProvider).delete(p.id);
      if (mounted) {
        showSnack(context, 'Product deleted');
        context.go('/products');
      }
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    if (!widget.isNew) {
      final product = ref.watch(productStreamProvider(widget.productId!));
      final p = product.value;
      if (p != null) _initFrom(p);
      if (p == null) {
        return AppPage(
          title: 'Product',
          body: product.isLoading
              ? const SkeletonList()
              : EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'Product not found',
                  action: AppButton.secondary(label: 'Back to products', onPressed: () => context.go('/products'))),
        );
      }
    }
    final categories = ref.watch(categoriesStreamProvider).value ?? const <Category>[];
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card('Details', [
          AppTextField(
            controller: _name,
            label: 'Name',
            errorText: _errors['name'],
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => _clear('name'),
          ),
          AppSpacing.gapLg,
          AppTextField(
            controller: _description,
            label: 'Description',
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
          ),
          AppSpacing.gapLg,
          AppTextField(
            controller: _tags,
            label: 'Tags (comma separated)',
            hint: 'spicy, family size',
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.gapLg,
          Text('Categories', style: theme.textTheme.labelLarge),
          AppSpacing.gapSm,
          if (categories.isEmpty)
            Text('No categories available yet', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant))
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final c in categories)
                  FilterChip(
                    label: Text(c.name),
                    selected: _draft.categoryIds.contains(c.id),
                    onSelected: (v) => setState(() => v ? _draft.categoryIds.add(c.id) : _draft.categoryIds.remove(c.id)),
                  ),
              ],
            ),
        ]),
        _card('Pricing & stock', [
          _PriceField(
            controller: _price,
            label: _draft.hasVariants ? 'Base price (shown as "from")' : 'Price',
            errorText: _errors['basePrice'],
            onChanged: (_) => setState(() => _errors = Map.of(_errors)..remove('basePrice')),
          ),
          AppSpacing.gapLg,
          // ListTiles paint on the nearest Material; AppCard is a plain box.
          Material(
            type: MaterialType.transparency,
            child: SwitchListTile.adaptive(
              key: const ValueKey('has-variants'),
              contentPadding: EdgeInsets.zero,
              title: const Text('This product has variants'),
              subtitle: const Text('Sizes, colours or packs with their own price and stock'),
              value: _draft.hasVariants,
              onChanged: (v) => setState(() {
                _draft.hasVariants = v;
                if (v && _draft.variants.isEmpty) _draft.variants.add(VariantDraft(priceKobo: parseNairaToKobo(_price.text)));
              }),
            ),
          ),
          if (!_draft.hasVariants) ...[
            AppSpacing.gapSm,
            AppTextField(
              controller: _stock,
              label: widget.isNew ? 'Initial stock' : 'Stock (adjust via the stock sheet)',
              keyboardType: TextInputType.number,
              readOnly: !widget.isNew,
              errorText: _errors['stock'],
              helper: widget.isNew ? null : 'Stock is server-owned; use "Adjust stock" to change it.',
              suffix: widget.isNew || _product == null
                  ? null
                  : TextButton(onPressed: () => showStockAdjustSheet(context, product: _product!), child: const Text('Adjust')),
            ),
          ] else ...[
            AppSpacing.gapSm,
            if (_errors['variants'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(_errors['variants']!, style: TextStyle(color: scheme.error)),
              ),
            for (var i = 0; i < _draft.variants.length; i++)
              VariantRow(
                key: ObjectKey(_draft.variants[i]),
                index: i,
                variant: _draft.variants[i],
                errors: _errors,
                stockEditable: widget.isNew || _draft.variants[i].id == null,
                onRemove: () => setState(() => _draft.variants.removeAt(i)),
                onAdjustStock: _product == null || _draft.variants[i].id == null
                    ? null
                    : () => showStockAdjustSheet(context, product: _product!, variantId: _draft.variants[i].id),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton.ghost(
                key: const ValueKey('add-variant'),
                label: 'Add variant',
                icon: Icons.add_rounded,
                onPressed: () => setState(() => _draft.variants.add(VariantDraft(priceKobo: parseNairaToKobo(_price.text)))),
              ),
            ),
          ],
        ]),
        _card('Visibility', [
          SegmentedButton<ProductStatus>(
            segments: const [
              ButtonSegment(value: ProductStatus.draft, label: Text('Draft'), icon: Icon(Icons.edit_note_rounded)),
              ButtonSegment(value: ProductStatus.active, label: Text('Active'), icon: Icon(Icons.visibility_outlined)),
              ButtonSegment(value: ProductStatus.archived, label: Text('Archived'), icon: Icon(Icons.archive_outlined)),
            ],
            selected: {_draft.status},
            onSelectionChanged: (s) => setState(() => _draft.status = s.first),
          ),
          AppSpacing.gapSm,
          Text(
            switch (_draft.status) {
              ProductStatus.draft => 'Only you can see drafts.',
              ProductStatus.active => 'Visible to customers once your store is approved.',
              ProductStatus.archived => 'Hidden from customers but kept for order history.',
            },
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ]),
        AppButton.primary(
          key: const ValueKey('save-product'),
          label: widget.isNew ? 'Create product' : 'Save changes',
          onPressed: _save,
          loading: _busy,
          expanded: true,
          size: AppButtonSize.large,
        ),
        AppSpacing.gapSm,
        Text(
          widget.isNew
              ? (online ? 'Creating requires a connection. Photos can be added after creating.' : 'You are offline: creating a product needs a connection.')
              : 'Name, description and tags save offline; everything else needs a connection.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );

    final side = widget.isNew || _product == null
        ? AppCard(
            child: Row(children: [
              Icon(Icons.photo_library_outlined, color: scheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text('Save the product first to add photos.', style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant))),
            ]),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductImagesManager(product: _product!),
              AppSpacing.gapLg,
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  AppListTile(
                    leadingIcon: Icons.tune_rounded,
                    title: 'Adjust stock',
                    subtitle: '${_product!.totalStock} in stock · works offline',
                    onTap: () => showStockAdjustSheet(context, product: _product!),
                  ),
                  const Divider(),
                  AppListTile(
                    leadingIcon: Icons.history_rounded,
                    title: 'Stock history',
                    subtitle: 'Sales, restocks and adjustments',
                    onTap: () => context.go('/products/${_product!.id}/movements'),
                  ),
                  const Divider(),
                  AppListTile(
                    leadingIcon: Icons.info_outline,
                    title: 'Updated ${timeAgo(_product!.updatedAt)}',
                    subtitle: 'v${_product!.version} · ${_product!.slug}',
                    showChevron: false,
                  ),
                ]),
              ),
            ],
          );

    return AppPage(
      title: widget.isNew ? 'New product' : (_product?.name ?? 'Edit product'),
      actions: [
        if (!widget.isNew)
          IconButton(
            tooltip: online ? 'Delete product' : 'You are offline',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: online ? _delete : null,
          ),
      ],
      body: SingleChildScrollView(
        padding: AppSpacing.page,
        child: TwoPane(primary: form, secondary: side),
      ),
    );
  }

  void _clear(String key) {
    if (_errors.containsKey(key)) setState(() => _errors = Map.of(_errors)..remove(key));
  }

  Widget _card(String title, List<Widget> children) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              AppSpacing.gapLg,
              ...children,
            ],
          ),
        ),
      );
}

/// Naira input that shows the kobo value it will send.
class _PriceField extends StatelessWidget {
  const _PriceField({required this.controller, required this.label, this.errorText, this.onChanged});
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final kobo = parseNairaToKobo(value.text);
          return AppTextField(
            key: const ValueKey('price-field'),
            controller: controller,
            label: label,
            prefix: const Text('₦ '),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: nairaInputFormatters,
            errorText: errorText,
            helper: kobo == null ? 'Amount in naira, e.g. 12,500.50' : '= ${Money.fromKobo(kobo).format()} ($kobo kobo)',
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
          );
        },
      );
}

/// One editable variant.
class VariantRow extends StatefulWidget {
  const VariantRow({
    super.key,
    required this.index,
    required this.variant,
    required this.errors,
    required this.onRemove,
    this.stockEditable = true,
    this.onAdjustStock,
  });

  final int index;
  final VariantDraft variant;
  final Map<String, String> errors;
  final VoidCallback onRemove;
  final bool stockEditable;
  final VoidCallback? onAdjustStock;

  @override
  State<VariantRow> createState() => _VariantRowState();
}

class _VariantRowState extends State<VariantRow> {
  late final _name = TextEditingController(text: widget.variant.name);
  late final _sku = TextEditingController(text: widget.variant.sku);
  late final _price = TextEditingController(text: widget.variant.priceKobo == null ? '' : koboToNairaText(widget.variant.priceKobo!));
  late final _stock = TextEditingController(text: widget.variant.stock.toString());

  @override
  void dispose() {
    for (final c in [_name, _sku, _price, _stock]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addAttribute() async {
    final key = TextEditingController();
    final value = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add attribute'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: key, label: 'Name', hint: 'Size', autofocus: true, textInputAction: TextInputAction.next),
            AppSpacing.gapMd,
            AppTextField(controller: value, label: 'Value', hint: 'Large', onSubmitted: (_) => Navigator.of(ctx).pop(true)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Add')),
        ],
      ),
    );
    if (ok == true && key.text.trim().isNotEmpty) {
      setState(() => widget.variant.attributes[key.text.trim()] = value.text.trim());
    }
    key.dispose();
    value.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final prefix = 'variant.${widget.index}';
    return Container(
      key: ValueKey('variant-row-${widget.index}'),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.smAll,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Variant ${widget.index + 1}', style: theme.textTheme.labelLarge)),
              if (widget.onAdjustStock != null)
                TextButton.icon(onPressed: widget.onAdjustStock, icon: const Icon(Icons.tune_rounded, size: 16), label: const Text('Adjust stock')),
              IconButton(tooltip: 'Remove variant', icon: const Icon(Icons.delete_outline_rounded), onPressed: widget.onRemove),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  controller: _name,
                  label: 'Name',
                  hint: 'e.g. Large',
                  errorText: widget.errors['$prefix.name'],
                  onChanged: (t) => v.name = t,
                  textInputAction: TextInputAction.next,
                ),
              ),
              AppSpacing.gapMd,
              Expanded(
                flex: 2,
                child: AppTextField(controller: _sku, label: 'SKU', onChanged: (t) => v.sku = t, textInputAction: TextInputAction.next),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  controller: _price,
                  label: 'Price',
                  prefix: const Text('₦ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: nairaInputFormatters,
                  errorText: widget.errors['$prefix.price'],
                  onChanged: (t) => v.priceKobo = parseNairaToKobo(t),
                  textInputAction: TextInputAction.next,
                ),
              ),
              AppSpacing.gapMd,
              Expanded(
                flex: 2,
                child: AppTextField(
                  controller: _stock,
                  label: widget.stockEditable ? 'Stock' : 'Stock (server)',
                  keyboardType: TextInputType.number,
                  readOnly: !widget.stockEditable,
                  errorText: widget.errors['$prefix.stock'],
                  onChanged: (t) => v.stock = int.tryParse(t.trim()) ?? -1,
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final e in v.attributes.entries)
                InputChip(label: Text('${e.key}: ${e.value}'), onDeleted: () => setState(() => v.attributes.remove(e.key))),
              ActionChip(avatar: const Icon(Icons.add, size: 16), label: const Text('Attribute'), onPressed: _addAttribute),
            ],
          ),
        ],
      ),
    );
  }
}

/// Upload / reorder / delete product photos (online only).
class ProductImagesManager extends ConsumerStatefulWidget {
  const ProductImagesManager({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ProductImagesManager> createState() => _ProductImagesManagerState();
}

class _ProductImagesManagerState extends ConsumerState<ProductImagesManager> {
  double? _progress;
  String? _busyImageId;

  Future<void> _upload() async {
    final picked = await pickImage(context);
    if (picked == null || !mounted) return;
    if (picked.bytes.length > maxImageBytes) {
      showSnack(context, 'Image is larger than 2 MB. Please choose a smaller one.', error: true);
      return;
    }
    setState(() => _progress = 0);
    try {
      await ref.read(productsRepositoryProvider).uploadImage(
            widget.product.id,
            bytes: picked.bytes,
            filename: picked.filename,
            contentType: picked.contentType,
            sortOrder: widget.product.images.length,
            onProgress: (sent, total) {
              if (mounted && total > 0) setState(() => _progress = sent / total);
            },
          );
      if (mounted) showSnack(context, 'Photo uploaded');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _progress = null);
    }
  }

  Future<void> _delete(String imageId) async {
    setState(() => _busyImageId = imageId);
    try {
      await ref.read(productsRepositoryProvider).deleteImage(widget.product.id, imageId);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busyImageId = null);
    }
  }

  Future<void> _move(int from, int to) async {
    final images = [...widget.product.images]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (to < 0 || to >= images.length) return;
    final item = images.removeAt(from);
    images.insert(to, item);
    await ref.read(productsRepositoryProvider).reorderImages(widget.product, images);
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    final api = ref.watch(apiClientProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final images = [...widget.product.images]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final uploading = _progress != null;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Photos', style: theme.textTheme.titleMedium)),
              AppButton.secondary(
                label: 'Add photo',
                icon: Icons.add_photo_alternate_outlined,
                size: AppButtonSize.small,
                loading: uploading,
                onPressed: online && !uploading ? _upload : null,
                tooltip: 'Photo uploads need a connection',
              ),
            ],
          ),
          if (uploading) ...[
            AppSpacing.gapSm,
            LinearProgressIndicator(value: _progress == 0 ? null : _progress),
            AppSpacing.gapXs,
            Text('Uploading ${((_progress ?? 0) * 100).round()}%', style: theme.textTheme.bodySmall),
          ],
          AppSpacing.gapMd,
          if (images.isEmpty)
            Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: scheme.surfaceContainerHighest.withValues(alpha: 0.5), borderRadius: AppRadius.smAll),
              child: Text('No photos yet. The first photo is the cover.', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (var i = 0; i < images.length; i++)
                  SizedBox(
                    width: 132,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            AppImage(
                              url: api.catalog.imageUrl(images[i].imageId, thumb: true),
                              width: 132,
                              height: 132,
                              heroTag: i == 0 ? 'product-${widget.product.id}' : null,
                            ),
                            if (i == 0)
                              Positioned(
                                left: 6,
                                top: 6,
                                child: StatusChip(label: 'Cover', tone: StatusTone.primary, dense: true),
                              ),
                            if (_busyImageId == images[i].imageId)
                              const Positioned.fill(child: Center(child: CircularProgressIndicator())),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Move left',
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.chevron_left_rounded),
                              onPressed: online && i > 0 ? () => _move(i, i - 1) : null,
                            ),
                            IconButton(
                              tooltip: 'Move right',
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.chevron_right_rounded),
                              onPressed: online && i < images.length - 1 ? () => _move(i, i + 1) : null,
                            ),
                            IconButton(
                              tooltip: online ? 'Delete' : 'You are offline',
                              visualDensity: VisualDensity.compact,
                              icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
                              onPressed: online && _busyImageId == null ? () => _delete(images[i].imageId) : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
