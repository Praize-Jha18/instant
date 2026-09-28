import 'package:flutter/animation.dart';

/// Motion tokens: 150 / 250 / 400 ms with easeOutCubic (§9).
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve curve = Curves.easeOutCubic;
  static const Curve curveIn = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Stagger between successive list items in entrance animations.
  static const Duration stagger = Duration(milliseconds: 40);
}
