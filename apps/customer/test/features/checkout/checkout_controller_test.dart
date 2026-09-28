import 'package:core_models/core_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_customer/app/config.dart';
import 'package:instant_customer/features/auth/domain/session_state.dart';
import 'package:instant_customer/features/auth/presentation/session_controller.dart';
import 'package:instant_customer/features/checkout/data/payment_sheet.dart';
import 'package:instant_customer/features/checkout/domain/checkout_state.dart';
import 'package:instant_customer/features/checkout/presentation/checkout_controller.dart';
import 'package:instant_customer/features/orders/data/orders_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';

const _order = Order(id: 'o1', customerId: 'u1', orderNumber: 'IN-1', totalKobo: 5000);

void main() {
  late TestHarness h;
  setUp(() async => h = await TestHarness.create());
  tearDown(() => h.dispose());

  ProviderContainer make({required FakeOrdersRepository repo, required FakePaymentSheet sheet, String key = 'pk_test_env'}) =>
      h.container(extra: [
        ordersRepositoryProvider.overrideWithValue(repo),
        paymentSheetServiceProvider.overrideWithValue(sheet),
        appConfigProvider.overrideWithValue(AppConfig(apiBaseUrl: 'http://x', wsUrl: 'http://x', stripePublishableKey: key)),
        sessionControllerProvider.overrideWith(() => FakeSessionController(const SignedIn(testUser))),
      ]);

  test('happy path: place → pay → confirmed paid', () async {
    final repo = FakeOrdersRepository(
      payload: const CheckoutPayload(order: _order, clientSecret: 'pi_secret'),
      fetchSequence: [_order.copyWith(paymentStatus: PaymentStatus.paid)],
    );
    final sheet = FakePaymentSheet();
    final c = make(repo: repo, sheet: sheet);

    await c.read(checkoutControllerProvider.notifier).placeOrder(addressId: 'ad1', note: ' ');

    final s = c.read(checkoutControllerProvider);
    expect(s, isA<CheckoutSucceeded>());
    expect((s as CheckoutSucceeded).order.isPaid, isTrue);
    expect(sheet.secrets, ['pi_secret']);
    expect(sheet.keys, ['pk_test_env']);
    expect(repo.calls.first, startsWith('create:ad1:'));
  });

  test('server publishable key is used when the build has none', () async {
    final repo = FakeOrdersRepository(
      payload: const CheckoutPayload(order: _order, clientSecret: 'pi', publishableKey: 'pk_from_server'),
      fetchSequence: [_order.copyWith(paymentStatus: PaymentStatus.paid)],
    );
    final sheet = FakePaymentSheet();
    final c = make(repo: repo, sheet: sheet, key: '');
    await c.read(checkoutControllerProvider.notifier).placeOrder(addressId: 'ad1');
    expect(sheet.keys, ['pk_from_server']);
  });

  test('no key anywhere → not configured, order kept', () async {
    final repo = FakeOrdersRepository(payload: const CheckoutPayload(order: _order, clientSecret: 'pi'));
    final sheet = FakePaymentSheet();
    final c = make(repo: repo, sheet: sheet, key: '');
    await c.read(checkoutControllerProvider.notifier).placeOrder(addressId: 'ad1');
    final s = c.read(checkoutControllerProvider);
    expect(s, isA<CheckoutNotConfigured>());
    expect(s.order?.id, 'o1');
    expect(sheet.secrets, isEmpty);
  });

  test('cancelled sheet → failed with retry, and retry re-opens the sheet', () async {
    final repo = FakeOrdersRepository(
      payload: const CheckoutPayload(order: _order, clientSecret: 'pi'),
      fetchSequence: [_order.copyWith(paymentStatus: PaymentStatus.paid)],
    );
    final sheet = FakePaymentSheet(error: const PaymentCancelled());
    final c = make(repo: repo, sheet: sheet);
    final ctrl = c.read(checkoutControllerProvider.notifier);

    await ctrl.placeOrder(addressId: 'ad1');
    CheckoutState s = c.read(checkoutControllerProvider);
    expect(s, isA<CheckoutFailed>());
    expect((s as CheckoutFailed).cancelled, isTrue);
    expect(s.canRetryPayment, isTrue);

    sheet.error = null;
    await ctrl.retry('o1');
    final after = c.read(checkoutControllerProvider);
    expect(after, isA<CheckoutSucceeded>());
    expect(repo.calls, contains('retry:o1'));
    expect(sheet.secrets, hasLength(2));
  });

  test('order creation failure surfaces the message without an order', () async {
    final repo = FakeOrdersRepository(
      payload: const CheckoutPayload(order: _order),
      createError: Exception('boom'),
    );
    final c = make(repo: repo, sheet: FakePaymentSheet());
    await c.read(checkoutControllerProvider.notifier).placeOrder(addressId: 'ad1');
    final s = c.read(checkoutControllerProvider);
    expect(s, isA<CheckoutFailed>());
    expect((s as CheckoutFailed).canRetryPayment, isFalse);
  });

  test('declined payment reported by the server ends as failed', () async {
    final repo = FakeOrdersRepository(
      payload: const CheckoutPayload(order: _order, clientSecret: 'pi'),
      fetchSequence: [_order.copyWith(paymentStatus: PaymentStatus.failed)],
    );
    final c = make(repo: repo, sheet: FakePaymentSheet());
    await c.read(checkoutControllerProvider.notifier).placeOrder(addressId: 'ad1');
    final s = c.read(checkoutControllerProvider);
    expect(s, isA<CheckoutFailed>());
    expect((s as CheckoutFailed).message, contains('declined'));
  });
}
