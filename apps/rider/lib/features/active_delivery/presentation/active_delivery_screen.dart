import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/formatters.dart';
import '../../../core/geo.dart';
import '../../../core/launchers.dart';
import '../../deliveries/data/deliveries_providers.dart';
import '../../location/data/location_service.dart';
import '../data/delivery_actions.dart';
import '../data/pending_proof_queue.dart';
import 'proof_sheet.dart';

/// Map + step-by-step flow: navigate to pickup → confirm pickup → navigate to
/// customer → deliver (OTP or photo). Deliver is offline-tolerant.
class ActiveDeliveryScreen extends ConsumerStatefulWidget {
  const ActiveDeliveryScreen({super.key, required this.deliveryId});

  final String deliveryId;

  @override
  ConsumerState<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends ConsumerState<ActiveDeliveryScreen> {
  GoogleMapController? _map;
  bool _busy = false;
  bool _fitted = false;

  @override
  void dispose() {
    _map?.dispose();
    super.dispose();
  }

  Future<void> _fit(Delivery d, RiderLocationUpdate? me) async {
    final map = _map;
    if (map == null) return;
    final points = <LatLng>[
      if (d.pickup != null) LatLng(d.pickup!.lat, d.pickup!.lng),
      if (d.dropoff != null) LatLng(d.dropoff!.lat, d.dropoff!.lng),
      if (me != null) LatLng(me.lat, me.lng),
    ];
    if (points.isEmpty) return;
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

  Future<void> _pickup(Delivery d) async {
    setState(() => _busy = true);
    try {
      await ref.read(deliveryActionsProvider).pickup(d.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pickup confirmed. Head to the customer.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deliver(Delivery d, {required bool online}) async {
    final input = await showProofSheet(context, online: online);
    if (input == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final outcome = await ref.read(deliveryActionsProvider).deliver(
            d.id,
            otp: input.otp,
            photoBytes: input.photoBytes,
            photoContentType: input.photoContentType,
          );
      if (!mounted) return;
      switch (outcome) {
        case Delivered():
          await _celebrate();
        case ProofQueued():
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Proof saved. It will be submitted when you are back online.'),
            duration: Duration(seconds: 4),
          ));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _celebrate() async {
    await AppBottomSheet.show<void>(
      context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmptyState(
            compact: true,
            icon: Icons.celebration_rounded,
            title: 'Delivered!',
            message: 'Nice work. You are ready for the next offer.',
            action: AppButton.primary(label: 'Back to home', onPressed: () => Navigator.of(ctx).pop()),
          ),
        ],
      ),
    );
    if (mounted && context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(deliveryByIdProvider(widget.deliveryId));
    final online = ref.watch(isOnlineProvider);
    final proof = ref.watch(pendingProofProvider(widget.deliveryId)).value;
    final location = ref.watch(riderLocationServiceProvider);
    final scheme = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active delivery'),
        actions: [
          IconButton(
            tooltip: 'Recenter',
            icon: const Icon(Icons.center_focus_strong_outlined),
            onPressed: () {
              final d = async.value;
              if (d != null) _fit(d, location.latest.value);
            },
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(onRetry: () => ref.invalidate(deliveryByIdProvider(widget.deliveryId))),
        data: (d) {
          if (d == null) return const EmptyState(icon: Icons.search_off_rounded, title: 'Delivery not found');
          return ValueListenableBuilder<RiderLocationUpdate?>(
            valueListenable: location.latest,
            builder: (context, me, _) {
              if (!_fitted && _map != null) {
                _fitted = true;
                unawaited(_fit(d, me));
              }
              return Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: _DeliveryMap(
                      delivery: d,
                      me: me,
                      onCreated: (c) {
                        _map = c;
                        _fitted = true;
                        unawaited(_fit(d, me));
                      },
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: AppRadius.lgTop,
                        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
                      ),
                      child: _StepPanel(
                        delivery: d,
                        me: me,
                        online: online,
                        busy: _busy,
                        proof: proof,
                        onPickup: () => _pickup(d),
                        onDeliver: () => _deliver(d, online: online),
                        onRetryProof: () => ref.read(pendingProofQueueProvider).retry(d.id),
                        onDiscardProof: () => ref.read(pendingProofQueueProvider).discard(d.id),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _DeliveryMap extends StatelessWidget {
  const _DeliveryMap({required this.delivery, required this.me, required this.onCreated});
  final Delivery delivery;
  final RiderLocationUpdate? me;
  final void Function(GoogleMapController) onCreated;

  @override
  Widget build(BuildContext context) {
    final d = delivery;
    final initial = d.pickup != null
        ? LatLng(d.pickup!.lat, d.pickup!.lng)
        : d.dropoff != null
            ? LatLng(d.dropoff!.lat, d.dropoff!.lng)
            : const LatLng(6.5244, 3.3792); // Lagos
    final markers = <Marker>{
      if (d.pickup != null)
        Marker(
          markerId: const MarkerId('pickup'),
          position: LatLng(d.pickup!.lat, d.pickup!.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: 'Pickup', snippet: d.pickup!.vendorName ?? d.pickup!.line1),
        ),
      if (d.dropoff != null)
        Marker(
          markerId: const MarkerId('dropoff'),
          position: LatLng(d.dropoff!.lat, d.dropoff!.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Drop-off', snippet: d.dropoff!.addressSnapshot?.oneLine),
        ),
      if (me != null)
        Marker(
          markerId: const MarkerId('me'),
          position: LatLng(me!.lat, me!.lng),
          rotation: me!.heading ?? 0,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'You'),
        ),
    };
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initial, zoom: 14),
      markers: markers,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
      onMapCreated: onCreated,
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    );
  }
}

class _StepPanel extends StatelessWidget {
  const _StepPanel({
    required this.delivery,
    required this.me,
    required this.online,
    required this.busy,
    required this.proof,
    required this.onPickup,
    required this.onDeliver,
    required this.onRetryProof,
    required this.onDiscardProof,
  });

  final Delivery delivery;
  final RiderLocationUpdate? me;
  final bool online;
  final bool busy;
  final PendingProof? proof;
  final VoidCallback onPickup;
  final VoidCallback onDeliver;
  final VoidCallback onRetryProof;
  final VoidCallback onDiscardProof;

  @override
  Widget build(BuildContext context) {
    final d = delivery;
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final status = d.status;
    final step = switch (status) {
      DeliveryStatus.accepted => 0,
      DeliveryStatus.pickedUp => 1,
      DeliveryStatus.delivered => 2,
      _ => -1,
    };
    final phone = d.customerPhone ?? d.dropoff?.addressSnapshot?.phone;
    final target = step == 0 ? d.pickup : null;
    final dropoff = d.dropoff;
    double? distance;
    if (me != null) {
      if (step == 0 && target != null) distance = haversineMeters(me!.lat, me!.lng, target.lat, target.lng);
      if (step == 1 && dropoff != null) distance = haversineMeters(me!.lat, me!.lng, dropoff.lat, dropoff.lng);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
      children: [
        _Stepper(step: step),
        AppSpacing.gapLg,
        Row(
          children: [
            StatusChip.delivery(status),
            const Spacer(),
            if (distance != null)
              Text('${Fmt.distance(distance)} away', style: context.text.labelLarge?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
        AppSpacing.gapMd,
        if (proof != null) ...[
          _ProofStatus(proof: proof!, onRetry: onRetryProof, onDiscard: onDiscardProof),
          AppSpacing.gapMd,
        ],
        if (step == 0) ...[
          Text('Pick up at ${d.pickup?.vendorName ?? 'the vendor'}', style: context.text.titleLarge),
          if (d.pickup?.line1 != null)
            Text(d.pickup!.line1!, style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          if (d.orderNumber != null) ...[
            AppSpacing.gapXs,
            Text('Order #${d.orderNumber}', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          ],
          AppSpacing.gapXl,
          AppButton.secondary(
            label: 'Navigate to pickup',
            icon: Icons.navigation_outlined,
            expanded: true,
            onPressed: d.pickup == null ? null : () => openDirections(lat: d.pickup!.lat, lng: d.pickup!.lng),
          ),
          AppSpacing.gapSm,
          AppButton.primary(
            label: 'Confirm pickup',
            icon: Icons.inventory_2_outlined,
            expanded: true,
            size: AppButtonSize.large,
            loading: busy,
            onPressed: online ? onPickup : null,
            tooltip: 'Confirming pickup needs a connection',
          ),
        ] else if (step == 1) ...[
          Text('Deliver to ${d.customerName ?? 'the customer'}', style: context.text.titleLarge),
          if (dropoff?.addressSnapshot != null)
            Text(dropoff!.addressSnapshot!.oneLine, style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          AppSpacing.gapXl,
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: 'Navigate',
                  icon: Icons.navigation_outlined,
                  onPressed: dropoff == null ? null : () => openDirections(lat: dropoff.lat, lng: dropoff.lng),
                ),
              ),
              if (phone != null) ...[
                AppSpacing.gapSm,
                Expanded(
                  child: AppButton.secondary(
                    label: 'Call',
                    icon: Icons.call_outlined,
                    onPressed: () => callPhone(phone),
                  ),
                ),
              ],
            ],
          ),
          AppSpacing.gapSm,
          AppButton.primary(
            label: proof != null && !proof!.isFailed ? 'Proof queued' : 'Deliver',
            icon: Icons.check_circle_outline_rounded,
            expanded: true,
            size: AppButtonSize.large,
            loading: busy,
            onPressed: proof != null && !proof!.isFailed ? null : onDeliver,
            tooltip: 'Waiting to submit the saved proof',
          ),
          if (!online) ...[
            AppSpacing.gapSm,
            Text(
              'Offline: your proof will be saved and submitted automatically.',
              style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ] else if (step == 2) ...[
          Icon(Icons.check_circle_rounded, color: semantic.success, size: 48),
          AppSpacing.gapSm,
          Text('Delivered', style: context.text.titleLarge, textAlign: TextAlign.center),
          Text('This delivery is complete.', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant), textAlign: TextAlign.center),
          AppSpacing.gapXl,
          AppButton.primary(label: 'Done', expanded: true, onPressed: () => Navigator.of(context).maybePop()),
        ] else ...[
          Text(
            status == DeliveryStatus.failed ? 'This delivery was marked failed.' : 'This delivery is no longer assigned to you.',
            style: context.text.titleMedium,
          ),
          AppSpacing.gapXl,
          AppButton.secondary(label: 'Back', expanded: true, onPressed: () => Navigator.of(context).maybePop()),
        ],
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    const labels = ['Pickup', 'Deliver', 'Done'];
    final scheme = context.colors;
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: AppMotion.normal,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= step ? scheme.primary : scheme.surfaceContainerHighest,
                    borderRadius: AppRadius.pill,
                  ),
                ),
                AppSpacing.gapXs,
                Text(
                  labels[i],
                  style: context.text.labelSmall?.copyWith(
                    color: i <= step ? scheme.onSurface : scheme.onSurfaceVariant,
                    fontWeight: i == step ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (i < labels.length - 1) AppSpacing.gapSm,
        ],
      ],
    );
  }
}

class _ProofStatus extends StatelessWidget {
  const _ProofStatus({required this.proof, required this.onRetry, required this.onDiscard});
  final PendingProof proof;
  final VoidCallback onRetry;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final s = context.semanticColors;
    final failed = proof.isFailed;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: failed ? s.dangerContainer : s.infoContainer, borderRadius: AppRadius.smAll),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(failed ? Icons.error_outline_rounded : Icons.cloud_upload_outlined,
                  color: failed ? s.onDangerContainer : s.onInfoContainer, size: 20),
              AppSpacing.gapSm,
              Expanded(
                child: Text(
                  failed
                      ? 'The server rejected the proof: ${proof.error}'
                      : 'Proof saved ${Fmt.relativeDay(proof.createdAt)}. It will be submitted when you are online.',
                  style: context.text.bodySmall?.copyWith(color: failed ? s.onDangerContainer : s.onInfoContainer),
                ),
              ),
            ],
          ),
          if (failed) ...[
            AppSpacing.gapSm,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onDiscard, style: TextButton.styleFrom(foregroundColor: s.onDangerContainer), child: const Text('Discard')),
                TextButton(onPressed: onRetry, style: TextButton.styleFrom(foregroundColor: s.onDangerContainer), child: const Text('Retry')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
