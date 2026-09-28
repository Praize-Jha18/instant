/// Local database layer: the [LocalStore] interface with ObjectBox and
/// in-memory implementations, the outbox and the [SyncEngine] (§7).
library;

export 'src/doc_codec.dart' show DocCodec;
export 'src/local_store.dart';
export 'src/memory_store.dart';
export 'src/objectbox/objectbox_store_web.dart'
    if (dart.library.io) 'src/objectbox/objectbox_store_io.dart';
export 'src/outbox_entry.dart';
export 'src/sync/connectivity_monitor.dart';
export 'src/sync/sync_engine.dart';
export 'src/sync/sync_status.dart';
