import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../data/products_repository.dart';

const _vendorReasons = [InventoryReason.restock, InventoryReason.adjustment, InventoryReason.returned];

/// +/- delta with reason and note. Queued as a `stock.adjust` custom op so it
/// works offline and replays safely.
Future<bool?> showStockAdjustSheet(BuildContext context, {required Product product, String? variantId}) =>
    AppBottomSheet.show<bool>(
      context,
      title: 'Adjust stock',
      builder: (_) => _StockAdjustBody(product: product, initialVariantId: variantId),
    );

class _StockAdjustBody extends ConsumerStatefulWidget {
  const _StockAdjustBody({required this.product, this.initialVariantId});
  final Product product;
  final String? initialVariantId;

  @override
  ConsumerState<_StockAdjustBody> createState() => _StockAdjustBodyState();
}

class _StockAdjustBodyState extends ConsumerState<_StockAdjustBody> {
  late String? _variantId = widget.initialVariantId ?? (widget.product.hasVariants ? widget.product.variants.firstOrNull?.id : null);
  int _delta = 1;
  InventoryReason _reason = InventoryReason.restock;
  final _note = TextEditingController();
  final _deltaCtrl = TextEditingController(text: '1');
  bool _busy = false;

  @override
  void dispose() {
    _note.dispose();
    _deltaCtrl.dispose();
    super.dispose();
  }

  int get _current => _variantId == null ? widget.product.stock : (widget.product.variantById(_variantId)?.stock ?? 0);

  void _setDelta(int d) {
    setState(() => _delta = d);
    _deltaCtrl.text = d.toString();
  }

  Future<void> _submit() async {
    if (_delta == 0) return;
    if (_current + _delta < 0) {
      showSnack(context, 'Stock cannot go below zero', error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(productsRepositoryProvider).adjustStock(
            widget.product,
            variantId: _variantId,
            delta: _delta,
            reason: _reason,
            note: _note.text,
          );
      if (mounted) {
        Navigator.of(context).pop(true);
        showSnack(context, 'Stock ${_delta > 0 ? '+' : ''}$_delta queued');
      }
    } catch (e) {
      if (mounted) {
        showError(context, e);
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.product;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(p.name, style: theme.textTheme.titleMedium),
          if (p.hasVariants) ...[
            AppSpacing.gapMd,
            DropdownButtonFormField<String>(
              initialValue: _variantId,
              decoration: const InputDecoration(labelText: 'Variant'),
              items: [for (final v in p.variants) DropdownMenuItem(value: v.id, child: Text('${v.name} · ${v.stock} in stock'))],
              onChanged: (v) => setState(() => _variantId = v),
            ),
          ],
          AppSpacing.gapLg,
          Row(
            children: [
              Expanded(
                child: Text('Current: $_current → ${(_current + _delta).clamp(0, 1 << 31)}', style: theme.textTheme.bodyLarge),
              ),
              IconButton.filledTonal(onPressed: () => _setDelta(_delta - 1), icon: const Icon(Icons.remove_rounded)),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _deltaCtrl,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  onChanged: (v) => setState(() => _delta = int.tryParse(v) ?? 0),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              IconButton.filledTonal(onPressed: () => _setDelta(_delta + 1), icon: const Icon(Icons.add_rounded)),
            ],
          ),
          AppSpacing.gapSm,
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final d in [-10, -5, 5, 10, 50])
                ActionChip(label: Text(d > 0 ? '+$d' : '$d'), onPressed: () => _setDelta(_delta + d)),
            ],
          ),
          AppSpacing.gapLg,
          Text('Reason', style: theme.textTheme.labelLarge),
          AppSpacing.gapSm,
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final r in _vendorReasons)
                ChoiceChip(label: Text(titleCase(r.json)), selected: _reason == r, onSelected: (_) => setState(() => _reason = r)),
            ],
          ),
          AppSpacing.gapLg,
          AppTextField(controller: _note, label: 'Note (optional)', hint: 'e.g. supplier delivery', onSubmitted: (_) => _submit()),
          AppSpacing.gapXl,
          AppButton.primary(label: 'Apply adjustment', onPressed: _delta == 0 ? null : _submit, loading: _busy, expanded: true),
          AppSpacing.gapSm,
          Text('Applied as a delta, so it syncs safely even if you are offline.',
              textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
