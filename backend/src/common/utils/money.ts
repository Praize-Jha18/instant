/** Money is integer kobo everywhere. */
export function commissionKobo(subtotalKobo: number, commissionBps: number): number {
  return Math.round((subtotalKobo * commissionBps) / 10_000);
}

export function assertKobo(value: number, what: string): void {
  if (!Number.isInteger(value) || value < 0) {
    throw new Error(`${what} must be a non-negative integer kobo amount`);
  }
}
