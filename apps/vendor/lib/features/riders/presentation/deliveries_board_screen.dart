import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/location_picker.dart';
import '../../orders/presentation/assign_rider_sheet.dart';
import '../data/rider_locations.dart';
import '../data/riders_repository.dart';

/// Map of online riders' last known locations plus the list of active
/// deliveries with assignment actions.
class DeliveriesBoardScreen extends ConsumerStatefulWidget {
  const DeliveriesBoardScreen({super.key});

  @override
  ConsumerState<DeliveriesBoardScreen> createState() => _DeliveriesBoardScreenState();
}

class _DeliveriesBoardScreenState extends ConsumerState<DeliveriesBoardScreen> {
  GoogleMapController? _map;
  bool _showDone = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        await ref.read(ridersRepositoryProvider).refresh();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _map?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveries = ref.watch(deliveriesStreamProvider);
    final riders = ref.watch(ridersStreamProvider).value ?? const <RiderProfile>[];
    final positions = ref.watch(riderLocationsProvider);
    final vendor = ref.watch(sessionProvider.select((s) => s.vendor));
    final theme = Theme.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final ridersById = {for (final r in riders) r.id: r};
    final markers = <Marker>{};
    for (final p in positions.values) {
      final r = ridersById[p.riderId];
      if (r != null && !r.isOnline) continue;
      markers.add(Marker(
        markerId: MarkerId('rider-${p.riderId}'),
        position: LatLng(p.lat, p.lng),
        rotation: p.heading ?? 0,
        infoWindow: InfoWindow(title: r?.fullName ?? 'Rider', snippet: 'Updated ${timeAgo(p.at)}'),
      ));
    }
    if (vendor?.address != null) {
      markers.add(Marker(
        markerId: const MarkerId('store'),
        position: LatLng(vendor!.address!.lat, vendor.address!.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: vendor.name),
      ));
    }
    final center = positions.values.firstOrNull;
    final initial = center != null
        ? LatLng(center.lat, center.lng)
        : vendor?.address != null
            ? LatLng(vendor!.address!.lat, vendor.address!.lng)
            : LatLng(defaultMapCenter.lat, defaultMapCenter.lng);

    final map = ClipRRect(
      borderRadius: AppRadius.mdAll,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: initial, zoom: 12),
            markers: markers,
            onMapCreated: (c) => _map = c,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            left: AppSpacing.md,
            top: AppSpacing.md,
            child: Material(
              color: theme.colorScheme.surface,
              borderRadius: AppRadius.pill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const OnlineDot(online: true),
                    const SizedBox(width: AppSpacing.sm),
                    Text('${riders.where((r) => r.isOnline).length} online · ${markers.length - (vendor?.address != null ? 1 : 0)} located',
                        style: theme.textTheme.labelMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final list = deliveries.when(
      loading: () => const SkeletonList(),
      error: (e, _) => ErrorState(message: errorMessage(e)),
      data: (all) {
        final active = all.where((d) => _showDone || !d.status.isTerminal).toList();
        return RefreshIndicator(
          onRefresh: () => refreshCollections(ref, const [Collections.deliveries, Collections.riderProfiles]),
          child: ListView(
            padding: AppSpacing.page,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Deliveries', style: theme.textTheme.titleMedium)),
                  FilterChip(label: const Text('Show completed'), selected: _showDone, onSelected: (v) => setState(() => _showDone = v)),
                ],
              ),
              AppSpacing.gapSm,
              if (active.isEmpty)
                const EmptyState(compact: true, icon: Icons.local_shipping_outlined, title: 'No active deliveries', message: 'Deliveries are created when an order is marked ready.')
              else
                for (final (i, d) in active.indexed)
                  FadeSlideIn.staggered(
                    index: i,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _DeliveryTile(
                        delivery: d,
                        rider: d.riderId == null ? null : ridersById[d.riderId],
                        position: d.riderId == null ? null : positions[d.riderId],
                        onFocus: (p) => _map?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(p.lat, p.lng), 15)),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );

    return AppPage(
      title: 'Deliveries',
      actions: [
        IconButton(tooltip: 'Riders', icon: const Icon(Icons.two_wheeler_outlined), onPressed: () => context.go('/riders')),
      ],
      body: wide
          ? Padding(
              padding: AppSpacing.page,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 3, child: map),
                  AppSpacing.gapLg,
                  Expanded(flex: 2, child: list),
                ],
              ),
            )
          : Column(
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0), child: SizedBox(height: 260, child: map)),
                Expanded(child: list),
              ],
            ),
    );
  }
}

class _DeliveryTile extends ConsumerWidget {
  const _DeliveryTile({required this.delivery, required this.rider, required this.position, required this.onFocus});

  final Delivery delivery;
  final RiderProfile? rider;
  final RiderPosition? position;
  final ValueChanged<RiderPosition> onFocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final online = ref.watch(isOnlineProvider);
    final d = delivery;
    final canAssign = d.status == DeliveryStatus.unassigned || d.status == DeliveryStatus.offered;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => context.go('/orders/${d.subOrderId}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('#${d.orderNumber ?? d.subOrderId.substring(d.subOrderId.length - 6)} · ${d.customerName ?? 'Customer'}',
                    style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              StatusChip.delivery(d.status, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(d.dropoff?.addressSnapshot?.oneLine ?? 'Drop-off pending',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (rider != null) ...[
                OnlineDot(online: rider!.isOnline),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(rider!.fullName ?? 'Rider', style: theme.textTheme.bodySmall)),
              ] else
                Expanded(child: Text('No rider', style: theme.textTheme.bodySmall)),
              if (position != null)
                TextButton.icon(
                  onPressed: () => onFocus(position!),
                  icon: const Icon(Icons.my_location, size: 16),
                  label: Text(timeAgo(position!.at)),
                ),
              if (canAssign)
                AppButton.secondary(
                  label: 'Assign',
                  size: AppButtonSize.small,
                  onPressed: online ? () => showAssignRiderSheet(context, delivery: d) : null,
                  tooltip: 'You are offline',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
