import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../data/address_providers.dart';

/// Bottom sheet to pick the delivery address (cart + checkout).
Future<void> showAddressPicker(BuildContext context) => AppBottomSheet.show<void>(
      context,
      title: 'Deliver to',
      builder: (context) => const _AddressPickerBody(),
    );

class _AddressPickerBody extends ConsumerWidget {
  const _AddressPickerBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider).value ?? const <Address>[];
    final selected = ref.watch(selectedAddressProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (addresses.isEmpty)
          const EmptyState(
            compact: true,
            icon: Icons.location_off_outlined,
            title: 'No addresses yet',
            message: 'Add one to see delivery fees and check out.',
          )
        else
          for (final a in addresses)
            AppListTile(
              leadingIcon: a.isDefault ? Icons.home_rounded : Icons.location_on_outlined,
              title: a.label,
              subtitle: a.oneLine,
              selected: a.id == selected?.id,
              showChevron: false,
              trailing: a.id == selected?.id ? Icon(Icons.check_circle_rounded, color: context.colors.primary) : null,
              onTap: () {
                ref.read(selectedAddressIdProvider.notifier).select(a.id);
                Navigator.of(context).pop();
              },
            ),
        const SizedBox(height: AppSpacing.md),
        AppButton.secondary(
          label: 'Add new address',
          icon: Icons.add_location_alt_outlined,
          onPressed: () {
            Navigator.of(context).pop();
            context.push(AppRoutes.addressNew);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
