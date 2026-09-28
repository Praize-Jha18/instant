/**
 * SubOrder and Delivery state machines (ARCHITECTURE §6). Pure functions; no I/O.
 *
 *   awaiting_payment → placed (payment confirmed) | cancelled (expired / failed)
 *   placed → accepted → preparing → ready → out_for_delivery → delivered
 *   placed|accepted|preparing → cancelled   (vendor, or customer only while placed)
 */
export const SUB_ORDER_STATUSES = [
  'awaiting_payment',
  'placed',
  'accepted',
  'preparing',
  'ready',
  'out_for_delivery',
  'delivered',
  'cancelled',
] as const;
export type SubOrderStatus = (typeof SUB_ORDER_STATUSES)[number];

export const SUB_ORDER_TRANSITIONS: Readonly<Record<SubOrderStatus, readonly SubOrderStatus[]>> = {
  awaiting_payment: ['placed', 'cancelled'],
  placed: ['accepted', 'cancelled'],
  accepted: ['preparing', 'cancelled'],
  preparing: ['ready', 'cancelled'],
  ready: ['out_for_delivery'],
  out_for_delivery: ['delivered'],
  delivered: [],
  cancelled: [],
};

export function isSubOrderStatus(value: unknown): value is SubOrderStatus {
  return typeof value === 'string' && (SUB_ORDER_STATUSES as readonly string[]).includes(value);
}

export function canTransition(from: SubOrderStatus, to: SubOrderStatus): boolean {
  return SUB_ORDER_TRANSITIONS[from].includes(to);
}

export function nextStatuses(from: SubOrderStatus): readonly SubOrderStatus[] {
  return SUB_ORDER_TRANSITIONS[from];
}

/** Transitions a vendor may trigger via `POST /vendor/orders/:id/status`. */
export function vendorNextStatuses(from: SubOrderStatus): SubOrderStatus[] {
  if (from === 'awaiting_payment') return [];
  return SUB_ORDER_TRANSITIONS[from].filter((s) => s !== 'out_for_delivery' && s !== 'delivered');
}

export function vendorCanTransition(from: SubOrderStatus, to: SubOrderStatus): boolean {
  return vendorNextStatuses(from).includes(to);
}

/** Customers may cancel only while `placed` (§5). */
export function customerCanCancel(status: SubOrderStatus): boolean {
  return status === 'placed';
}

export function isTerminal(status: SubOrderStatus): boolean {
  return SUB_ORDER_TRANSITIONS[status].length === 0;
}

export function isActiveForVendor(status: SubOrderStatus): boolean {
  return status !== 'awaiting_payment' && !isTerminal(status);
}

/** Statuses in which reserved stock is still held and must be released on cancel. */
export function holdsStock(status: SubOrderStatus): boolean {
  return status === 'awaiting_payment' || status === 'placed' || status === 'accepted' || status === 'preparing';
}

// ───────────────────────────── deliveries ─────────────────────────────

export const DELIVERY_STATUSES = ['unassigned', 'offered', 'accepted', 'picked_up', 'delivered', 'failed'] as const;
export type DeliveryStatus = (typeof DELIVERY_STATUSES)[number];

export const DELIVERY_TRANSITIONS: Readonly<Record<DeliveryStatus, readonly DeliveryStatus[]>> = {
  unassigned: ['offered', 'accepted'],
  offered: ['accepted', 'unassigned'],
  accepted: ['picked_up', 'failed', 'unassigned'],
  picked_up: ['delivered', 'failed'],
  delivered: [],
  failed: [],
};

export function canTransitionDelivery(from: DeliveryStatus, to: DeliveryStatus): boolean {
  return DELIVERY_TRANSITIONS[from].includes(to);
}

export function isDeliveryTerminal(status: DeliveryStatus): boolean {
  return DELIVERY_TRANSITIONS[status].length === 0;
}

export class InvalidTransitionError extends Error {
  constructor(
    readonly entity: 'subOrder' | 'delivery',
    readonly from: string,
    readonly to: string,
  ) {
    super(`${entity}: cannot move from ${from} to ${to}`);
  }
}
