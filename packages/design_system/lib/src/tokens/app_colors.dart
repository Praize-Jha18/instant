import 'package:flutter/material.dart';

/// Colour tokens for a clear, editorial commerce interface. The palette is
/// deliberately restrained: ink for hierarchy, warm paper for surfaces, and
/// one confident terracotta action colour.
abstract final class AppColors {
  static const Color seed = Color(0xFFC84F35);
  static const Color ink = Color(0xFF17212B);
  static const Color paper = Color(0xFFFFFCF8);
  static const Color terracotta = Color(0xFFC84F35);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  /// Naira green used for money emphasis.
  static const Color money = Color(0xFF15803D);

  static ColorScheme lightScheme([Color seedColor = seed]) =>
      ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: terracotta,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFFFE4DD),
        onPrimaryContainer: const Color(0xFF4A140B),
        secondary: const Color(0xFF445B6E),
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFDCE8F0),
        onSecondaryContainer: const Color(0xFF10212E),
        surface: paper,
        surfaceContainerLowest: paper,
        surfaceContainerLow: const Color(0xFFF7F3EE),
        surfaceContainer: const Color(0xFFF1ECE6),
        surfaceContainerHighest: const Color(0xFFEAE4DD),
        onSurface: ink,
        onSurfaceVariant: const Color(0xFF5D6268),
        outline: const Color(0xFF77736D),
        outlineVariant: const Color(0xFFD9D2C9),
      );

  static ColorScheme darkScheme([Color seedColor = seed]) =>
      ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFFFFB4A3),
        onPrimary: const Color(0xFF611B0F),
        primaryContainer: const Color(0xFF8E321F),
        onPrimaryContainer: const Color(0xFFFFDDD4),
        secondary: const Color(0xFFB7CBD8),
        onSecondary: const Color(0xFF203541),
        surface: const Color(0xFF17191B),
        surfaceContainerLowest: const Color(0xFF17191B),
        surfaceContainerLow: const Color(0xFF1E2124),
        surfaceContainer: const Color(0xFF25282B),
        surfaceContainerHighest: const Color(0xFF303337),
        onSurface: const Color(0xFFF3F0EB),
        onSurfaceVariant: const Color(0xFFCAC5BF),
        outline: const Color(0xFF928E89),
        outlineVariant: const Color(0xFF484A4D),
      );
}

/// Semantic colours that Material's scheme does not carry. Read them with
/// `context.semanticColors` (see [AppSemanticColorsContext]).
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.danger,
    required this.onDanger,
    required this.dangerContainer,
    required this.onDangerContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.money,
  });

  static const AppSemanticColors light = AppSemanticColors(
    success: AppColors.success,
    onSuccess: Colors.white,
    successContainer: Color(0xFFDCFCE7),
    onSuccessContainer: Color(0xFF14532D),
    warning: AppColors.warning,
    onWarning: Colors.white,
    warningContainer: Color(0xFFFEF3C7),
    onWarningContainer: Color(0xFF78350F),
    danger: AppColors.danger,
    onDanger: Colors.white,
    dangerContainer: Color(0xFFFEE2E2),
    onDangerContainer: Color(0xFF7F1D1D),
    info: AppColors.info,
    onInfo: Colors.white,
    infoContainer: Color(0xFFDBEAFE),
    onInfoContainer: Color(0xFF1E3A8A),
    skeletonBase: Color(0xFFE7E9EC),
    skeletonHighlight: Color(0xFFF5F6F8),
    money: AppColors.money,
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF4ADE80),
    onSuccess: Color(0xFF052E16),
    successContainer: Color(0xFF14532D),
    onSuccessContainer: Color(0xFFDCFCE7),
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFF451A03),
    warningContainer: Color(0xFF78350F),
    onWarningContainer: Color(0xFFFEF3C7),
    danger: Color(0xFFF87171),
    onDanger: Color(0xFF450A0A),
    dangerContainer: Color(0xFF7F1D1D),
    onDangerContainer: Color(0xFFFEE2E2),
    info: Color(0xFF60A5FA),
    onInfo: Color(0xFF172554),
    infoContainer: Color(0xFF1E3A8A),
    onInfoContainer: Color(0xFFDBEAFE),
    skeletonBase: Color(0xFF2A2F36),
    skeletonHighlight: Color(0xFF3A404A),
    money: Color(0xFF4ADE80),
  );

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color danger;
  final Color onDanger;
  final Color dangerContainer;
  final Color onDangerContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color money;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? onDangerContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? money,
  }) => AppSemanticColors(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    danger: danger ?? this.danger,
    onDanger: onDanger ?? this.onDanger,
    dangerContainer: dangerContainer ?? this.dangerContainer,
    onDangerContainer: onDangerContainer ?? this.onDangerContainer,
    info: info ?? this.info,
    onInfo: onInfo ?? this.onInfo,
    infoContainer: infoContainer ?? this.infoContainer,
    onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    skeletonBase: skeletonBase ?? this.skeletonBase,
    skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    money: money ?? this.money,
  );

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppSemanticColors(
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      warning: l(warning, other.warning),
      onWarning: l(onWarning, other.onWarning),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      danger: l(danger, other.danger),
      onDanger: l(onDanger, other.onDanger),
      dangerContainer: l(dangerContainer, other.dangerContainer),
      onDangerContainer: l(onDangerContainer, other.onDangerContainer),
      info: l(info, other.info),
      onInfo: l(onInfo, other.onInfo),
      infoContainer: l(infoContainer, other.infoContainer),
      onInfoContainer: l(onInfoContainer, other.onInfoContainer),
      skeletonBase: l(skeletonBase, other.skeletonBase),
      skeletonHighlight: l(skeletonHighlight, other.skeletonHighlight),
      money: l(money, other.money),
    );
  }
}

/// `context.semanticColors` shortcut.
extension AppSemanticColorsContext on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppSemanticColors.dark
          : AppSemanticColors.light);

  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}
