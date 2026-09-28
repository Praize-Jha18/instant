import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';

/// Modal bottom sheet with our shape, drag handle, optional title and safe
/// bottom padding. Returns whatever the sheet pops with.
abstract final class AppBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    String? title,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = true,
    bool useSafeArea = true,
    double? maxHeightFraction = 0.9,
    EdgeInsetsGeometry padding = AppSpacing.pageH,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      constraints: maxHeightFraction == null
          ? null
          : BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * maxHeightFraction),
      builder: (ctx) {
        final bottomInset = MediaQuery.viewInsetsOf(ctx).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                  child: Text(title, style: Theme.of(ctx).textTheme.titleLarge),
                ),
              Flexible(
                child: Padding(
                  padding: padding.add(const EdgeInsets.only(bottom: AppSpacing.lg)),
                  child: builder(ctx),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// A simple confirm sheet. Resolves true when [confirmLabel] is tapped.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool destructive = false,
  }) async {
    final result = await show<bool>(
      context,
      title: title,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (message != null) ...[
              Text(message, style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.xl),
            ],
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: destructive
                  ? FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError)
                  : null,
              child: Text(confirmLabel),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(cancelLabel)),
          ],
        );
      },
    );
    return result ?? false;
  }
}
