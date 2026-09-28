import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:local_db/local_db.dart';

/// What a list screen should show given the local data and the sync state.
enum ListPhase { loading, ready, empty, offline, error }

/// Local data wins: anything cached is shown immediately. With nothing cached
/// we show skeletons until the first pull finishes, an offline/error state if
/// it cannot, and an empty state once the server confirmed there is nothing.
ListPhase resolveListPhase({required int count, required SyncStatus? status}) {
  if (count > 0) return ListPhase.ready;
  if (status == null) return ListPhase.loading;
  if (status.lastSyncedAt != null) return ListPhase.empty;
  return switch (status.phase) {
    SyncPhase.offline => ListPhase.offline,
    SyncPhase.error => ListPhase.error,
    SyncPhase.idle || SyncPhase.syncing => ListPhase.loading,
  };
}

/// Renders the right state for a [ListPhase].
class PhaseView extends StatelessWidget {
  const PhaseView({
    super.key,
    required this.phase,
    required this.ready,
    required this.loading,
    required this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyAction,
    this.onRetry,
    this.compact = false,
  });

  final ListPhase phase;
  final WidgetBuilder ready;
  final WidgetBuilder loading;
  final String emptyTitle;
  final String? emptyMessage;
  final IconData emptyIcon;
  final Widget? emptyAction;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.normal,
      switchInCurve: AppMotion.curve,
      child: switch (phase) {
        ListPhase.loading => KeyedSubtree(key: const ValueKey('loading'), child: loading(context)),
        ListPhase.ready => KeyedSubtree(key: const ValueKey('ready'), child: ready(context)),
        ListPhase.empty => EmptyState(
            key: const ValueKey('empty'),
            title: emptyTitle,
            message: emptyMessage,
            icon: emptyIcon,
            action: emptyAction,
            compact: compact,
          ),
        ListPhase.offline => ErrorState(
            key: const ValueKey('offline'),
            offline: true,
            onRetry: onRetry,
            compact: compact,
          ),
        ListPhase.error => ErrorState(
            key: const ValueKey('error'),
            onRetry: onRetry,
            compact: compact,
          ),
      },
    );
  }
}
