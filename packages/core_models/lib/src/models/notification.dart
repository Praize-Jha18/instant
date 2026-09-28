import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/converters.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// An in-app notification (`notifications` collection).
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    @JsonKey(readValue: readId) required String id,
    required String userId,
    required String type,
    required String title,
    @Default('') String body,
    @Default(<String, Object?>{}) Map<String, Object?> data,
    @NullableDateTimeConverter() DateTime? readAt,
    @NullableDateTimeConverter() DateTime? createdAt,
    @NullableDateTimeConverter() DateTime? updatedAt,
    @NullableDateTimeConverter() DateTime? deletedAt,
    @Default(0) int version,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  bool get isRead => readAt != null;
}
