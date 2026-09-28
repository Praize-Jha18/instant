import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:core_models/core_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instant_customer/app/providers.dart';
import 'package:instant_customer/features/auth/data/auth_gateway.dart';
import 'package:instant_customer/features/auth/domain/session_state.dart';
import 'package:instant_customer/features/auth/presentation/session_controller.dart';
import 'package:instant_customer/features/catalog/data/location_controller.dart';
import 'package:instant_customer/features/checkout/data/payment_sheet.dart';
import 'package:instant_customer/features/orders/data/orders_repository.dart';

const testUser = User(id: 'u1', email: 'ada@example.com', fullName: 'Ada Lovelace', roles: [UserRole.customer]);

/// Sync transport that applies everything and returns no changes.
class FakeSyncTransport implements SyncTransport {
  final List<SyncOp> pushed = [];

  @override
  Future<SyncPullResponse> pull({required List<String> collections, DateTime? since, String? cursor, int? limit}) async =>
      SyncPullResponse(serverTime: DateTime.now().toUtc());

  @override
  Future<SyncPushResponse> push(List<SyncOp> ops) async {
    pushed.addAll(ops);
    return SyncPushResponse(
      results: [for (final op in ops) SyncPushResult(opId: op.opId, status: SyncOpStatus.applied)],
    );
  }
}

class NoopLifecycle implements SessionLifecycle {
  int starts = 0;
  int stops = 0;
  String? lastUserId;

  @override
  Future<void> start(String userId) async {
    starts++;
    lastUserId = userId;
  }

  @override
  Future<void> stop() async => stops++;
}

class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway({this.session = false, this.meResult, this.meError, this.loginResult});

  bool session;
  User? meResult;
  Object? meError;
  User? loginResult;
  Object? loginError;
  final List<String> calls = [];

  @override
  Future<bool> hasSession() async => session;

  @override
  Future<User> me() async {
    calls.add('me');
    if (meError != null) throw meError!;
    return meResult ?? testUser;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    calls.add('login:$email');
    if (loginError != null) throw loginError!;
    session = true;
    return loginResult ?? testUser;
  }

  @override
  Future<User> register({required String email, required String password, required String fullName, String? phone}) async {
    calls.add('register:$email');
    session = true;
    return testUser.copyWith(email: email, fullName: fullName, phone: phone);
  }

  @override
  Future<void> logout() async {
    calls.add('logout');
    session = false;
  }

  @override
  Future<void> clearTokens() async {
    calls.add('clearTokens');
    session = false;
  }
}

/// Session controller whose state tests can set directly.
class FakeSessionController extends SessionController {
  FakeSessionController([this.initial = const SessionUnknown()]);
  final SessionState initial;

  @override
  SessionState build() => initial;

  void set(SessionState s) => state = s;

  @override
  Future<void> restore() async {}
}

class FakeLocationService implements LocationService {
  FakeLocationService({this.granted = false, this.position});
  bool granted;
  GeoPoint? position;

  @override
  Future<bool> hasPermission() async => granted;

  @override
  Future<bool> requestPermission() async => granted;

  @override
  Future<GeoPoint?> currentPosition() async => position;
}

class FakePaymentSheet implements PaymentSheetService {
  FakePaymentSheet({this.error});
  Object? error;
  final List<String> secrets = [];
  final List<String> keys = [];

  @override
  Future<void> pay({required String publishableKey, required String clientSecret, ThemeMode style = ThemeMode.system}) async {
    keys.add(publishableKey);
    secrets.add(clientSecret);
    if (error != null) throw error!;
  }
}

class FakeOrdersRepository implements OrdersRepository {
  FakeOrdersRepository({required this.payload, this.createError, List<Order>? fetchSequence})
      : fetchSequence = fetchSequence ?? [];

  CheckoutPayload payload;
  Object? createError;
  final List<Order> fetchSequence;
  final List<String> calls = [];
  final ValueNotifier<Map<String, String>> otps = ValueNotifier(const {});

  @override
  Future<CheckoutPayload> createOrder(CreateOrderRequest request) async {
    calls.add('create:${request.addressId}:${request.idempotencyKey}');
    if (createError != null) throw createError!;
    return payload;
  }

  @override
  Future<CheckoutPayload> retryPayment(String orderId) async {
    calls.add('retry:$orderId');
    return payload;
  }

  @override
  Future<Order> fetchOrder(String id) async {
    calls.add('fetch:$id');
    if (fetchSequence.isEmpty) return payload.order;
    return fetchSequence.length == 1 ? fetchSequence.first : fetchSequence.removeAt(0);
  }

  @override
  Future<Order> cancelOrder(String id) async => payload.order;

  @override
  Future<OrderTracking> tracking(String orderId) async => OrderTracking(orderId: orderId);

  @override
  ValueListenable<Map<String, String>> get deliveryOtps => otps;
}
