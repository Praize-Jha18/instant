import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// Light / dark / system, persisted in the local store (`appSettings/theme`).
class ThemeModeController extends Notifier<ThemeMode> {
  static const _collection = 'appSettings';
  static const _id = 'theme';

  @override
  ThemeMode build() {
    Future<void>.microtask(_load);
    return ThemeMode.system;
  }

  Future<void> _load() async {
    try {
      final doc = await ref.read(localStoreProvider).getById<Map<String, dynamic>>(_collection, _id);
      final name = doc?['mode'] as String?;
      final mode = ThemeMode.values.where((m) => m.name == name).firstOrNull;
      if (mode != null && ref.mounted) state = mode;
    } catch (_) {
      // Store unavailable (tests): keep system.
    }
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    try {
      await ref.read(localStoreProvider).upsertJson(_collection, {'id': _id, 'mode': mode.name});
    } catch (_) {
      // Non-fatal.
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
