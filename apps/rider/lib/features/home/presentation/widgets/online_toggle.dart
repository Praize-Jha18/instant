import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The big online/offline switch at the top of Home.
class OnlineToggle extends StatelessWidget {
  const OnlineToggle({
    super.key,
    required this.isOnline,
    required this.onChanged,
    this.busy = false,
    this.enabled = true,
  });

  final bool isOnline;
  final ValueChanged<bool> onChanged;
  final bool busy;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final bg = isOnline ? semantic.successContainer : scheme.surfaceContainerHigh;
    final fg = isOnline ? semantic.onSuccessContainer : scheme.onSurface;
    return Semantics(
      toggled: isOnline,
      label: isOnline ? 'You are online' : 'You are offline',
      child: AnimatedContainer(
        duration: AppMotion.normal,
        curve: AppMotion.curve,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: (isOnline ? semantic.success : scheme.outlineVariant).withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.normal,
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isOnline ? semantic.success : scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: busy
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: isOnline ? semantic.onSuccess : scheme.primary),
                    )
                  : Icon(
                      isOnline ? Icons.bolt_rounded : Icons.power_settings_new_rounded,
                      color: isOnline ? semantic.onSuccess : scheme.onSurfaceVariant,
                      size: 30,
                    ),
            ),
            AppSpacing.gapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isOnline ? 'You are online' : 'You are offline',
                      style: context.text.titleLarge?.copyWith(color: fg)),
                  AppSpacing.gapXs,
                  Text(
                    !enabled
                        ? 'Available once your account is active'
                        : isOnline
                            ? 'Receiving offers from your vendor'
                            : 'Go online to start receiving offers',
                    style: context.text.bodyMedium?.copyWith(color: fg.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.15,
              child: Switch.adaptive(
                value: isOnline,
                activeTrackColor: semantic.success,
                onChanged: enabled && !busy
                    ? (v) {
                        HapticFeedback.mediumImpact();
                        onChanged(v);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
