import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../app/config.dart';

/// Centers [child] within [AppConfig.maxContentWidth] on wide screens.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = AppConfig.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

/// Page scaffold used by every screen: app bar, centered content width,
/// optional FAB and bottom bar.
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.leading,
    this.floatingActionButton,
    this.bottom,
    this.bottomBar,
    this.constrain = true,
    this.automaticallyImplyLeading = true,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? bottom;
  final Widget? bottomBar;
  final bool constrain;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: actions,
      leading: leading,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
    ),
    body: constrain ? ContentWidth(child: body) : body,
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: bottomBar,
  );
}

/// Two columns when there is room (>= [breakpoint]), stacked otherwise.
class TwoPane extends StatelessWidget {
  const TwoPane({
    super.key,
    required this.primary,
    required this.secondary,
    this.breakpoint = 900,
    this.primaryFlex = 3,
    this.secondaryFlex = 2,
    this.gap = AppSpacing.lg,
  });

  final Widget primary;
  final Widget secondary;
  final double breakpoint;
  final int primaryFlex;
  final int secondaryFlex;
  final double gap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < breakpoint) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            primary,
            SizedBox(height: gap),
            secondary,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: primaryFlex, child: primary),
          SizedBox(width: gap),
          Expanded(flex: secondaryFlex, child: secondary),
        ],
      );
    },
  );
}

/// Key/value tile used on dashboards.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.caption,
    this.onTap,
    this.tone,
  });

  final String label;
  final Widget value;
  final IconData? icon;
  final String? caption;
  final VoidCallback? onTap;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppCard(
      onTap: onTap,
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: tone ?? scheme.primary),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          DefaultTextStyle.merge(
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFeatures: AppTypography.tabularFigures,
            ),
            child: value,
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              caption!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Renders an [AsyncSnapshot]-like triple with skeleton / error / data.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({
    super.key,
    required this.value,
    required this.data,
    this.skeleton,
    this.onRetry,
  });

  final AsyncSnapshot<T>? value;
  final Widget Function(T data) data;
  final Widget? skeleton;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final v = value;
    if (v == null ||
        (v.connectionState == ConnectionState.waiting && !v.hasData)) {
      return skeleton ?? const SkeletonList();
    }
    if (v.hasError && !v.hasData) {
      return ErrorState(message: v.error.toString(), onRetry: onRetry);
    }
    return data(v.data as T);
  }
}

/// Label + value row for detail screens.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
          ?trailing,
        ],
      ),
    );
  }
}

/// A small dot showing online/offline.
class OnlineDot extends StatelessWidget {
  const OnlineDot({super.key, required this.online, this.size = 10});

  final bool online;
  final double size;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    return Semantics(
      label: online ? 'Online' : 'Offline',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: online
              ? semantic.success
              : Theme.of(context).colorScheme.outlineVariant,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Filter chips row for an enum-like list of options with an "All" entry.
class FilterChips<T> extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelOf,
    this.allLabel = 'All',
    this.counts,
  });

  final List<T> options;
  final T? selected;
  final ValueChanged<T?> onSelected;
  final String Function(T) labelOf;
  final String? allLabel;
  final Map<T, int>? counts;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: AppSpacing.pageH,
    child: Row(
      children: [
        if (allLabel != null) ...[
          ChoiceChip(
            label: Text(allLabel!),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        for (final o in options) ...[
          ChoiceChip(
            label: Text(
              counts == null
                  ? labelOf(o)
                  : '${labelOf(o)} · ${counts![o] ?? 0}',
            ),
            selected: selected == o,
            onSelected: (_) => onSelected(o),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ],
    ),
  );
}
