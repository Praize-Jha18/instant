import 'package:intl/intl.dart';

final _dateTime = DateFormat('d MMM yyyy, HH:mm');
final _date = DateFormat('d MMM yyyy');
final _time = DateFormat('HH:mm');
final _shortDay = DateFormat('EEE d');

String formatDateTime(DateTime? dt) => dt == null ? '—' : _dateTime.format(dt.toLocal());
String formatDate(DateTime? dt) => dt == null ? '—' : _date.format(dt.toLocal());
String formatTime(DateTime? dt) => dt == null ? '—' : _time.format(dt.toLocal());
String formatShortDay(DateTime dt) => _shortDay.format(dt.toLocal());

String timeAgo(DateTime? dt) {
  if (dt == null) return '—';
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return formatDate(dt);
}

String titleCase(String snake) => snake
    .split('_')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');

const weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

String weekdayName(int weekday) => weekdayNames[(weekday - 1).clamp(0, 6)];

bool isToday(DateTime? dt) {
  if (dt == null) return false;
  final l = dt.toLocal();
  final now = DateTime.now();
  return l.year == now.year && l.month == now.month && l.day == now.day;
}

DateTime startOfToday() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
