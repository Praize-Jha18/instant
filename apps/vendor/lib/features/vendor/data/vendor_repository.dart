import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';
import '../../../core/vendor_codec.dart';

/// Own vendor profile. Uses raw calls instead of `VendorApi.profile()` /
/// `updateProfile()` because those decode with `Vendor.fromJson`, which
/// rejects the backend's opening-hours shape (see `VendorJson`).
class VendorRepository {
  VendorRepository(this._client, this._store);

  final ApiClient _client;
  final LocalStore _store;

  Future<Vendor> fetchProfile() async {
    final vendor = VendorJson.decode(await _client.get('/vendor'));
    await _store.upsert(Collections.vendors, vendor);
    return vendor;
  }

  Future<Vendor> updateProfile(VendorInput input) async {
    final vendor = VendorJson.decode(await _client.patch('/vendor', data: VendorJson.patchBody(input)));
    await _store.upsert(Collections.vendors, vendor);
    return vendor;
  }
}

final vendorRepositoryProvider = Provider<VendorRepository>(
  (ref) => VendorRepository(ref.watch(apiClientProvider), ref.watch(localStoreProvider)),
);
