import 'enums.dart';

/// Allowed SubOrder transitions mirroring ARCHITECTURE §6.
///
/// ```
/// awaiting_payment → placed (payment confirmed) | cancelled (expired)
/// placed → accepted → preparing → ready → out_for_delivery → delivered
/// placed|accepted|preparing → cancelled
/// ```
const Map<SubOrderStatus, Set<SubOrderStatus>> subOrderTransitions = {
  SubOrderStatus.awaitingPayment: {SubOrderStatus.placed, SubOrderStatus.cancelled},
  SubOrderStatus.placed: {SubOrderStatus.accepted, SubOrderStatus.cancelled},
  SubOrderStatus.accepted: {SubOrderStatus.preparing, SubOrderStatus.cancelled},
  SubOrderStatus.preparing: {SubOrderStatus.ready, SubOrderStatus.cancelled},
  SubOrderStatus.ready: {SubOrderStatus.outForDelivery},
  SubOrderStatus.outForDelivery: {SubOrderStatus.delivered},
  SubOrderStatus.delivered: {},
  SubOrderStatus.cancelled: {},
};

/// Returns true when a SubOrder may move from [from] to [to].
bool canTransition(SubOrderStatus from, SubOrderStatus to) =>
    subOrderTransitions[from]?.contains(to) ?? false;

/// The statuses a SubOrder in [from] may move to.
Set<SubOrderStatus> nextSubOrderStatuses(SubOrderStatus from) =>
    subOrderTransitions[from] ?? const {};

/// Transitions a vendor may trigger from the vendor app (`POST /vendor/orders/:id/status`).
/// `out_for_delivery` and `delivered` are driven by the delivery, not the vendor.
Set<SubOrderStatus> vendorNextSubOrderStatuses(SubOrderStatus from) =>
    nextSubOrderStatuses(from)
        .where((s) => s != SubOrderStatus.outForDelivery && s != SubOrderStatus.delivered)
        .toSet();

/// Whether the customer may cancel: while `placed`, or before paying (§11).
bool customerCanCancel(SubOrderStatus status) =>
    status == SubOrderStatus.placed || status == SubOrderStatus.awaitingPayment;

/// Allowed Delivery transitions (§6).
const Map<DeliveryStatus, Set<DeliveryStatus>> deliveryTransitions = {
  DeliveryStatus.unassigned: {DeliveryStatus.offered, DeliveryStatus.accepted},
  DeliveryStatus.offered: {DeliveryStatus.accepted, DeliveryStatus.unassigned},
  DeliveryStatus.accepted: {DeliveryStatus.pickedUp, DeliveryStatus.failed},
  DeliveryStatus.pickedUp: {DeliveryStatus.delivered, DeliveryStatus.failed},
  DeliveryStatus.delivered: {},
  DeliveryStatus.failed: {},
};

/// Returns true when a Delivery may move from [from] to [to].
bool canTransitionDelivery(DeliveryStatus from, DeliveryStatus to) =>
    deliveryTransitions[from]?.contains(to) ?? false;
