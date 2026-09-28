import 'package:core_models/core_models.dart';

/// Contract §11: the customer may cancel while every sub-order is still
/// `placed` or `awaiting_payment` (core_models' `customerCanCancel` predates
/// the addendum and only allows `placed`).
bool customerMayCancel(SubOrderStatus status) =>
    customerCanCancel(status) || status == SubOrderStatus.awaitingPayment;

bool orderCancellable(Order order, List<SubOrder> subOrders) {
  if (order.paymentStatus == PaymentStatus.refunded) return false;
  if (subOrders.isEmpty) return order.awaitingPayment;
  return subOrders.every((s) => customerMayCancel(s.status));
}

/// Unpaid (pending) or expired (failed) orders can be paid via
/// `POST /payments/:orderId/retry`.
bool orderPayable(Order order, List<SubOrder> subOrders) {
  if (order.paymentStatus != PaymentStatus.pending && order.paymentStatus != PaymentStatus.failed) return false;
  if (subOrders.isNotEmpty && subOrders.every((s) => s.status == SubOrderStatus.cancelled)) return false;
  return true;
}

/// Tracking makes sense once something is being prepared or delivered.
bool orderTrackable(Order order, List<SubOrder> subOrders) =>
    order.isPaid && subOrders.any((s) => s.status.isActive);

/// Sub-order statuses in display order for the timeline.
const List<SubOrderStatus> kSubOrderTimeline = [
  SubOrderStatus.placed,
  SubOrderStatus.accepted,
  SubOrderStatus.preparing,
  SubOrderStatus.ready,
  SubOrderStatus.outForDelivery,
  SubOrderStatus.delivered,
];

/// The most advanced sub-order status, for the list badge.
SubOrderStatus? headlineStatus(List<SubOrder> subOrders) {
  if (subOrders.isEmpty) return null;
  if (subOrders.every((s) => s.status == SubOrderStatus.cancelled)) return SubOrderStatus.cancelled;
  final active = subOrders.where((s) => s.status != SubOrderStatus.cancelled).toList();
  active.sort((a, b) => _rank(a.status).compareTo(_rank(b.status)));
  return active.first.status;
}

int _rank(SubOrderStatus s) {
  final i = kSubOrderTimeline.indexOf(s);
  return i == -1 ? -1 : i;
}
