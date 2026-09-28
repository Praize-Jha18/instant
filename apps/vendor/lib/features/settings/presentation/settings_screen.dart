import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../../vendor/data/vendor_repository.dart';
import '../../vendor/presentation/vendor_profile_form.dart';
import 'theme_mode_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  Future<void> _save(VendorInput input) async {
    setState(() => _busy = true);
    try {
      final v = await ref.read(vendorRepositoryProvider).updateProfile(input);
      ref.read(sessionProvider.notifier).setVendor(v);
      if (mounted) showSnack(context, 'Profile saved');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _editSection(BuildContext context, Vendor vendor, List<VendorFormSection> sections, String title) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.sm, 0),
                child: Row(children: [
                  Expanded(child: Text(title, style: Theme.of(ctx).textTheme.titleLarge)),
                  IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close_rounded)),
                ]),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: AppSpacing.page,
                  child: VendorProfileForm(
                    initial: vendor,
                    sections: sections,
                    busy: _busy,
                    onSubmit: (input) async {
                      await _save(input);
                      if (ctx.mounted) Navigator.of(ctx).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final vendor = ref.watch(vendorStreamProvider).value ?? session.vendor;
    final online = ref.watch(isOnlineProvider);
    final api = ref.watch(apiClientProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (vendor == null) {
      return AppPage(
        title: 'Settings',
        body: session.vendorLoading
            ? const SkeletonList()
            : ErrorState(
                offline: !online,
                title: 'Profile unavailable',
                message: 'Your vendor profile has not been loaded yet.',
                onRetry: () => ref.read(sessionProvider.notifier).refreshVendor(),
              ),
      );
    }

    Widget section(String title, String subtitle, IconData icon, List<VendorFormSection> sections, {Widget? preview}) => AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppListTile(
                leadingIcon: icon,
                title: title,
                subtitle: subtitle,
                trailing: online ? null : const Tooltip(message: 'Editing requires a connection', child: Icon(Icons.cloud_off_outlined)),
                onTap: online ? () => _editSection(context, vendor, sections, title) : null,
                enabled: online,
              ),
              if (preview != null) Padding(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg), child: preview),
            ],
          ),
        );

    final hours = vendor.openingHours.isEmpty
        ? 'Not set'
        : vendor.openingHours.where((h) => !h.closed).map((h) => '${weekdayName(h.weekday).substring(0, 3)} ${h.open}–${h.close}').join(', ');
    final fee = vendor.deliveryFee;

    return AppPage(
      title: 'Settings',
      body: ListView(
        padding: AppSpacing.page,
        children: [
          AppCard(
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: AppRadius.mdAll),
                      clipBehavior: Clip.antiAlias,
                      child: vendor.logoImageId != null
                          ? AppImage(url: api.catalog.imageUrl(vendor.logoImageId!, thumb: true), borderRadius: AppRadius.mdAll)
                          : Icon(Icons.storefront_rounded, color: scheme.onPrimaryContainer, size: 32),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor.name, style: theme.textTheme.titleLarge),
                      Text('/${vendor.slug} · ${session.user?.email ?? ''}', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: AppSpacing.xs),
                      StatusChip.vendor(vendor.status),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapSm,
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
            child: Row(children: [
              Icon(Icons.image_outlined, color: scheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Logo and cover upload are not available yet: the backend has no vendor image endpoint in this release.',
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
              const Tooltip(
                message: 'Requires POST /vendor/images (not in the API contract yet)',
                child: AppButton.secondary(label: 'Upload logo', size: AppButtonSize.small, onPressed: null),
              ),
            ]),
          ),
          AppSpacing.gapLg,
          section('Store profile', (vendor.description ?? '').isEmpty ? 'Add a description' : vendor.description!, Icons.storefront_outlined,
              const [VendorFormSection.basics]),
          AppSpacing.gapSm,
          section('Address', vendor.address == null ? 'Not set' : '${vendor.address!.line1}, ${vendor.address!.city}, ${vendor.address!.state}',
              Icons.location_on_outlined, const [VendorFormSection.address]),
          AppSpacing.gapSm,
          section(
            'Delivery fees',
            fee == null
                ? 'Not set'
                : 'Base ${Money.fromKobo(fee.baseKobo).format(showDecimals: false)} + ${Money.fromKobo(fee.perKmKobo).format(showDecimals: false)}/km'
                    '${fee.freeAboveKobo != null ? ', free above ${Money.fromKobo(fee.freeAboveKobo!).format(showDecimals: false)}' : ''}'
                    '${vendor.deliveryRadiusKm != null ? ' · ${vendor.deliveryRadiusKm} km radius' : ''}',
            Icons.local_shipping_outlined,
            const [VendorFormSection.deliveryFee],
          ),
          AppSpacing.gapSm,
          section('Opening hours', hours, Icons.schedule_rounded, const [VendorFormSection.hours]),
          AppSpacing.gapSm,
          section(
            'Payout bank account',
            vendor.payout == null ? 'Not set' : '${vendor.payout!.bankName} · ${vendor.payout!.accountNumber} · ${vendor.payout!.accountName}',
            Icons.account_balance_outlined,
            const [VendorFormSection.payout],
          ),
          AppSpacing.gapXl,
          Text('App', style: theme.textTheme.titleMedium),
          AppSpacing.gapSm,
          const AppCard(padding: EdgeInsets.zero, child: ThemeModeTile()),
          AppSpacing.gapSm,
          AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              leadingIcon: Icons.logout_rounded,
              title: 'Sign out',
              subtitle: session.user?.fullName,
              showChevron: false,
              onTap: () async {
                final ok = await AppBottomSheet.confirm(context, title: 'Sign out?', message: 'Local data on this device is cleared.', confirmLabel: 'Sign out');
                if (ok) await ref.read(sessionProvider.notifier).logout();
              },
            ),
          ),
          AppSpacing.gapXl,
          Center(
            child: Text('Commission ${vendor.commissionBps / 100}% · vendor id ${vendor.id}',
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
