import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';

part 'timeline_entry.freezed.dart';
part 'timeline_entry.g.dart';

/// One status change on a SubOrder or Delivery timeline.
///
/// [status] is kept as a raw string because the same shape is used for
/// SubOrder and Delivery statuses.
@freezed
abstract class TimelineEntry with _$TimelineEntry {
  const factory TimelineEntry({
    required String status,
    @DateTimeConverter() required DateTime at,
    String? byUserId,
    String? note,
  }) = _TimelineEntry;

  factory TimelineEntry.fromJson(Map<String, dynamic> json) =>
      _$TimelineEntryFromJson(json);
}
