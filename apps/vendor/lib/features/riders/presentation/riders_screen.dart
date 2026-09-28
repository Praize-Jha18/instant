import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/riders_repository.dart';

class RidersScreen extends ConsumerStatefulWidget {
  const RidersScreen({super.key});

  @override
  ConsumerState<RidersScreen> createState() => _RidersScreenState();
}

class _RidersScreenState extends ConsumerState<RidersScreen> {
  RiderStatus? _filter;

  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  Future<void> _refresh() async {
    try {
      await ref.read(ridersRepositoryProvider).refresh();
    } catch (_) {
      await refreshCollections(ref, const [Collections.riderProfiles]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final riders = ref.watch(ridersStreamProvider);
    return AppPage(
      title: 'Riders',
      actions: [
        IconButton(tooltip: 'Deliveries map', icon: const Icon(Icons.map_outlined), onPressed: () => context.go('/deliveries')),
        IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: _refresh),
      ],
      body: riders.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
        data: (all) {
          final counts = <RiderStatus, int>{};
          for (final r in all) {
            counts[r.status] = (counts[r.status] ?? 0) + 1;
          }
          final list = (_filter == null ? all : all.where((r) => r.status == _filter).toList())
            ..sort((a, b) {
              if (a.status != b.status) return a.status == RiderStatus.pending ? -1 : (b.status == RiderStatus.pending ? 1 : 0);
              if (a.isOnline != b.isOnline) return a.isOnline ? -1 : 1;
              return (a.fullName ?? '').compareTo(b.fullName ?? '');
            });
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: FilterChips<RiderStatus>(
                  options: RiderStatus.values,
                  selected: _filter,
                  counts: counts,
                  labelOf: (s) => titleCase(s.json),
                  onSelected: (s) => setState(() => _filter = s),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: list.isEmpty
                      ? ListView(children: const [
                          SizedBox(height: 80),
                          EmptyState(
                            icon: Icons.two_wheeler_outlined,
                            title: 'No riders',
                            message: 'Riders register with your vendor id in the rider app and appear here for approval.',
                          ),
                        ])
                      : LayoutBuilder(
                          builder: (context, c) {
                            final columns = c.maxWidth >= 900 ? 2 : 1;
                            return GridView.builder(
                              padding: AppSpacing.page,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisExtent: 92,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.sm,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, i) => FadeSlideIn.staggered(index: i, child: RiderTile(rider: list[i])),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RiderTile extends ConsumerWidget {
  const RiderTile({super.key, required this.rider, this.showActions = true});

  final RiderProfile rider;
  final bool showActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider);
    final repo = ref.read(ridersRepositoryProvider);
    Future<void> run(Future<void> Function() f, String done) async {
      try {
        await f();
        if (context.mounted) showSnack(context, done);
      } catch (e) {
        if (context.mounted) showError(context, e);
      }
    }

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      onTap: () => context.go('/riders/${rider.id}'),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(radius: 22, child: Text((rider.fullName ?? 'R').characters.first.toUpperCase())),
              Positioned(right: -1, bottom: -1, child: OnlineDot(online: rider.isOnline, size: 12)),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(rider.fullName ?? 'Rider ${rider.id.substring(rider.id.length - 4)}',
                          style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    StatusChip.rider(rider.status, dense: true),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  [
                    rider.isOnline ? 'Online' : 'Last seen ${timeAgo(rider.lastSeenAt)}',
                    if ((rider.vehicleType ?? '').isNotEmpty) rider.vehicleType!,
                    if ((rider.plateNumber ?? '').isNotEmpty) rider.plateNumber!,
                    if (rider.currentDeliveryId != null) 'on delivery',
                  ].join(' · '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showActions) ...[
            const SizedBox(width: AppSpacing.sm),
            if (rider.status != RiderStatus.active)
              IconButton(
                tooltip: online ? 'Approve' : 'You are offline',
                icon: Icon(Icons.check_circle_outline, color: context.semanticColors.success),
                onPressed: online ? () => run(() => repo.approve(rider.id), 'Rider approved') : null,
              ),
            if (rider.status == RiderStatus.active)
              IconButton(
                tooltip: online ? 'Suspend' : 'You are offline',
                icon: Icon(Icons.pause_circle_outline, color: context.semanticColors.warning),
                onPressed: online ? () => run(() => repo.suspend(rider.id), 'Rider suspended') : null,
              ),
          ],
        ],
      ),
    );
  }
}
