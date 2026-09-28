import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart';

import '../../../app/providers.dart';

class FinanceRepository {
  FinanceRepository(this._api, this._store);

  final ApiClient _api;
  final LocalStore _store;

  Future<Payout> requestPayout({int? amountKobo, String? note}) async {
    final p = await _api.vendor.requestPayout(RequestPayoutRequest(amountKobo: amountKobo, note: note));
    await _store.upsert(Collections.payouts, p);
    return p;
  }

  Future<void> refresh() async {
    final ledger = await _api.vendor.ledger(limit: 200);
    await _store.upsertAll(Collections.vendorLedger, ledger.items);
    final payouts = await _api.vendor.payouts(limit: 100);
    await _store.upsertAll(Collections.payouts, payouts.items);
  }
}

final financeRepositoryProvider = Provider<FinanceRepository>(
  (ref) => FinanceRepository(ref.watch(apiClientProvider), ref.watch(localStoreProvider)),
);
