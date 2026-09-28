import 'package:core_models/core_models.dart';

import 'base_api.dart';

/// Payment routes (§5). The Stripe webhook is server-to-server only.
class PaymentsApi extends BaseApi {
  const PaymentsApi(super.client);

  /// `POST /payments/:orderId/retry` — new PaymentIntent for an unpaid order.
  Future<CheckoutPayload> retry(String orderId) async {
    final body = unwrap(await client.post('/payments/$orderId/retry'));
    if (!body.containsKey('order') && body.containsKey('orderNumber')) {
      return CheckoutPayload(order: Order.fromJson(body));
    }
    return CheckoutPayload.fromJson(body);
  }
}
