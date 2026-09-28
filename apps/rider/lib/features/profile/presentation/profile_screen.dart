import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/errors.dart';
import '../../active_delivery/data/pending_proof_queue.dart';
import '../../auth/data/auth_controller.dart';
import '../../auth/data/rider_profile_provider.dart';
import '../../auth/presentation/register_screen.dart' show kVehicleTypes;
import '../data/vendor_lookup.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editVehicle(BuildContext context, WidgetRef ref, RiderProfile profile) async {
    final result = await AppBottomSheet.show<(String?, String?)>(
      context,
      title: 'Vehicle details',
      builder: (_) => _VehicleForm(profile: profile),
    );
    if (result == null || !context.mounted) return;
    final (vehicle, plate) = result;
    final api = ref.read(apiClientProvider);
    final store = ref.read(localStoreProvider);
    final engine = ref.read(syncEngineProvider);
    try {
      try {
        final updated = await api.rider.updateProfile(UpdateRiderProfileRequest(vehicleType: vehicle, plateNumber: plate));
        await store.upsert(Collections.riderProfiles, updated);
      } on ApiException catch (e) {
        if (!e.isOffline) rethrow;
        await engine.enqueueUpsert(Collections.riderProfiles, profile.copyWith(vehicleType: vehicle, plateNumber: plate));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved. Will sync when you reconnect.')));
        }
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final pending = ref.read(syncStatusProvider).value?.pendingCount ?? 0;
    final proofs = ref.read(pendingProofsProvider).value?.length ?? 0;
    final ok = await AppBottomSheet.confirm(
      context,
      title: 'Sign out?',
      message: pending + proofs > 0
          ? 'You have ${pending + proofs} unsynced change${pending + proofs == 1 ? '' : 's'}. They will be lost if you sign out now.'
          : 'You will stop receiving offers until you sign in again.',
      confirmLabel: 'Sign out',
      destructive: true,
    );
    if (ok) await ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profile = ref.watch(currentRiderProfileProvider);
    final vendorName = ref.watch(vendorNameProvider(profile?.vendorId ?? user?.vendorId));
    final mode = ref.watch(themeModeProvider);
    final proofs = ref.watch(pendingProofsProvider).value ?? const [];
    final api = ref.watch(apiClientProvider);
    final scheme = context.colors;
    final initials = (user?.fullName ?? '?')
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: AppSpacing.page,
        children: [
          FadeSlideIn(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  backgroundImage: user?.avatarImageId != null
                      ? NetworkImage(api.catalog.imageUrl(user!.avatarImageId!, thumb: true))
                      : null,
                  child: user?.avatarImageId == null ? Text(initials, style: context.text.titleLarge) : null,
                ),
                AppSpacing.gapLg,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.fullName ?? 'Rider', style: context.text.titleLarge),
                      Text(user?.email ?? '', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                      if ((profile?.phone ?? user?.phone) != null)
                        Text(profile?.phone ?? user!.phone!, style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                      if (profile != null) ...[
                        AppSpacing.gapSm,
                        Row(
                          children: [
                            StatusChip.rider(profile.status, dense: true),
                            AppSpacing.gapSm,
                            StatusChip(
                              label: profile.isOnline ? 'Online' : 'Offline',
                              tone: profile.isOnline ? StatusTone.success : StatusTone.neutral,
                              dense: true,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Vendor', padding: EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm)),
          FadeSlideIn(
            delay: AppMotion.stagger,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: AppListTile(
                leadingIcon: Icons.storefront_outlined,
                title: vendorName.when(
                  data: (n) => n ?? 'Your vendor',
                  loading: () => 'Loading…',
                  error: (_, _) => 'Your vendor',
                ),
                subtitle: profile?.vendorId != null ? 'Vendor ID ${profile!.vendorId}' : null,
                showChevron: false,
              ),
            ),
          ),
          const SectionHeader(title: 'Vehicle', padding: EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm)),
          FadeSlideIn(
            delay: AppMotion.stagger * 2,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: AppListTile(
                leadingIcon: Icons.two_wheeler_outlined,
                title: profile?.vehicleType ?? 'Add your vehicle',
                subtitle: profile?.plateNumber ?? 'Plate number not set',
                trailing: const Icon(Icons.edit_outlined),
                onTap: profile == null ? null : () => _editVehicle(context, ref, profile),
              ),
            ),
          ),
          const SectionHeader(title: 'Documents', padding: EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm)),
          FadeSlideIn(
            delay: AppMotion.stagger * 3,
            child: AppCard(
              child: (profile?.documents.isEmpty ?? true)
                  ? Row(
                      children: [
                        Icon(Icons.badge_outlined, color: scheme.onSurfaceVariant),
                        AppSpacing.gapMd,
                        Expanded(
                          child: Text(
                            'No documents on file. Your vendor adds identity documents from their dashboard.',
                            style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    )
                  : Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: [
                        for (final doc in profile!.documents)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppImage(url: api.catalog.imageUrl(doc.imageId, thumb: true), width: 96, height: 72),
                              AppSpacing.gapXs,
                              Text(doc.type, style: context.text.labelSmall),
                            ],
                          ),
                      ],
                    ),
            ),
          ),
          if (proofs.isNotEmpty) ...[
            const SectionHeader(title: 'Pending proofs', padding: EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm)),
            AppCard(
              padding: EdgeInsets.zero,
              child: AppListTile(
                leadingIcon: Icons.cloud_upload_outlined,
                title: '${proofs.length} proof${proofs.length == 1 ? '' : 's'} waiting to upload',
                subtitle: proofs.any((p) => p.isFailed) ? 'Some were rejected. Open the delivery to retry.' : 'Submitted automatically when online.',
                trailing: TextButton(
                  onPressed: () => ref.read(pendingProofQueueProvider).flush(),
                  child: const Text('Retry now'),
                ),
              ),
            ),
          ],
          const SectionHeader(title: 'Appearance', padding: EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm)),
          FadeSlideIn(
            delay: AppMotion.stagger * 4,
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto_outlined), label: Text('System')),
                ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_outlined), label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_outlined), label: Text('Dark')),
              ],
              selected: {mode},
              onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
            ),
          ),
          AppSpacing.gapXxl,
          AppButton.danger(
            label: 'Sign out',
            icon: Icons.logout_rounded,
            expanded: true,
            onPressed: () => _logout(context, ref),
          ),
          AppSpacing.gapLg,
          Text(
            'Instant Rider',
            textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _VehicleForm extends StatefulWidget {
  const _VehicleForm({required this.profile});
  final RiderProfile profile;

  @override
  State<_VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<_VehicleForm> {
  late String? _vehicle = kVehicleTypes.contains(widget.profile.vehicleType) ? widget.profile.vehicleType : kVehicleTypes.first;
  late final _plate = TextEditingController(text: widget.profile.plateNumber ?? '');

  @override
  void dispose() {
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _vehicle,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.two_wheeler_outlined)),
            items: [for (final t in kVehicleTypes) DropdownMenuItem(value: t, child: Text(t))],
            onChanged: (v) => setState(() => _vehicle = v),
          ),
          AppSpacing.gapLg,
          AppTextField(
            controller: _plate,
            label: 'Plate number',
            hint: 'ABC-123-XY',
            prefixIcon: Icons.pin_outlined,
            textCapitalization: TextCapitalization.characters,
          ),
          AppSpacing.gapXl,
          AppButton.primary(
            label: 'Save',
            onPressed: () => Navigator.of(context).pop((
              _vehicle,
              _plate.text.trim().isEmpty ? null : _plate.text.trim().toUpperCase(),
            )),
          ),
        ],
      );
}
