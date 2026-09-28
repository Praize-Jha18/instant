import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../core/geo.dart';
import '../../addresses/data/address_providers.dart';
import '../../addresses/presentation/widgets/address_picker_sheet.dart';
import '../domain/cart_totals.dart';
import 'cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final totals = ref.watch(cartTotalsProvider);
    final online = ref.watch(isOnlineProvider);
    final address = ref.watch(selectedAddressProvider);
    final actions = ref.read(cartActionsProvider);
    final imageUrl = ref.watch(imageUrlProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          if (!totals.isEmpty)
            TextButton(
              onPressed: () async {
                final ok = await AppBottomSheet.confirm(
                  context,
                  title: 'Clear cart?',
                  message: 'All items will be removed.',
                  confirmLabel: 'Clear',
                  destructive: true,
                );
                if (ok) await actions.clear();
              },
              child: const Text('Clear'),
            ),
        ],
      ),
      body: cartAsync.when(
        loading: () => const SkeletonList(itemCount: 3),
        error: (e, _) => ErrorState(message: e.toString()),
        data: (cart) {
          if (totals.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Browse vendors near you and add something you like.',
              action: AppButton.secondary(
                label: 'Start shopping',
                icon: Icons.storefront_outlined,
                onPressed: () => context.go(AppRoutes.home),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
                  children: [
                    _AddressRow(address: address),
                    const SizedBox(height: AppSpacing.md),
                    for (var i = 0; i < totals.groups.length; i++) ...[
                      FadeSlideIn.staggered(
                        index: i,
                        child: _VendorGroupCard(
                          group: totals.groups[i],
                          hasDropoff: totals.hasDropoff,
                          imageUrl: imageUrl,
                          onQty: (item, qty) => actions.setQty(item.lineKey, qty),
                          onRemove: (item) => _removeWithUndo(context, actions, item),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
              _Summary(totals: totals, online: online, hasAddress: address != null),
            ],
          );
        },
      ),
    );
  }

  Future<void> _removeWithUndo(BuildContext context, CartActions actions, CartItem item) async {
    await actions.remove(item.lineKey);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Removed ${item.nameSnapshot}'),
        action: SnackBarAction(label: 'Undo', onPressed: () => actions.restore(item)),
        duration: const Duration(seconds: 4),
      ));
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address});
  final Address? address;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      onTap: () => showAddressPicker(context),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: scheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address == null ? 'Deliver to' : 'Deliver to ${address!.label}', style: context.text.labelMedium),
                Text(
                  address?.oneLine ?? 'Select an address for delivery estimates',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Icon(Icons.expand_more_rounded),
        ],
      ),
    );
  }
}

class _VendorGroupCard extends StatelessWidget {
  const _VendorGroupCard({
    required this.group,
    required this.hasDropoff,
    required this.imageUrl,
    required this.onQty,
    required this.onRemove,
  });

  final VendorCartGroup group;
  final bool hasDropoff;
  final String? Function(String? id, {bool thumb}) imageUrl;
  final void Function(CartItem item, int qty) onQty;
  final void Function(CartItem item) onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final fee = group.deliveryFeeKobo;
    final feeLabel = fee == null
        ? 'Delivery calculated at checkout'
        : fee == 0
            ? 'Free delivery'
            : 'Delivery ${Money.fromKobo(fee).format()}${hasDropoff ? '' : ' (from store)'}';

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
            child: Row(
              children: [
                Icon(Icons.storefront_outlined, size: 18, color: scheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(group.vendorName, style: context.text.titleSmall)),
                if (group.distanceKm != null)
                  Text(formatDistance(group.distanceKm!),
                      style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final item in group.items)
            Dismissible(
              key: ValueKey('cart-${item.lineKey}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => onRemove(item),
              background: Container(
                color: semantic.dangerContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppSpacing.xl),
                child: Icon(Icons.delete_outline_rounded, color: semantic.onDangerContainer),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    AppImage(url: imageUrl(item.imageId, thumb: true), width: 56, height: 56),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.nameSnapshot, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: AppSpacing.xxs),
                          MoneyText.kobo(item.lineTotalKobo, emphasize: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    QuantityStepper(
                      value: item.qty,
                      compact: true,
                      onChanged: (q) => onQty(item, q),
                      onRemove: () => onRemove(item),
                    ),
                  ],
                ),
              ),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
            child: Column(
              children: [
                _Line(label: 'Subtotal', kobo: group.subtotalKobo),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.delivery_dining_outlined, size: 16, color: scheme.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(feeLabel, style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.kobo, this.emphasize = false});
  final String label;
  final int kobo;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize ? context.text.titleMedium : context.text.bodyMedium;
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        MoneyText.kobo(kobo, style: style, emphasize: emphasize),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.totals, required this.online, required this.hasAddress});
  final CartTotals totals;
  final bool online;
  final bool hasAddress;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final tooltip = !online
        ? 'You are offline. Checkout needs an internet connection.'
        : !hasAddress
            ? 'Select a delivery address first'
            : null;
    return Material(
      color: scheme.surface,
      elevation: 8,
      shadowColor: Colors.black26,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.page,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Line(label: 'Subtotal', kobo: totals.subtotalKobo),
              const SizedBox(height: AppSpacing.xs),
              _Line(
                label: totals.hasUnknownDelivery ? 'Delivery (partial estimate)' : 'Delivery estimate',
                kobo: totals.deliveryTotalKobo,
              ),
              const SizedBox(height: AppSpacing.sm),
              _Line(label: 'Total', kobo: totals.totalKobo, emphasize: true),
              const SizedBox(height: AppSpacing.md),
              AppButton.primary(
                key: const ValueKey('checkout-button'),
                label: 'Checkout',
                expanded: true,
                size: AppButtonSize.large,
                icon: Icons.lock_outline_rounded,
                tooltip: tooltip,
                onPressed: (online && hasAddress) ? () => context.push(AppRoutes.checkout) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
