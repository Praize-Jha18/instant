import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography built on Manrope via google_fonts with a graceful fallback.
///
/// Nothing is bundled: fonts are fetched at runtime when
/// [allowRuntimeFetching] is true and cached by google_fonts. When fetching is
/// disabled or fails (offline first launch) the platform sans-serif is used
/// with the same metrics, so layouts never break.
abstract final class AppTypography {
  /// Primary family requested from Google Fonts.
  static const String fontFamily = 'Manrope';

  /// Fallback families when Inter is not available.
  static const List<String> fontFamilyFallback = [
    '.SF Pro Text',
    'SF Pro Text',
    'Roboto',
    'Segoe UI',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static bool _useGoogleFonts = true;

  /// Whether to ask google_fonts for Inter at all. Set to false in widget
  /// tests or for fully offline builds.
  static bool get useGoogleFonts => _useGoogleFonts;

  /// Configures google_fonts. Call once before `runApp`.
  ///
  /// [allowRuntimeFetching] false + no bundled font makes google_fonts log an
  /// error and fall back, which is fine; we additionally guard every call.
  static void configure({
    bool allowRuntimeFetching = true,
    bool useGoogleFonts = true,
  }) {
    _useGoogleFonts = useGoogleFonts;
    GoogleFonts.config.allowRuntimeFetching = allowRuntimeFetching;
  }

  /// The text theme for [brightness], scaled by our type ramp.
  static TextTheme textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final ramp = _ramp(base);
    if (!_useGoogleFonts) return _withFallback(ramp);
    try {
      return GoogleFonts.manropeTextTheme(ramp);
    } catch (e, st) {
      // google_fonts throws synchronously only on misconfiguration; log and
      // keep the fallback so the app still renders.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'design_system',
          context: ErrorDescription('while loading Inter; using system font'),
        ),
      );
      return _withFallback(ramp);
    }
  }

  static TextTheme _withFallback(TextTheme theme) =>
      theme.apply(fontFamilyFallback: fontFamilyFallback);

  /// Our type ramp: slightly tighter headings, comfortable body.
  static TextTheme _ramp(TextTheme base) => base.copyWith(
    displaySmall: base.displaySmall?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
    ),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    bodyLarge: base.bodyLarge?.copyWith(height: 1.4),
    bodyMedium: base.bodyMedium?.copyWith(height: 1.4),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
  );

  /// Tabular figures for money and counters.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];
}
