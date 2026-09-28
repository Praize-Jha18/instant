import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/formatters.dart';
import '../../../core/geo.dart';
import '../../catalog/data/catalog_providers.dart';
import 'order_providers.dart';
import 'tracking_controller.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  GoogleMapController? _map;
  bool _fitted = false;

  @override
  void dispose() {
    _map?.dispose();
    super.dispose();
  }

  Future<void> _fit(List<LatLng> points) async {
    final map = _map;
    if (map == null || points.isEmpty) return;
    if (points.length == 1) {
      await map.animateCamera(CameraUpdate.newLatLngZoom(points.first, 15));
      return;
    }
    var minLat = points.first.latitude, maxLat = points.first.latitude;
    var minLng = points.first.longitude, maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    await map.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)),
      72,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(orderProvider(widget.orderId)).value;
    final subOrders = ref.watch(subOrdersProvider(widget.orderId)).value ?? const <SubOrder>[];
    final vendors = ref.watch(vendorsByIdProvider);
    final tracking = ref.watch(trackingControllerProvider(widget.orderId));
    final controller = ref.read(trackingControllerProvider(widget.orderId).notifier);
    final scheme = context.colors;

    final dropoff = order?.addressSnapshot;
    final dropoffLatLng = dropoff == null ? null : LatLng(dropoff.lat, dropoff.lng);
    final markers = <Marker>{
      if (dropoffLatLng != null)
        Marker(
          markerId: const MarkerId('dropoff'),
          position: dropoffLatLng,
          infoWindow: InfoWindow(title: 'Delivery address', snippet: dropoff?.oneLine),
        ),
      for (final s in subOrders)
        if (vendors[s.vendorId]?.address case final a?)
          Marker(
            markerId: MarkerId('vendor-${s.vendorId}'),
            position: LatLng(a.lat, a.lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(title: vendors[s.vendorId]?.name),
          ),
      for (final r in tracking.riders.values)
        Marker(
          markerId: MarkerId('rider-${r.deliveryId}'),
          position: LatLng(r.lat, r.lng),
          rotation: r.heading ?? 0,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: 'Rider', snippet: 'Updated ${formatRelative(r.at)}'),
        ),
    };

    ref.listen(trackingControllerProvider(widget.orderId), (_, next) {
      if (!_fitted && next.riders.isNotEmpty && dropoffLatLng != null) {
        _fitted = true;
        _fit([dropoffLatLng, for (final r in next.riders.values) LatLng(r.lat, r.lng)]);
      }
    });

    final center = dropoffLatLng ?? LatLng(kDefaultMapCenter.lat, kDefaultMapCenter.lng);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track order'),
        actions: [
          IconButton(tooltip: 'Refresh', onPressed: controller.poll, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: center, zoom: 14),
                  markers: markers,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (c) {
                    _map = c;
                    if (dropoffLatLng != null) _fit([dropoffLatLng, ...tracking.riders.values.map((r) => LatLng(r.lat, r.lng))]);
                  },
                ),
                if (tracking.loading)
                  const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator(minHeight: 2)),
                if (tracking.riders.isEmpty && !tracking.loading)
                  Positioned(
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    top: AppSpacing.md,
                    child: Material(
                      color: scheme.surface,
                      borderRadius: AppRadius.smAll,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Icon(tracking.error == 'offline' ? Icons.wifi_off_rounded : Icons.info_outline_rounded,
                                size: 18, color: scheme.onSurfaceVariant),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                tracking.error == 'offline'
                                    ? 'You are offline. Live tracking resumes when you reconnect.'
                                    : 'No rider on the way yet. We will show them here as soon as they pick up.',
                                style: context.text.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Material(
            color: scheme.surface,
            elevation: 8,
            shadowColor: Colors.black26,
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView(
                  shrinkWrap: true,
                  padding: AppSpacing.page,
                  children: [
                    for (final s in subOrders)
                      _SubOrderRow(
                        subOrder: s,
                        vendorName: s.vendorName ?? vendors[s.vendorId]?.name,
                        tracking: tracking.tracking?.subOrders.where((t) => t.subOrderId == s.id).firstOrNull,
                        rider: s.deliveryId == null ? null : tracking.riders[s.deliveryId!],
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

class _SubOrderRow extends StatelessWidget {
  const _SubOrderRow({required this.subOrder, required this.vendorName, required this.tracking, required this.rider});
  final SubOrder subOrder;
  final String? vendorName;
  final SubOrderTracking? tracking;
  final RiderPoint? rider;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final status = tracking?.status ?? subOrder.status;
    final phone = tracking?.riderPhone;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: AppRadius.smAll),
            child: Icon(
              status == SubOrderStatus.outForDelivery ? Icons.delivery_dining_rounded : Icons.storefront_outlined,
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vendorName ?? 'Vendor', style: context.text.titleSmall),
                Text(
                  [
                    if (tracking?.riderName != null) tracking!.riderName!,
                    if (rider != null) 'seen ${formatRelative(rider!.at)}',
                    if (tracking?.deliveryStatus != null) StatusChip.deliveryLabel(tracking!.deliveryStatus!),
                  ].join(' · '),
                  style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusChip.subOrder(status, dense: true),
          if (phone != null && phone.isNotEmpty)
            IconButton(
              tooltip: 'Call rider',
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: phone)),
              icon: const Icon(Icons.call_outlined),
            ),
        ],
      ),
    );
  }
}
