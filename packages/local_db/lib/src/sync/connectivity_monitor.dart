import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Source of online/offline changes for the [SyncEngine].
abstract interface class ConnectivityMonitor {
  /// Emits whenever connectivity flips. Need not emit the initial value.
  Stream<bool> get onlineChanges;

  /// Current state.
  Future<bool> isOnline();
}

/// [ConnectivityMonitor] backed by `connectivity_plus`.
class ConnectivityPlusMonitor implements ConnectivityMonitor {
  ConnectivityPlusMonitor([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Stream<bool> get onlineChanges => _connectivity.onConnectivityChanged.map(_isOnline).distinct();

  @override
  Future<bool> isOnline() async {
    try {
      return _isOnline(await _connectivity.checkConnectivity());
    } catch (_) {
      // Unsupported platform: assume online and let requests decide.
      return true;
    }
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}

/// Scriptable [ConnectivityMonitor] for tests and for apps that want to
/// force offline mode.
class ManualConnectivityMonitor implements ConnectivityMonitor {
  ManualConnectivityMonitor({bool initiallyOnline = true}) : _online = initiallyOnline;

  bool _online;
  final _controller = StreamController<bool>.broadcast();

  bool get online => _online;

  set online(bool value) {
    if (_online == value) return;
    _online = value;
    _controller.add(value);
  }

  @override
  Stream<bool> get onlineChanges => _controller.stream;

  @override
  Future<bool> isOnline() async => _online;

  Future<void> dispose() => _controller.close();
}
