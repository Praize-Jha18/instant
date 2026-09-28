import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers.dart';
import '../../auth/presentation/session_controller.dart';

/// The user's addresses, default first.
final addressesProvider = StreamProvider<List<Address>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final store = ref.watch(localStoreProvider);
  return store.watchAll<Address>(
    Collections.addresses,
    filter: (a) => a.deletedAt == null && (userId.isEmpty || a.userId == userId),
    sortBy: (a, b) {
      if (a.isDefault != b.isDefault) return a.isDefault ? -1 : 1;
      return a.label.toLowerCase().compareTo(b.label.toLowerCase());
    },
  );
});

final addressProvider = StreamProvider.family<Address?, String>((ref, id) {
  final store = ref.watch(localStoreProvider);
  return store.watchById<Address>(Collections.addresses, id);
});

/// Explicit selection for cart/checkout; null means "use the default".
class SelectedAddressId extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? id) => state = id;
}

final selectedAddressIdProvider = NotifierProvider<SelectedAddressId, String?>(SelectedAddressId.new);

/// The address used for delivery estimates and checkout: the explicitly
/// selected one, else the default, else the first.
final selectedAddressProvider = Provider<Address?>((ref) {
  final list = ref.watch(addressesProvider).value ?? const [];
  if (list.isEmpty) return null;
  final id = ref.watch(selectedAddressIdProvider);
  if (id != null) {
    for (final a in list) {
      if (a.id == id) return a;
    }
  }
  for (final a in list) {
    if (a.isDefault) return a;
  }
  return list.first;
});

/// Offline-safe mutations via the outbox. Ids are minted client-side.
class AddressActions {
  AddressActions(this._ref);
  final Ref _ref;
  static const _uuid = Uuid();

  Future<Address> save({
    String? id,
    required String label,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required double lat,
    required double lng,
    String? phone,
    bool isDefault = false,
  }) async {
    final engine = _ref.read(syncEngineProvider);
    final store = _ref.read(localStoreProvider);
    final userId = _ref.read(currentUserIdProvider);
    final now = DateTime.now().toUtc();
    final existing = id == null ? null : await store.getById<Address>(Collections.addresses, id);
    final others = await store.getAll<Address>(Collections.addresses);
    final makeDefault = isDefault || others.where((a) => a.id != id).isEmpty;

    final address = (existing ?? Address(
      id: id ?? _uuid.v4(),
      userId: userId,
      line1: line1,
      city: city,
      state: state,
      lat: lat,
      lng: lng,
      createdAt: now,
    ))
        .copyWith(
      label: label.trim().isEmpty ? 'Home' : label.trim(),
      line1: line1.trim(),
      line2: (line2 ?? '').trim().isEmpty ? null : line2!.trim(),
      city: city.trim(),
      state: state.trim(),
      lat: lat,
      lng: lng,
      phone: (phone ?? '').trim().isEmpty ? null : phone!.trim(),
      isDefault: makeDefault,
      updatedAt: now,
    );

    if (makeDefault) {
      for (final other in others) {
        if (other.id != address.id && other.isDefault) {
          await engine.enqueueUpsert(Collections.addresses, other.copyWith(isDefault: false, updatedAt: now));
        }
      }
    }
    await engine.enqueueUpsert(Collections.addresses, address);
    return address;
  }

  Future<void> setDefault(String id) async {
    final engine = _ref.read(syncEngineProvider);
    final store = _ref.read(localStoreProvider);
    final now = DateTime.now().toUtc();
    for (final a in await store.getAll<Address>(Collections.addresses)) {
      final shouldBe = a.id == id;
      if (a.isDefault != shouldBe) {
        await engine.enqueueUpsert(Collections.addresses, a.copyWith(isDefault: shouldBe, updatedAt: now));
      }
    }
  }

  Future<void> delete(String id) async {
    await _ref.read(syncEngineProvider).enqueueDelete(Collections.addresses, id);
    if (_ref.read(selectedAddressIdProvider) == id) {
      _ref.read(selectedAddressIdProvider.notifier).select(null);
    }
  }
}

final addressActionsProvider = Provider<AddressActions>(AddressActions.new);
