import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../addresses/data/address_providers.dart';
import '../../cart/domain/cart_totals.dart';
import '../../cart/presentation/cart_providers.dart';
import '../domain/checkout_state.dart';
import 'checkout_controller.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(checkoutControllerProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _place(Address address) async {
    final controller = ref.read(checkoutControllerProvider.notifier);
    final style = Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    // Hand over to the payment screen as soon as the order exists.
    ref.listenManual<CheckoutState>(checkoutControllerProvider, (prev, next) {
      final order = next.order;
      if (order != null && prev?.order == null && mounted) {
        context.pushReplacement(AppRoutes.payment(order.id));
      }
    });
    await controller.placeOrder(addressId: address.id, note: _note.text, style: style);
  }

  @override
  Widget build(BuildContext context) {
    final totals = ref.watch(cartTotalsProvider);
    final addresses = ref.watch(addressesProvider).value ?? const <Address>[];
    final selected = ref.watch(selectedAddressProvider);
    final online = ref.watch(isOnlineProvider);
    final state = ref.watch(checkoutControllerProvider);
    final scheme = context.colors;
    final placing = state is CheckoutPlacing;
    final error = state is CheckoutFailed && state.order == null ? state.message : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: totals.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Nothing to check out',
              action: AppButton.secondary(label: 'Back to shopping', onPressed: () => context.go(AppRoutes.home)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
                    children: [
                      SectionHeader(
                        title: 'Delivery address',
                        actionLabel: 'Add',
                        onAction: () => context.push(AppRoutes.addressNew),
                      ),
                      if (addresses.isEmpty)
                        AppCard(
                          child: Text('Add an address to continue.',
                              style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                        )
                      else
                        for (final a in addresses)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _AddressChoice(
                              address: a,
                              selected: a.id == selected?.id,
                              onTap: () => ref.read(selectedAddressIdProvider.notifier).select(a.id),
                            ),
                          ),
                      const SizedBox(height: AppSpacing.lg),
                      const SectionHeader(title: 'Order summary'),
                      for (final g in totals.groups) _GroupSummary(group: g),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _note,
                        label: 'Note for the vendor (optional)',
                        prefixIcon: Icons.sticky_note_2_outlined,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      if (error != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        ErrorState(compact: true, message: error),
                      ],
                    ],
                  ),
                ),
                Material(
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
                          _TotalLine(label: 'Subtotal', kobo: totals.subtotalKobo),
                          const SizedBox(height: AppSpacing.xs),
                          _TotalLine(label: 'Delivery estimate', kobo: totals.deliveryTotalKobo),
                          const SizedBox(height: AppSpacing.sm),
                          _TotalLine(label: 'Total (final at payment)', kobo: totals.totalKobo, emphasize: true),
                          const SizedBox(height: AppSpacing.md),
                          AppButton.primary(
                            label: 'Place order & pay',
                            icon: Icons.lock_outline_rounded,
                            expanded: true,
                            size: AppButtonSize.large,
                            loading: placing,
                            tooltip: !online
                                ? 'You are offline. Placing an order needs a connection.'
                                : selected == null
                                    ? 'Select a delivery address'
                                    : null,
                            onPressed: online && selected != null && !placing ? () => _place(selected) : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _AddressChoice extends StatelessWidget {
  const _AddressChoice({required this.address, required this.selected, required this.onTap});
  final Address address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.curve,
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: selected ? scheme.primary : Colors.transparent, width: 1.5),
      ),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: selected ? scheme.primary : scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.label, style: context.text.titleSmall),
                  Text(address.oneLine, style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupSummary extends StatelessWidget {
  const _GroupSummary({required this.group});
  final VendorCartGroup group;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(group.vendorName, style: context.text.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            for (final item in group.items)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Text('${item.qty}×', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(item.nameSnapshot, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    MoneyText.kobo(item.lineTotalKobo),
                  ],
                ),
              ),
            const Divider(height: AppSpacing.lg),
            _TotalLine(label: 'Subtotal', kobo: group.subtotalKobo),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                Expanded(child: Text('Delivery', style: context.text.bodyMedium)),
                group.deliveryFeeKobo == null
                    ? Text('at checkout', style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant))
                    : MoneyText.kobo(group.deliveryFeeKobo!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalLine extends StatelessWidget {
  const _TotalLine({required this.label, required this.kobo, this.emphasize = false});
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
