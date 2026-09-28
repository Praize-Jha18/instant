import { randomInt } from 'node:crypto';

export function generateOtp(digits = 4): string {
  const max = 10 ** digits;
  return String(randomInt(0, max)).padStart(digits, '0');
}
