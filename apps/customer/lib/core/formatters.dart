import 'package:intl/intl.dart';

final DateFormat _dayTime = DateFormat('d MMM, HH:mm');
final DateFormat _day = DateFormat('EEE d MMM');
final DateFormat _time = DateFormat('HH:mm');

String formatDateTime(DateTime? dt) => dt == null ? '—' : _dayTime.format(dt.toLocal());
String formatDay(DateTime? dt) => dt == null ? '—' : _day.format(dt.toLocal());
String formatTime(DateTime? dt) => dt == null ? '—' : _time.format(dt.toLocal());

/// "just now", "5 min ago", "2 h ago", otherwise the date.
String formatRelative(DateTime? dt, {DateTime? now}) {
  if (dt == null) return '—';
  final diff = (now ?? DateTime.now()).difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} h ago';
  return formatDateTime(dt);
}

const List<String> _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
String weekdayName(int weekday) => _weekdays[(weekday - 1).clamp(0, 6)];
