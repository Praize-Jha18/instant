import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated.freezed.dart';
part 'paginated.g.dart';

/// A page of results: `{ items, nextCursor }` (§5).
@Freezed(genericArgumentFactories: true)
abstract class Paginated<T> with _$Paginated<T> {
  const Paginated._();

  const factory Paginated({
    @Default([]) List<T> items,
    String? nextCursor,
  }) = _Paginated<T>;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginatedFromJson(json, fromJsonT);

  /// Accepts either `{ items, nextCursor }` or a bare JSON array.
  factory Paginated.parse(Object? body, T Function(Map<String, dynamic>) fromJsonT) {
    if (body is List) {
      return Paginated(
        items: body.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      );
    }
    return Paginated.fromJson(
      body as Map<String, dynamic>,
      (e) => fromJsonT(e as Map<String, dynamic>),
    );
  }

  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;
  bool get isEmpty => items.isEmpty;
}
