import { deliveryFeeKobo, generateOrderNumber, vendorGroupTotals } from './pricing.js';

describe('pricing (integer kobo)', () => {
  const rule = { baseKobo: 50_000, perKmKobo: 10_000, freeAboveKobo: 2_000_000 };

  it('charges base + perKm × ceil(distance)', () => {
    expect(deliveryFeeKobo(rule, 0, 100_000)).toBe(50_000);
    expect(deliveryFeeKobo(rule, 2.1, 100_000)).toBe(80_000);
    expect(deliveryFeeKobo(rule, 5, 100_000)).toBe(100_000);
  });

  it('is free above the vendor threshold and ignores non-finite distances', () => {
    expect(deliveryFeeKobo(rule, 5, 2_000_000)).toBe(0);
    expect(deliveryFeeKobo({ ...rule, freeAboveKobo: null }, Number.NaN, 5_000_000)).toBe(50_000);
  });

  it('computes commission in bps and the vendor net', () => {
    const t = vendorGroupTotals(100_000, 30_000, 1000);
    expect(t).toEqual({ subtotalKobo: 100_000, deliveryFeeKobo: 30_000, commissionKobo: 10_000, vendorNetKobo: 120_000 });
    expect(vendorGroupTotals(33_333, 0, 1250).commissionKobo).toBe(4167);
  });

  it('generates readable unique order numbers', () => {
    const a = generateOrderNumber(new Date('2026-03-04T10:00:00Z'));
    const b = generateOrderNumber(new Date('2026-03-04T10:00:00Z'));
    expect(a).toMatch(/^IN-260304-[A-Z2-9]{5}$/);
    expect(a).not.toBe(b);
  });
});
