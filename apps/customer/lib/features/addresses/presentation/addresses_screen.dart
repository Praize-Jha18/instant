import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../data/address_providers.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);
    final actions = ref.read(addressActionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addressNew),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add address'),
      ),
      body: addressesAsync.when(
        loading: () => const SkeletonList(itemCount: 3),
        error: (e, _) => ErrorState(message: e.toString()),
        data: (addresses) {
          if (addresses.isEmpty) {
            return const EmptyState(
              icon: Icons.location_off_outlined,
              title: 'No addresses yet',
              message: 'Add a delivery address to see fees and check out. Works offline too.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            itemCount: addresses.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) {
              final a = addresses[i];
              return FadeSlideIn.staggered(
                index: i,
                child: Dismissible(
                  key: ValueKey('address-${a.id}'),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => AppBottomSheet.confirm(
                    context,
                    title: 'Delete ${a.label}?',
                    message: a.oneLine,
                    confirmLabel: 'Delete',
                    destructive: true,
                  ),
                  onDismissed: (_) => actions.delete(a.id),
                  background: Container(
                    decoration: BoxDecoration(color: context.semanticColors.dangerContainer, borderRadius: AppRadius.mdAll),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.xl),
                    child: Icon(Icons.delete_outline_rounded, color: context.semanticColors.onDangerContainer),
                  ),
                  child: _AddressCard(
                    address: a,
                    onEdit: () => context.push(AppRoutes.addressEdit(a.id)),
                    onDefault: a.isDefault ? null : () => actions.setDefault(a.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onEdit, required this.onDefault});
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback? onDefault;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return AppCard(
      onTap: onEdit,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: AppRadius.smAll),
            child: Icon(address.isDefault ? Icons.home_rounded : Icons.location_on_outlined, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(address.label, style: context.text.titleSmall)),
                    if (address.isDefault) const StatusChip(label: 'Default', tone: StatusTone.primary, dense: true),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(address.oneLine, style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                if (address.phone != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(address.phone!, style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
                if (onDefault != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(onPressed: onDefault, child: const Text('Set as default')),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
