import 'package:objectbox/objectbox.dart';

/// A stored document of any collection. Models are kept as JSON so the
/// ObjectBox schema never changes when freezed models do.
@Entity()
class Doc {
  Doc({
    this.id = 0,
    required this.collection,
    required this.docId,
    required this.json,
    required this.updatedAt,
  }) : key = keyFor(collection, docId);

  @Id()
  int id;

  @Index()
  String collection;

  @Index()
  String docId;

  /// `collection/docId`. ObjectBox has no composite unique index, so this is
  /// the uniqueness key; conflicting puts replace the existing row.
  @Unique(onConflict: ConflictStrategy.replace)
  String key;

  String json;

  @Index()
  @Property(type: PropertyType.date)
  DateTime updatedAt;

  static String keyFor(String collection, String docId) => '$collection/$docId';
}

/// A queued sync op (see `OutboxEntry`).
@Entity()
class OutboxEntryEntity {
  OutboxEntryEntity({
    this.id = 0,
    required this.opId,
    required this.entity,
    required this.action,
    this.customAction,
    required this.payloadJson,
    required this.clientAt,
    required this.enqueuedAt,
    this.state = 0,
    this.attempts = 0,
    this.errorCode,
    this.errorMessage,
    this.lastAttemptAt,
  });

  /// Auto-increment id doubles as push order.
  @Id()
  int id;

  @Unique(onConflict: ConflictStrategy.replace)
  String opId;

  String entity;
  String action;
  String? customAction;
  String payloadJson;

  @Property(type: PropertyType.date)
  DateTime clientAt;

  @Property(type: PropertyType.date)
  DateTime enqueuedAt;

  /// 0 = pending, 1 = rejected (`OutboxState.index`).
  @Index()
  int state;

  int attempts;
  String? errorCode;
  String? errorMessage;

  @Property(type: PropertyType.date)
  DateTime? lastAttemptAt;
}

/// Pull cursor per collection.
@Entity()
class SyncCursorEntity {
  SyncCursorEntity({this.id = 0, required this.collection, required this.cursor});

  @Id()
  int id;

  @Unique(onConflict: ConflictStrategy.replace)
  String collection;

  @Property(type: PropertyType.date)
  DateTime cursor;
}
