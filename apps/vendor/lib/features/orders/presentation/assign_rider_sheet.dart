import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/orders_repository.dart';

/// Bottom sheet: pick one of the vendor's riders (online indicator) or
/// auto-assign the nearest online rider. Resolves with the updated delivery.
Future<Delivery?> showAssignRiderSheet(BuildContext context, {required Delivery delivery}) =>
    AppBottomSheet.show<Delivery>(
      context,
      title: 'Assign a rider',
      builder: (_) => _AssignRiderBody(delivery: delivery),
    );

class _AssignRiderBody extends ConsumerStatefulWidget {
  const _AssignRiderBody({required this.delivery});
  final Delivery delivery;

  @override
  ConsumerState<_AssignRiderBody> createState() => _AssignRiderBodyState();
}

class _AssignRiderBodyState extends ConsumerState<_AssignRiderBody> {
  String? _busyId;

  Future<void> _run(String key, Future<Delivery> Function() action) async {
    setState(() => _busyId = key);
    try {
      final d = await action();
      if (mounted) Navigator.of(context).pop(d);
    } catch (e) {
      if (mounted) {
        showError(context, e);
        setState(() => _busyId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final riders = ref.watch(ridersStreamProvider);
    final online = ref.watch(isOnlineProvider);
    final repo = ref.read(ordersRepositoryProvider);
    final theme = Theme.of(context);
    final list = (riders.value ?? const <RiderProfile>[]).where((r) => r.status == RiderStatus.active).toList()
      ..sort((a, b) {
        if (a.isAvailable != b.isAvailable) return a.isAvailable ? -1 : 1;
        if (a.isOnline != b.isOnline) return a.isOnline ? -1 : 1;
        return (a.fullName ?? '').compareTo(b.fullName ?? '');
      });
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          label: 'Auto-assign nearest online rider',
          icon: Icons.near_me_outlined,
          loading: _busyId == 'auto',
          onPressed: online && _busyId == null ? () => _run('auto', () => repo.autoAssign(widget.delivery.id)) : null,
          tooltip: 'You are offline',
          expanded: true,
        ),
        AppSpacing.gapLg,
        Text('Or choose a rider', style: theme.textTheme.labelLarge),
        AppSpacing.gapSm,
        if (riders.isLoading && list.isEmpty)
          const SkeletonList(itemCount: 3, padding: EdgeInsets.zero, shrinkWrap: true)
        else if (list.isEmpty)
          const EmptyState(compact: true, icon: Icons.two_wheeler_outlined, title: 'No active riders', message: 'Approve riders under the Riders tab first.')
        else
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, i) {
                final r = list[i];
                final busy = _busyId == r.id;
                return AppListTile(
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(child: Text((r.fullName ?? 'R').characters.first.toUpperCase())),
                      Positioned(right: -1, bottom: -1, child: OnlineDot(online: r.isOnline)),
                    ],
                  ),
                  title: r.fullName ?? 'Rider ${r.id.substring(r.id.length - 4)}',
                  subtitle: [
                    r.isOnline ? 'Online' : 'Offline · seen ${timeAgo(r.lastSeenAt)}',
                    if (r.currentDeliveryId != null) 'on a delivery',
                    if ((r.vehicleType ?? '').isNotEmpty) r.vehicleType!,
                  ].join(' · '),
                  trailing: busy
                      ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.chevron_right_rounded),
                  enabled: online && _busyId == null,
                  onTap: () => _run(r.id, () => repo.assign(widget.delivery.id, r.id)),
                );
              },
            ),
          ),
      ],
    );
  }
}
