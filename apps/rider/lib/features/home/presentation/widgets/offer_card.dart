import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config.dart';
import '../../../../core/formatters.dart';
import '../../../../core/geo.dart';
import '../../../auth/data/rider_profile_provider.dart';
import '../../domain/offer_countdown.dart';

/// A delivery offer with accept/decline and a live countdown.
class OfferCard extends ConsumerStatefulWidget {
  const OfferCard({
    super.key,
    required this.delivery,
    required this.online,
    required this.onAccept,
    required this.onDecline,
    this.hasActive = false,
  });

  final Delivery delivery;
  final bool online;
  final bool hasActive;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  ConsumerState<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends ConsumerState<OfferCard> {
  Timer? _timer;
  DateTime _now = DateTime.now().toUtc();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now().toUtc());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _run(VoidCallback action) async {
    setState(() => _busy = true);
    try {
      action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.delivery;
    final isMe = ref.watch(riderIdMatcherProvider);
    final offeredAt = OfferCountdown.offeredAt(d, isMe) ?? d.updatedAt ?? _now;
    final remaining = OfferCountdown.remaining(offeredAt: offeredAt, now: _now);
    final progress = OfferCountdown.progress(offeredAt: offeredAt, now: _now);
    final expired = remaining == Duration.zero;
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final urgent = remaining < const Duration(seconds: 15);

    final pickup = d.pickup;
    final drop = d.dropoff;
    double? distance;
    if (pickup != null && drop != null) {
      distance = haversineMeters(pickup.lat, pickup.lng, drop.lat, drop.lng);
    }

    final disabledReason = !widget.online
        ? 'Responding to offers needs a connection'
        : expired
            ? 'This offer has expired'
            : widget.hasActive
                ? 'Finish your current delivery first'
                : null;
    final canRespond = disabledReason == null && !_busy;

    return AppCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_rounded, color: scheme.primary, size: 20),
              AppSpacing.gapSm,
              Text('New delivery offer', style: context.text.titleMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: expired
                      ? scheme.surfaceContainerHighest
                      : urgent
                          ? semantic.dangerContainer
                          : semantic.warningContainer,
                  borderRadius: AppRadius.pill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 14,
                        color: expired
                            ? scheme.onSurfaceVariant
                            : urgent
                                ? semantic.onDangerContainer
                                : semantic.onWarningContainer),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      expired ? 'Expired' : Fmt.countdown(remaining),
                      style: context.text.labelLarge?.copyWith(
                        fontFeatures: AppTypography.tabularFigures,
                        color: expired
                            ? scheme.onSurfaceVariant
                            : urgent
                                ? semantic.onDangerContainer
                                : semantic.onWarningContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          ClipRRect(
            borderRadius: AppRadius.pill,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progress),
              duration: AppMotion.slow,
              curve: AppMotion.curve,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 4,
                color: urgent ? semantic.danger : scheme.primary,
              ),
            ),
          ),
          AppSpacing.gapLg,
          _Leg(icon: Icons.storefront_outlined, label: 'Pickup', text: pickup?.vendorName ?? pickup?.line1 ?? 'Vendor'),
          AppSpacing.gapSm,
          _Leg(
            icon: Icons.location_on_outlined,
            label: 'Drop-off',
            text: drop?.addressSnapshot?.oneLine ?? 'Customer address',
          ),
          if (distance != null || d.orderNumber != null) ...[
            AppSpacing.gapMd,
            Row(
              children: [
                if (d.orderNumber != null) ...[
                  Icon(Icons.receipt_long_outlined, size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Text('#${d.orderNumber}', style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  AppSpacing.gapLg,
                ],
                if (distance != null) ...[
                  Icon(Icons.straighten_rounded, size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Text('~${Fmt.distance(distance)} trip', style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ],
            ),
          ],
          AppSpacing.gapLg,
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: 'Decline',
                  onPressed: canRespond ? () => _run(widget.onDecline) : null,
                  tooltip: disabledReason,
                ),
              ),
              AppSpacing.gapMd,
              Expanded(
                flex: 2,
                child: AppButton.primary(
                  label: 'Accept',
                  icon: Icons.check_rounded,
                  loading: _busy,
                  onPressed: canRespond ? () => _run(widget.onAccept) : null,
                  tooltip: disabledReason,
                ),
              ),
            ],
          ),
          if (disabledReason != null && !expired) ...[
            AppSpacing.gapSm,
            Text(disabledReason, style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ],
          if (expired) ...[
            AppSpacing.gapSm,
            Text(
              'Offers stay open for ${AppConfig.offerWindow.inSeconds}s. Pull to refresh to check its status.',
              style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _Leg extends StatelessWidget {
  const _Leg({required this.icon, required this.label, required this.text});
  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: scheme.onSurfaceVariant),
        AppSpacing.gapSm,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.text.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
              Text(text, style: context.text.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
