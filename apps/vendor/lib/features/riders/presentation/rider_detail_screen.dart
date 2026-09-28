import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/rider_locations.dart';
import '../data/riders_repository.dart';

class RiderDetailScreen extends ConsumerStatefulWidget {
  const RiderDetailScreen({super.key, required this.riderId});

  final String riderId;

  @override
  ConsumerState<RiderDetailScreen> createState() => _RiderDetailScreenState();
}

class _RiderDetailScreenState extends ConsumerState<RiderDetailScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() f, String done) async {
    setState(() => _busy = true);
    try {
      await f();
      if (mounted) showSnack(context, done);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rider = ref.watch(riderStreamProvider(widget.riderId));
    final deliveries = ref.watch(deliveriesStreamProvider).value ?? const <Delivery>[];
    final position = ref.watch(riderLocationsProvider)[widget.riderId];
    final online = ref.watch(isOnlineProvider);
    final api = ref.watch(apiClientProvider);
    final repo = ref.read(ridersRepositoryProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppPage(
      title: rider.value?.fullName ?? 'Rider',
      body: rider.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorState(message: errorMessage(e)),
        data: (r) {
          if (r == null) return const EmptyState(icon: Icons.two_wheeler_outlined, title: 'Rider not found');
          final recent = deliveries.where((d) => d.riderId == r.id).take(20).toList();
          final profile = AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(clipBehavior: Clip.none, children: [
                      CircleAvatar(radius: 28, child: Text((r.fullName ?? 'R').characters.first.toUpperCase())),
                      Positioned(right: -1, bottom: -1, child: OnlineDot(online: r.isOnline, size: 14)),
                    ]),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.fullName ?? 'Rider', style: theme.textTheme.titleLarge),
                          Text(r.isOnline ? 'Online now' : 'Last seen ${timeAgo(r.lastSeenAt)}',
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    StatusChip.rider(r.status),
                  ],
                ),
                const Divider(height: AppSpacing.xl),
                DetailRow(label: 'Phone', value: r.phone ?? '—'),
                DetailRow(label: 'Vehicle', value: [r.vehicleType, r.plateNumber].where((s) => (s ?? '').isNotEmpty).join(' · ').ifEmpty('—')),
                DetailRow(label: 'Current delivery', value: r.currentDeliveryId == null ? 'None' : '#${r.currentDeliveryId!.substring(r.currentDeliveryId!.length - 6)}'),
                DetailRow(
                    label: 'Position',
                    value: position == null
                        ? 'Unknown'
                        : '${position.lat.toStringAsFixed(5)}, ${position.lng.toStringAsFixed(5)} · ${timeAgo(position.at)}'),
                DetailRow(label: 'Joined', value: formatDate(r.createdAt)),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (r.status != RiderStatus.active)
                      AppButton.primary(
                        label: 'Approve rider',
                        icon: Icons.check_rounded,
                        loading: _busy,
                        onPressed: online ? () => _run(() => repo.approve(r.id), 'Rider approved') : null,
                        tooltip: 'You are offline',
                      ),
                    if (r.status == RiderStatus.active)
                      AppButton.danger(
                        label: 'Suspend rider',
                        icon: Icons.pause_rounded,
                        loading: _busy,
                        onPressed: online
                            ? () async {
                                final ok = await AppBottomSheet.confirm(context,
                                    title: 'Suspend ${r.fullName ?? 'this rider'}?',
                                    message: 'They will stop receiving delivery offers.',
                                    confirmLabel: 'Suspend',
                                    destructive: true);
                                if (ok) await _run(() => repo.suspend(r.id), 'Rider suspended');
                              }
                            : null,
                        tooltip: 'You are offline',
                      ),
                  ],
                ),
              ],
            ),
          );

          final documents = AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Documents', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                if (r.documents.isEmpty)
                  Text('No documents uploaded', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant))
                else
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (final d in r.documents)
                        SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => showDialog<void>(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: AppImage(url: api.catalog.imageUrl(d.imageId), fit: BoxFit.contain, borderRadius: AppRadius.lgAll),
                                  ),
                                ),
                                child: AppImage(url: api.catalog.imageUrl(d.imageId, thumb: true), aspectRatio: 1.4, heroTag: 'doc-${d.imageId}'),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(titleCase(d.type), style: theme.textTheme.labelMedium),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          );

          final recentCard = AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent deliveries', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                if (recent.isEmpty)
                  Text('No deliveries yet', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant))
                else
                  for (final d in recent)
                    AppListTile(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      dense: true,
                      leadingIcon: Icons.local_shipping_outlined,
                      title: '#${d.orderNumber ?? d.subOrderId.substring(d.subOrderId.length - 6)} · ${d.customerName ?? ''}',
                      subtitle: '${d.dropoff?.addressSnapshot?.oneLine ?? 'Drop-off'} · ${timeAgo(d.updatedAt)}',
                      trailing: StatusChip.delivery(d.status, dense: true),
                      showChevron: false,
                    ),
              ],
            ),
          );

          return SingleChildScrollView(
            padding: AppSpacing.page,
            child: TwoPane(
              primary: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [profile, AppSpacing.gapLg, recentCard]),
              secondary: documents,
            ),
          );
        },
      ),
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
