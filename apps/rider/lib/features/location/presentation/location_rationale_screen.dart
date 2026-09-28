import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/location_permission.dart';
import '../data/location_service.dart';

/// Explains why background location is needed before the OS prompt. Pops with
/// the resulting [LocationAccess] (or null when dismissed).
class LocationRationaleScreen extends ConsumerStatefulWidget {
  const LocationRationaleScreen({super.key});

  @override
  ConsumerState<LocationRationaleScreen> createState() => _LocationRationaleScreenState();
}

class _LocationRationaleScreenState extends ConsumerState<LocationRationaleScreen> {
  LocationAccess? _access;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_check);
  }

  Future<void> _check() async {
    final a = await ref.read(locationPermissionGateProvider).check();
    if (mounted) setState(() => _access = a);
  }

  Future<void> _request() async {
    setState(() => _busy = true);
    final gate = ref.read(locationPermissionGateProvider);
    final a = await gate.request();
    if (!mounted) return;
    setState(() {
      _access = a;
      _busy = false;
    });
    if (a.canTrack) {
      await ref.read(riderLocationServiceProvider).retry();
      if (mounted) context.pop(a);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final semantic = context.semanticColors;
    final access = _access;
    final gate = ref.read(locationPermissionGateProvider);

    Widget? hint;
    if (access == LocationAccess.deniedForever) {
      hint = _Hint(
        color: semantic.warningContainer,
        fg: semantic.onWarningContainer,
        text: 'Location is blocked for this app. Open Settings and allow location "All the time".',
        actionLabel: 'Open settings',
        onAction: gate.openAppSettings,
      );
    } else if (access == LocationAccess.serviceDisabled) {
      hint = _Hint(
        color: semantic.warningContainer,
        fg: semantic.onWarningContainer,
        text: 'Location services are switched off on this phone.',
        actionLabel: 'Location settings',
        onAction: gate.openLocationSettings,
      );
    } else if (access == LocationAccess.whileInUse) {
      hint = _Hint(
        color: semantic.infoContainer,
        fg: semantic.onInfoContainer,
        text: 'Tracking works while the app is open. For updates with the screen off, choose "Allow all the time" in Settings.',
        actionLabel: 'Open settings',
        onAction: gate.openAppSettings,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Location access')),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.page,
          children: [
            FadeSlideIn(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
                    child: Icon(Icons.my_location_rounded, color: scheme.onPrimaryContainer, size: 36),
                  ),
                  AppSpacing.gapXl,
                  Text('Share your location while you deliver', style: context.text.headlineSmall),
                  AppSpacing.gapMd,
                  Text(
                    'Instant Rider uses your location, including in the background, to:',
                    style: context.text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  AppSpacing.gapLg,
                  const _Bullet(icon: Icons.storefront_outlined, text: 'Let your vendor offer you nearby deliveries when you are online.'),
                  const _Bullet(icon: Icons.person_pin_circle_outlined, text: 'Show customers where their order is while you are on the way.'),
                  const _Bullet(icon: Icons.battery_saver_outlined, text: 'Only while you are online or on an active delivery. Never when you are offline.'),
                  AppSpacing.gapXl,
                  if (hint != null) ...[hint, AppSpacing.gapLg],
                  AppButton.primary(
                    label: access?.canTrack ?? false ? 'Continue' : 'Allow location',
                    icon: Icons.location_on_outlined,
                    expanded: true,
                    size: AppButtonSize.large,
                    loading: _busy,
                    onPressed: access?.canTrack ?? false
                        ? () => context.pop(access)
                        : access == LocationAccess.deniedForever
                            ? null
                            : _request,
                    tooltip: 'Allow location in Settings first',
                  ),
                  AppSpacing.gapSm,
                  AppButton.ghost(label: 'Not now', expanded: true, onPressed: () => context.pop(access)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.colors.primary),
            AppSpacing.gapMd,
            Expanded(child: Text(text, style: context.text.bodyMedium)),
          ],
        ),
      );
}

class _Hint extends StatelessWidget {
  const _Hint({required this.color, required this.fg, required this.text, required this.actionLabel, required this.onAction});
  final Color color;
  final Color fg;
  final String text;
  final String actionLabel;
  final Future<bool> Function() onAction;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: color, borderRadius: AppRadius.smAll),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: context.text.bodyMedium?.copyWith(color: fg)),
            AppSpacing.gapSm,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(foregroundColor: fg),
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      );
}
