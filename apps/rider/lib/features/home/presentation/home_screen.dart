import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/redirect.dart';
import '../../../core/errors.dart';
import '../../active_delivery/data/delivery_actions.dart';
import '../../auth/data/auth_controller.dart';
import '../../auth/data/rider_profile_provider.dart';
import '../../deliveries/data/deliveries_providers.dart';
import '../../location/data/location_permission.dart';
import '../../location/data/location_service.dart';
import '../data/online_controller.dart';
import 'widgets/active_delivery_card.dart';
import 'widgets/offer_card.dart';
import 'widgets/online_toggle.dart';
import 'widgets/today_summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _toggleOnline(BuildContext context, WidgetRef ref, bool value) async {
    if (value) {
      final access = await ref.read(locationPermissionGateProvider).check();
      if (!access.canTrack && context.mounted) {
        final result = await context.push<LocationAccess?>(Routes.locationPermission);
        if (!(result?.canTrack ?? false)) return;
      }
    }
    if (!context.mounted) return;
    try {
      final change = await ref.read(onlineControllerProvider.notifier).setOnline(value);
      if (!context.mounted) return;
      if (change == OnlineChange.queued) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value ? 'You are offline: going online will sync when you reconnect.' : 'Saved. Will sync when you reconnect.'),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
      }
    }
  }

  Future<void> _respond(BuildContext context, WidgetRef ref, Delivery d, bool accept) async {
    try {
      final updated = await ref.read(deliveryActionsProvider).respond(d.id, accept: accept);
      if (!context.mounted) return;
      if (accept) {
        context.push(Routes.active(updated.id));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Offer declined')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profile = ref.watch(currentRiderProfileProvider);
    final online = ref.watch(isOnlineProvider);
    final busy = ref.watch(onlineControllerProvider);
    final offers = ref.watch(offeredDeliveriesProvider);
    final active = ref.watch(activeDeliveryProvider);
    final summary = ref.watch(todaySummaryProvider);
    final deliveriesAsync = ref.watch(myDeliveriesProvider);
    final locationService = ref.watch(riderLocationServiceProvider);
    final scheme = context.colors;

    final firstName = (user?.fullName ?? '').split(' ').first;

    return Scaffold(
      appBar: AppBar(
        title: Text(firstName.isEmpty ? 'Home' : 'Hi, $firstName'),
        actions: [
          ValueListenableBuilder<TrackingState>(
            valueListenable: locationService.state,
            builder: (context, state, _) {
              final (icon, color, tip) = switch (state) {
                TrackingState.tracking => (Icons.gps_fixed_rounded, context.semanticColors.success, 'Sharing location'),
                TrackingState.permissionDenied => (Icons.gps_off_rounded, context.semanticColors.warning, 'Location permission needed'),
                TrackingState.serviceDisabled => (Icons.location_disabled_rounded, context.semanticColors.warning, 'Location services off'),
                TrackingState.error => (Icons.gps_not_fixed_rounded, context.semanticColors.danger, 'Location error'),
                TrackingState.idle => (Icons.gps_not_fixed_rounded, scheme.onSurfaceVariant, 'Location idle'),
              };
              return IconButton(
                tooltip: tip,
                icon: Icon(icon, color: color),
                onPressed: state == TrackingState.permissionDenied || state == TrackingState.serviceDisabled
                    ? () => context.push(Routes.locationPermission)
                    : null,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(syncEngineProvider).pull(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
          children: [
            FadeSlideIn(
              child: OnlineToggle(
                isOnline: profile?.isOnline ?? false,
                busy: busy,
                enabled: profile != null && profile.status == RiderStatus.active,
                onChanged: (v) => _toggleOnline(context, ref, v),
              ),
            ),
            AppSpacing.gapLg,
            FadeSlideIn(delay: AppMotion.stagger, child: TodaySummaryCard(summary: summary)),
            if (active != null) ...[
              const SectionHeader(title: 'Current delivery', padding: EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm)),
              FadeSlideIn(
                delay: AppMotion.stagger * 2,
                child: ActiveDeliveryCard(delivery: active, onOpen: () => context.push(Routes.active(active.id))),
              ),
            ],
            SectionHeader(
              title: 'Offers',
              subtitle: offers.isEmpty ? null : '${offers.length} waiting for your answer',
              padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
            ),
            if (deliveriesAsync.isLoading && offers.isEmpty)
              const SkeletonList(itemCount: 2, padding: EdgeInsets.zero, shrinkWrap: true)
            else if (offers.isEmpty)
              AppCard(
                child: EmptyState(
                  compact: true,
                  icon: (profile?.isOnline ?? false) ? Icons.notifications_active_outlined : Icons.power_settings_new_rounded,
                  title: (profile?.isOnline ?? false) ? 'No offers right now' : 'You are offline',
                  message: (profile?.isOnline ?? false)
                      ? 'New deliveries from your vendor will show up here.'
                      : 'Go online to receive delivery offers from your vendor.',
                ),
              )
            else
              for (var i = 0; i < offers.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: FadeSlideIn.staggered(
                    index: i,
                    child: OfferCard(
                      delivery: offers[i],
                      online: online,
                      hasActive: active != null,
                      onAccept: () => _respond(context, ref, offers[i], true),
                      onDecline: () => _respond(context, ref, offers[i], false),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
