import 'package:flutter/widgets.dart';

/// A compact radius scale. Surfaces feel considered rather than bubbly.
abstract final class AppRadius {
  static const double sm = 10;
  static const double md = 18;
  static const double lg = 28;
  static const double full = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));

  /// Top corners only (bottom sheets).
  static const BorderRadius lgTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}
