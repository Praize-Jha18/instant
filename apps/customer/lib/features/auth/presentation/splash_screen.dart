import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/session_state.dart';
import 'session_controller.dart';

/// Checks the stored session and lets the router redirect.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(sessionControllerProvider) is SessionUnknown) {
        ref.read(sessionControllerProvider.notifier).restore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final curved = CurvedAnimation(parent: _controller, curve: AppMotion.emphasized);
    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(curved),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(color: scheme.onPrimary, borderRadius: AppRadius.lgAll),
                  child: Icon(Icons.bolt_rounded, size: 52, color: scheme.primary),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Instant',
                  style: context.text.headlineMedium?.copyWith(color: scheme.onPrimary),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
