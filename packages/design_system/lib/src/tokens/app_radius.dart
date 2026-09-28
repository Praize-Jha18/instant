import 'package:flutter/widgets.dart';

/// Corner radii 12 / 16 / 24 (§9).
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double full = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));

  /// Top corners only (bottom sheets).
  static const BorderRadius lgTop = BorderRadius.vertical(top: Radius.circular(lg));
}
