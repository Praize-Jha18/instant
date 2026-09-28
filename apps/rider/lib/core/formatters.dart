import 'package:intl/intl.dart';

/// Date/time helpers shared by the screens.
abstract final class Fmt {
  static final DateFormat _time = DateFormat.jm();
  static final DateFormat _dayMonth = DateFormat.MMMd();
  static final DateFormat _full = DateFormat.yMMMd().add_jm();

  /// `2:05 PM`
  static String time(DateTime dt) => _time.format(dt.toLocal());

  /// `Sep 28`
  static String dayMonth(DateTime dt) => _dayMonth.format(dt.toLocal());

  /// `Sep 28, 2026 2:05 PM`
  static String full(DateTime dt) => _full.format(dt.toLocal());

  /// `Today 2:05 PM`, `Yesterday 9:10 AM`, otherwise [full].
  static String relativeDay(DateTime dt, {DateTime? now}) {
    final local = dt.toLocal();
    final n = (now ?? DateTime.now()).toLocal();
    final today = DateTime(n.year, n.month, n.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today ${time(local)}';
    if (diff == 1) return 'Yesterday ${time(local)}';
    return full(local);
  }

  /// `0:42` for countdowns.
  static String countdown(Duration d) {
    final s = d.isNegative ? 0 : d.inSeconds;
    final m = s ~/ 60;
    final r = s % 60;
    return '$m:${r.toString().padLeft(2, '0')}';
  }

  /// `1.2 km` / `850 m`.
  static String distance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  /// `Picked up` from `picked_up`.
  static String title(String snake) => snake
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  static bool isSameDay(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }
}
