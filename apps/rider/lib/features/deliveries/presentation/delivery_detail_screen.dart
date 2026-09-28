import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/redirect.dart';
import '../../../core/formatters.dart';
import '../../../core/launchers.dart';
import '../../active_delivery/data/pending_proof_queue.dart';
import '../data/deliveries_providers.dart';

class DeliveryDetailScreen extends ConsumerWidget {
  const DeliveryDetailScreen({super.key, required this.deliveryId});

  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(deliveryByIdProvider(deliveryId));
    final proof = ref.watch(pendingProofProvider(deliveryId)).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery')),
      body: async.when(
        loading: () => const SkeletonList(itemCount: 4),
        error: (e, _) => ErrorState(onRetry: () => ref.invalidate(deliveryByIdProvider(deliveryId))),
        data: (d) {
          if (d == null) {
            return const EmptyState(icon: Icons.search_off_rounded, title: 'Delivery not found');
          }
          final active = d.status == DeliveryStatus.accepted || d.status == DeliveryStatus.pickedUp;
          final phone = d.customerPhone ?? d.dropoff?.addressSnapshot?.phone;
          final scheme = context.colors;
          return ListView(
            padding: AppSpacing.page,
            children: [
              FadeSlideIn(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StatusChip.delivery(d.status),
                          const Spacer(),
                          if (d.orderNumber != null) Text('#${d.orderNumber}', style: context.text.titleMedium),
                        ],
                      ),
                      if (proof != null) ...[
                        AppSpacing.gapMd,
                        _ProofBanner(proof: proof),
                      ],
                      AppSpacing.gapLg,
                      _Row(icon: Icons.storefront_outlined, label: 'Pickup', value: d.pickup?.vendorName ?? d.pickup?.line1 ?? 'Vendor'),
                      if (d.pickup?.line1 != null && d.pickup?.vendorName != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: AppSpacing.md),
                          child: Text(d.pickup!.line1!, style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        ),
                      _Row(icon: Icons.person_outline_rounded, label: 'Customer', value: d.customerName ?? 'Customer'),
                      _Row(icon: Icons.location_on_outlined, label: 'Drop-off', value: d.dropoff?.addressSnapshot?.oneLine ?? '—'),
                      if (phone != null) _Row(icon: Icons.phone_outlined, label: 'Phone', value: phone),
                      if (d.proof?.otpVerifiedAt != null)
                        _Row(icon: Icons.verified_outlined, label: 'Verified', value: Fmt.full(d.proof!.otpVerifiedAt!)),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapLg,
              if (active)
                FadeSlideIn(
                  delay: AppMotion.stagger,
                  child: AppButton.primary(
                    label: d.status == DeliveryStatus.pickedUp ? 'Continue to drop-off' : 'Continue to pickup',
                    trailingIcon: Icons.arrow_forward_rounded,
                    expanded: true,
                    size: AppButtonSize.large,
                    onPressed: () => context.push(Routes.active(d.id)),
                  ),
                ),
              if (phone != null) ...[
                AppSpacing.gapSm,
                AppButton.secondary(
                  label: 'Call customer',
                  icon: Icons.call_outlined,
                  expanded: true,
                  onPressed: () => callPhone(phone),
                ),
              ],
              const SectionHeader(title: 'Timeline', padding: EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm)),
              FadeSlideIn(delay: AppMotion.stagger * 2, child: DeliveryTimeline(delivery: d)),
            ],
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: context.colors.onSurfaceVariant),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.text.labelSmall?.copyWith(color: context.colors.onSurfaceVariant)),
                  Text(value, style: context.text.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ProofBanner extends StatelessWidget {
  const _ProofBanner({required this.proof});
  final PendingProof proof;

  @override
  Widget build(BuildContext context) {
    final s = context.semanticColors;
    final failed = proof.isFailed;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: failed ? s.dangerContainer : s.infoContainer, borderRadius: AppRadius.smAll),
      child: Row(
        children: [
          Icon(failed ? Icons.error_outline_rounded : Icons.cloud_upload_outlined, color: failed ? s.onDangerContainer : s.onInfoContainer),
          AppSpacing.gapSm,
          Expanded(
            child: Text(
              failed ? 'Proof rejected: ${proof.error}' : 'Proof of delivery saved. It will be submitted when you are online.',
              style: context.text.bodySmall?.copyWith(color: failed ? s.onDangerContainer : s.onInfoContainer),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical timeline built from `delivery.timeline` (falls back to createdAt).
class DeliveryTimeline extends StatelessWidget {
  const DeliveryTimeline({super.key, required this.delivery});

  final Delivery delivery;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final entries = [...delivery.timeline]..sort((a, b) => a.at.compareTo(b.at));
    if (entries.isEmpty && delivery.createdAt != null) {
      entries.add(TimelineEntry(status: 'created', at: delivery.createdAt!));
    }
    if (entries.isEmpty) {
      return const EmptyState(compact: true, icon: Icons.timeline_rounded, title: 'No events yet');
    }
    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            _TimelineRow(
              entry: entries[i],
              isFirst: i == 0,
              isLast: i == entries.length - 1,
              color: i == entries.length - 1 ? scheme.primary : scheme.outline,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry, required this.isFirst, required this.isLast, required this.color});
  final TimelineEntry entry;
  final bool isFirst;
  final bool isLast;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Expanded(child: Container(width: 2, color: isFirst ? Colors.transparent : scheme.outlineVariant)),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : scheme.outlineVariant)),
              ],
            ),
          ),
          AppSpacing.gapMd,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Fmt.title(entry.status), style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  Text(Fmt.full(entry.at), style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  if (entry.note != null && entry.note!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(entry.note!, style: context.text.bodyMedium),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
