import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/routes.dart';
import '../../../../core/geo.dart';
import '../../domain/vendor_helpers.dart';

class VendorCard extends ConsumerWidget {
  const VendorCard({
    super.key,
    required this.vendor,
    this.distanceKm,
    this.width,
  });

  final Vendor vendor;
  final double? distanceKm;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(imageUrlProvider);
    final scheme = context.colors;
    final text = context.text;
    final open = vendor.isOpenAt(DateTime.now());
    final fee = vendor.deliveryFee;

    return SizedBox(
      width: width,
      child: AppCard(
        padding: EdgeInsets.zero,
        onTap: () => context.push(AppRoutes.vendor(vendor.id)),
        elevated: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppImage(
                  url: imageUrl(
                    vendor.coverImageId ?? vendor.logoImageId,
                    thumb: true,
                  ),
                  aspectRatio: 1.7,
                  borderRadius: BorderRadius.zero,
                  errorIcon: Icons.storefront_outlined,
                ),
                Positioned(
                  left: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: AppRadius.smAll,
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: AppImage(
                      url: imageUrl(vendor.logoImageId, thumb: true),
                      width: 40,
                      height: 40,
                      errorIcon: Icons.store_rounded,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall,
                        ),
                      ),
                      StatusChip(
                        label: open ? 'Open' : 'Closed',
                        tone: open ? StatusTone.success : StatusTone.neutral,
                        dense: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xxs,
                    children: [
                      if (distanceKm != null)
                        _Meta(
                          icon: Icons.near_me_outlined,
                          label: formatDistance(distanceKm!),
                        ),
                      if (fee != null)
                        _Meta(
                          icon: Icons.delivery_dining_outlined,
                          label: fee.baseKobo == 0 && fee.perKmKobo == 0
                              ? 'Free delivery'
                              : 'From ${Money.fromKobo(fee.baseKobo).format(showDecimals: false)}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: scheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: context.text.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
