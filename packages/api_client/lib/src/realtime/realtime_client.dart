import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'realtime_events.dart';

/// Socket.IO client for the `/rt` namespace (§7).
///
/// - Authenticates with `auth: { token }`; [tokenProvider] is invoked on every
///   (re)connect so a refreshed access token is always used.
/// - Auto-reconnects with backoff. Rooms passed to [subscribe] are re-joined
///   after each reconnect.
/// - Exposes [changed], [removed], [riderLocations] and [connectionState]
///   streams. Realtime is an optimisation: `SyncEngine` performs a pull on
///   every reconnect.
class RealtimeClient {
  RealtimeClient({
    required this.wsUrl,
    required this.tokenProvider,
    this.namespace = '/rt',
    this.reconnectionDelay = const Duration(seconds: 1),
    this.reconnectionDelayMax = const Duration(seconds: 30),
    io.Socket? socket,
  }) : _injectedSocket = socket;

  /// `WS_URL`, e.g. `http://localhost:3000`.
  final String wsUrl;

  /// Returns the current access token (null when signed out). Called on each
  /// connection attempt, so wire it to your token store / refresh logic.
  final Future<String?> Function() tokenProvider;

  /// Socket.IO namespace.
  final String namespace;

  final Duration reconnectionDelay;
  final Duration reconnectionDelayMax;

  final io.Socket? _injectedSocket;
  io.Socket? _socket;

  final _changed = StreamController<ChangedEvent>.broadcast();
  final _removed = StreamController<RemovedEvent>.broadcast();
  final _riderLocations = StreamController<RiderLocationEvent>.broadcast();
  final _state = StreamController<RealtimeConnectionState>.broadcast();
  final _errors = StreamController<Object>.broadcast();
  final Set<String> _rooms = {};
  RealtimeConnectionState _current = RealtimeConnectionState.disconnected;

  /// `changed { collection, id, doc }` events.
  Stream<ChangedEvent> get changed => _changed.stream;

  /// `removed { collection, id }` events.
  Stream<RemovedEvent> get removed => _removed.stream;

  /// `rider.location` events for subscribed delivery/order rooms.
  Stream<RiderLocationEvent> get riderLocations => _riderLocations.stream;

  /// Connection lifecycle. Emits on every change; see [currentState].
  Stream<RealtimeConnectionState> get connectionState => _state.stream;

  /// Connection/handshake errors (e.g. rejected token).
  Stream<Object> get errors => _errors.stream;

  RealtimeConnectionState get currentState => _current;
  bool get isConnected => _current == RealtimeConnectionState.connected;

  /// Rooms currently requested (re-joined on reconnect).
  Set<String> get rooms => Set.unmodifiable(_rooms);

  /// Opens the connection (idempotent).
  void connect() {
    if (_socket != null) {
      if (!_socket!.connected) {
        _setState(RealtimeConnectionState.connecting);
        _socket!.connect();
      }
      return;
    }
    final socket = _injectedSocket ?? _buildSocket();
    _socket = socket;
    _wire(socket);
    _setState(RealtimeConnectionState.connecting);
    socket.connect();
  }

  /// Closes the connection but keeps subscriptions for the next [connect].
  void disconnect() {
    final s = _socket;
    if (s == null) return;
    s.disconnect();
    _setState(RealtimeConnectionState.disconnected);
  }

  /// Joins [room] (`user:{id}`, `vendor:{id}`, `order:{id}`, `delivery:{id}`).
  void subscribe(String room) {
    _rooms.add(room);
    if (isConnected) _socket?.emit('subscribe', {'room': room});
  }

  /// Leaves [room].
  void unsubscribe(String room) {
    _rooms.remove(room);
    if (isConnected) _socket?.emit('unsubscribe', {'room': room});
  }

  /// Sends the rider's position (`rider.location`). Returns false when not
  /// connected so callers can fall back to the outbox / REST.
  bool sendRiderLocation(RiderLocationUpdate update) {
    if (!isConnected) return false;
    _socket?.emit('rider.location', update.toJson());
    return true;
  }

  /// Emits an arbitrary event.
  void emit(String event, [Object? data]) => _socket?.emit(event, data);

  /// Tears everything down.
  Future<void> dispose() async {
    final s = _socket;
    _socket = null;
    s?.dispose();
    _setState(RealtimeConnectionState.disconnected);
    await Future.wait([
      _changed.close(),
      _removed.close(),
      _riderLocations.close(),
      _state.close(),
      _errors.close(),
    ]);
  }

  io.Socket _buildSocket() {
    final base = wsUrl.endsWith('/') ? wsUrl.substring(0, wsUrl.length - 1) : wsUrl;
    final opts = io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .setReconnectionDelay(reconnectionDelay.inMilliseconds)
        .setReconnectionDelayMax(reconnectionDelayMax.inMilliseconds)
        .setAuthFn(_authFn)
        .build();
    return io.io('$base$namespace', opts);
  }

  /// socket_io_client invokes this on every connection attempt, which is what
  /// lets a refreshed token be used on reconnect.
  void _authFn(void Function(Map<String, dynamic> data) callback) {
    tokenProvider().then(
      (token) => callback({'token': token ?? ''}),
      onError: (Object e) {
        _errors.add(e);
        callback({'token': ''});
      },
    );
  }

  void _wire(io.Socket socket) {
    socket
      ..onConnect((_) {
        _setState(RealtimeConnectionState.connected);
        for (final room in _rooms) {
          socket.emit('subscribe', {'room': room});
        }
      })
      ..onDisconnect((_) => _setState(RealtimeConnectionState.disconnected))
      ..onReconnectAttempt((_) => _setState(RealtimeConnectionState.reconnecting))
      ..onConnectError((e) {
        _errors.add(e ?? 'connect_error');
        if (_current != RealtimeConnectionState.reconnecting) {
          _setState(RealtimeConnectionState.disconnected);
        }
      })
      ..onError((e) => _errors.add(e ?? 'error'))
      ..on('changed', (data) => _tryAdd(_changed, data, ChangedEvent.fromJson))
      ..on('removed', (data) => _tryAdd(_removed, data, RemovedEvent.fromJson))
      ..on('rider.location', (data) => _tryAdd(_riderLocations, data, RiderLocationEvent.fromJson));
  }

  void _tryAdd<T>(
    StreamController<T> controller,
    Object? data,
    T Function(Map<String, dynamic>) parse,
  ) {
    if (controller.isClosed) return;
    final payload = data is List && data.isNotEmpty ? data.first : data;
    if (payload is! Map) return;
    try {
      controller.add(parse(Map<String, dynamic>.from(payload)));
    } catch (e) {
      _errors.add(e);
    }
  }

  void _setState(RealtimeConnectionState state) {
    if (_current == state) return;
    _current = state;
    if (!_state.isClosed) _state.add(state);
  }
}
