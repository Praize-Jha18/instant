import { randomBytes } from 'node:crypto';
import { commissionKobo } from '../../common/utils/money.js';

export interface DeliveryFeeRule {
  baseKobo: number;
  perKmKobo: number;
  freeAboveKobo: number | null;
}

/** base + perKm × ceil(distance); free when the vendor subtotal reaches `freeAboveKobo`. */
export function deliveryFeeKobo(rule: DeliveryFeeRule, distanceKm: number, subtotalKobo: number): number {
  if (rule.freeAboveKobo !== null && rule.freeAboveKobo > 0 && subtotalKobo >= rule.freeAboveKobo) return 0;
  const km = Number.isFinite(distanceKm) && distanceKm > 0 ? Math.ceil(distanceKm) : 0;
  return rule.baseKobo + rule.perKmKobo * km;
}

export interface VendorGroupTotals {
  subtotalKobo: number;
  deliveryFeeKobo: number;
  commissionKobo: number;
  vendorNetKobo: number;
}

export function vendorGroupTotals(subtotalKobo: number, deliveryFee: number, commissionBps: number): VendorGroupTotals {
  const commission = commissionKobo(subtotalKobo, commissionBps);
  return {
    subtotalKobo,
    deliveryFeeKobo: deliveryFee,
    commissionKobo: commission,
    vendorNetKobo: subtotalKobo + deliveryFee - commission,
  };
}

const ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

export function generateOrderNumber(now: Date = new Date()): string {
  const yymmdd = now.toISOString().slice(2, 10).replace(/-/g, '');
  const bytes = randomBytes(5);
  let suffix = '';
  for (const b of bytes) suffix += ALPHABET[b % ALPHABET.length];
  return `IN-${yymmdd}-${suffix}`;
}

export const UNPAID_ORDER_TTL_MS = 30 * 60 * 1000;
