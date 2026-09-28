import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';

@immutable
class NewOrderAlertState {
  const NewOrderAlertState({this.unseen = 0, this.latest});

  /// Placed orders that arrived since the board was last opened.
  final int unseen;
  final SubOrder? latest;
}

/// Watches the local `subOrders` collection and fires a sound + haptic and a
/// badge whenever a new `placed` order appears (from realtime or a pull).
class NewOrderAlerts extends Notifier<NewOrderAlertState> {
  StreamSubscription<List<SubOrder>>? _sub;
  Set<String>? _known;

  @override
  NewOrderAlertState build() {
    // Restart per session so a new sign-in re-seeds the known set.
    ref.watch(sessionProvider.select((s) => s.user?.id));
    final store = ref.watch(localStoreProvider);
    _known = null;
    _sub?.cancel();
    _sub = store
        .watchAll<SubOrder>(Collections.subOrders, filter: (s) => s.status == SubOrderStatus.placed)
        .listen(_onPlaced);
    ref.onDispose(() => _sub?.cancel());
    return const NewOrderAlertState();
  }

  void _onPlaced(List<SubOrder> placed) {
    final ids = placed.map((s) => s.id).toSet();
    final known = _known;
    if (known == null) {
      _known = ids;
      return;
    }
    final fresh = placed.where((s) => !known.contains(s.id)).toList();
    _known = ids;
    if (fresh.isEmpty) return;
    fresh.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    state = NewOrderAlertState(unseen: state.unseen + fresh.length, latest: fresh.first);
    _alert();
  }

  Future<void> _alert() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  void markSeen() {
    if (state.unseen != 0) state = NewOrderAlertState(latest: state.latest);
  }
}

final newOrderAlertsProvider = NotifierProvider<NewOrderAlerts, NewOrderAlertState>(NewOrderAlerts.new);
