import {
  canTransition,
  canTransitionDelivery,
  customerCanCancel,
  holdsStock,
  isTerminal,
  SUB_ORDER_STATUSES,
  vendorCanTransition,
  vendorNextStatuses,
  type SubOrderStatus,
} from './order-state-machine.js';

describe('SubOrder state machine (§6)', () => {
  const happyPath: SubOrderStatus[] = ['awaiting_payment', 'placed', 'accepted', 'preparing', 'ready', 'out_for_delivery', 'delivered'];

  it('allows the happy path in order', () => {
    for (let i = 0; i < happyPath.length - 1; i += 1) {
      expect(canTransition(happyPath[i] as SubOrderStatus, happyPath[i + 1] as SubOrderStatus)).toBe(true);
    }
  });

  it('never allows skipping a step or going backwards', () => {
    expect(canTransition('placed', 'preparing')).toBe(false);
    expect(canTransition('placed', 'ready')).toBe(false);
    expect(canTransition('accepted', 'placed')).toBe(false);
    expect(canTransition('ready', 'preparing')).toBe(false);
    expect(canTransition('delivered', 'out_for_delivery')).toBe(false);
  });

  it('allows cancellation only from awaiting_payment, placed, accepted, preparing', () => {
    const cancellable: SubOrderStatus[] = ['awaiting_payment', 'placed', 'accepted', 'preparing'];
    for (const s of SUB_ORDER_STATUSES) {
      expect(canTransition(s, 'cancelled')).toBe(cancellable.includes(s));
    }
  });

  it('treats delivered and cancelled as terminal', () => {
    expect(isTerminal('delivered')).toBe(true);
    expect(isTerminal('cancelled')).toBe(true);
    for (const s of SUB_ORDER_STATUSES) {
      if (s !== 'delivered' && s !== 'cancelled') expect(isTerminal(s)).toBe(false);
    }
    expect(canTransition('cancelled', 'placed')).toBe(false);
  });

  it('vendors cannot drive delivery-owned transitions or touch unpaid orders', () => {
    expect(vendorNextStatuses('awaiting_payment')).toEqual([]);
    expect(vendorCanTransition('ready', 'out_for_delivery')).toBe(false);
    expect(vendorCanTransition('out_for_delivery', 'delivered')).toBe(false);
    expect(vendorNextStatuses('placed')).toEqual(['accepted', 'cancelled']);
    expect(vendorNextStatuses('preparing')).toEqual(['ready', 'cancelled']);
    expect(vendorCanTransition('awaiting_payment', 'placed')).toBe(false);
  });

  it('customers may cancel only while placed', () => {
    for (const s of SUB_ORDER_STATUSES) expect(customerCanCancel(s)).toBe(s === 'placed');
  });

  it('knows which statuses still hold reserved stock', () => {
    expect(holdsStock('awaiting_payment')).toBe(true);
    expect(holdsStock('preparing')).toBe(true);
    expect(holdsStock('ready')).toBe(false);
    expect(holdsStock('delivered')).toBe(false);
    expect(holdsStock('cancelled')).toBe(false);
  });
});

describe('Delivery state machine (§6)', () => {
  it('follows unassigned → offered → accepted → picked_up → delivered', () => {
    expect(canTransitionDelivery('unassigned', 'offered')).toBe(true);
    expect(canTransitionDelivery('offered', 'accepted')).toBe(true);
    expect(canTransitionDelivery('accepted', 'picked_up')).toBe(true);
    expect(canTransitionDelivery('picked_up', 'delivered')).toBe(true);
  });

  it('lets a declined offer return to unassigned and forbids resurrecting terminal states', () => {
    expect(canTransitionDelivery('offered', 'unassigned')).toBe(true);
    expect(canTransitionDelivery('delivered', 'picked_up')).toBe(false);
    expect(canTransitionDelivery('failed', 'accepted')).toBe(false);
    expect(canTransitionDelivery('unassigned', 'delivered')).toBe(false);
  });
});
