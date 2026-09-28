import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../deliveries/data/deliveries_providers.dart';

/// Count-based daily summary (earnings are not exposed to riders by the API).
class TodaySummaryCard extends StatelessWidget {
  const TodaySummaryCard({super.key, required this.summary});

  final TodaySummary summary;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today', style: context.text.labelLarge?.copyWith(color: scheme.onSurfaceVariant)),
          AppSpacing.gapMd,
          Row(
            children: [
              _Stat(label: 'Delivered', value: summary.delivered, icon: Icons.check_circle_outline_rounded, color: context.semanticColors.success),
              _Divider(),
              _Stat(label: 'In progress', value: summary.inProgress, icon: Icons.route_outlined, color: scheme.primary),
              _Divider(),
              _Stat(label: 'Failed', value: summary.failed, icon: Icons.cancel_outlined, color: context.semanticColors.danger),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            AppSpacing.gapSm,
            Text(
              '$value',
              style: context.text.headlineSmall?.copyWith(fontFeatures: AppTypography.tabularFigures),
            ),
            Text(label, style: context.text.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        color: context.colors.outlineVariant.withValues(alpha: 0.6),
      );
}
