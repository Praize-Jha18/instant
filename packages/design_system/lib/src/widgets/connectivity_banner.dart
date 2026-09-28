import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_spacing.dart';

/// Slim banner shown while offline or while queued changes are syncing (§9).
///
/// Give it plain values, or feed a `Stream<SyncStatus>`-like stream through
/// [ConnectivityBanner.stream] with selectors so the design system stays
/// independent of `local_db`.
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({
    super.key,
    required this.offline,
    this.pendingCount = 0,
    this.syncing = false,
    this.error = false,
    this.onRetry,
    this.offlineMessage = 'You are offline. Changes will sync when you reconnect.',
  });

  /// Rebuilds from [stream] using the selectors.
  static Widget stream<T>({
    Key? key,
    required Stream<T> stream,
    T? initialData,
    required bool Function(T status) offline,
    int Function(T status)? pendingCount,
    bool Function(T status)? syncing,
    bool Function(T status)? error,
    VoidCallback? onRetry,
  }) =>
      StreamBuilder<T>(
        key: key,
        stream: stream,
        initialData: initialData,
        builder: (context, snap) {
          final s = snap.data;
          if (s == null) return const SizedBox.shrink();
          return ConnectivityBanner(
            offline: offline(s),
            pendingCount: pendingCount?.call(s) ?? 0,
            syncing: syncing?.call(s) ?? false,
            error: error?.call(s) ?? false,
            onRetry: onRetry,
          );
        },
      );

  final bool offline;
  final int pendingCount;
  final bool syncing;
  final bool error;
  final VoidCallback? onRetry;
  final String offlineMessage;

  bool get _visible => offline || syncing || error || pendingCount > 0;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final (Color bg, Color fg, IconData icon, String text) = offline
        ? (
            semantic.warningContainer,
            semantic.onWarningContainer,
            Icons.wifi_off_rounded,
            pendingCount > 0 ? '$offlineMessage ($pendingCount pending)' : offlineMessage,
          )
        : error
            ? (semantic.dangerContainer, semantic.onDangerContainer, Icons.sync_problem_rounded,
                'Sync failed.${pendingCount > 0 ? ' $pendingCount change${pendingCount == 1 ? '' : 's'} waiting.' : ''}')
            : syncing
                ? (scheme.primaryContainer, scheme.onPrimaryContainer, Icons.sync_rounded,
                    pendingCount > 0 ? 'Syncing $pendingCount change${pendingCount == 1 ? '' : 's'}…' : 'Syncing…')
                : (scheme.primaryContainer, scheme.onPrimaryContainer, Icons.cloud_upload_outlined,
                    '$pendingCount change${pendingCount == 1 ? '' : 's'} waiting to sync');

    return AnimatedSize(
      duration: AppMotion.normal,
      curve: AppMotion.curve,
      alignment: Alignment.topCenter,
      child: _visible
          ? Material(
              color: bg,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      if (syncing && !offline)
                        SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                        )
                      else
                        Icon(icon, size: 18, color: fg),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(text, style: theme.textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w500)),
                      ),
                      if (onRetry != null && (error || (offline && pendingCount > 0)))
                        TextButton(
                          onPressed: onRetry,
                          style: TextButton.styleFrom(foregroundColor: fg, visualDensity: VisualDensity.compact),
                          child: const Text('Retry'),
                        ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(width: double.infinity, height: 0),
    );
  }
}
