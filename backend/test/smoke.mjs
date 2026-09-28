// End-to-end smoke test against an ephemeral in-memory MongoDB replica set (mongodb-memory-server).
// Usage: pnpm smoke   (builds, seeds, boots dist/main.js on port 3999 with the mock payment provider,
// then drives the customer → payment → vendor → rider → ledger → sync flows over HTTP).
import { createRequire } from 'node:module';
import { spawn } from 'node:child_process';
import path from 'node:path';

const backend = process.cwd();
const require = createRequire(path.join(backend, 'package.json'));
const { MongoMemoryReplSet } = require('mongodb-memory-server');

const PORT = 3999;
const BASE = `http://127.0.0.1:${PORT}/api/v1`;
const env = {
  ...process.env,
  NODE_ENV: 'development',
  PORT: String(PORT),
  JWT_SECRET: 'smoke-test-secret-with-enough-length',
  ADMIN_EMAIL: 'admin@instant.local',
  ADMIN_PASSWORD: 'Admin12345!',
  PAYMENTS_PROVIDER: 'mock',
  CORS_ORIGINS: '*',
};

let failures = 0;
function check(name, cond, extra) {
  if (cond) console.log(`  ok   ${name}`);
  else {
    failures += 1;
    console.log(`  FAIL ${name}`, extra !== undefined ? JSON.stringify(extra).slice(0, 600) : '');
  }
}

async function api(method, url, { token, body, raw } = {}) {
  const headers = {};
  if (token) headers.authorization = `Bearer ${token}`;
  let payload;
  if (raw !== undefined) {
    headers['content-type'] = 'application/json';
    payload = raw;
  } else if (body !== undefined) {
    headers['content-type'] = 'application/json';
    payload = JSON.stringify(body);
  }
  const init = { method, headers };
  if (payload !== undefined) init.body = payload;
  const res = await fetch(`${BASE}${url}`, init);
  const text = await res.text();
  let json;
  try {
    json = JSON.parse(text);
  } catch {
    json = text;
  }
  return { status: res.status, json, headers: res.headers };
}

function run(cmd, args, opts = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(cmd, args, { cwd: backend, env, stdio: ['ignore', 'pipe', 'pipe'], ...opts });
    let out = '';
    child.stdout.on('data', (d) => (out += d.toString()));
    child.stderr.on('data', (d) => (out += d.toString()));
    child.on('exit', (code) => (code === 0 ? resolve(out) : reject(new Error(`${cmd} exited ${code}\n${out}`))));
  });
}

async function waitFor(url, ms = 30000) {
  const start = Date.now();
  while (Date.now() - start < ms) {
    try {
      const r = await fetch(url);
      if (r.status < 500) return;
    } catch {}
    await new Promise((r) => setTimeout(r, 300));
  }
  throw new Error('server did not start');
}

const mongo = await MongoMemoryReplSet.create({ replSet: { count: 1, storageEngine: 'wiredTiger' } });
env.MONGODB_URI = mongo.getUri('instant');
console.log('mongo:', env.MONGODB_URI);

let server;
try {
  console.log('== seed (1st run)');
  const seedOut = await run('node', ['dist/seed/seed.js']);
  check('seed ran', /Seed complete/.test(seedOut), seedOut.slice(-400));
  console.log('== seed (2nd run, idempotent)');
  const seedOut2 = await run('node', ['dist/seed/seed.js']);
  check('seed idempotent', /Seed complete/.test(seedOut2) && !/Product .* created/.test(seedOut2), seedOut2.slice(-400));

  console.log('== boot server');
  server = spawn('node', ['dist/main.js'], { cwd: backend, env, stdio: ['ignore', 'pipe', 'pipe'] });
  let serverLog = '';
  server.stdout.on('data', (d) => (serverLog += d.toString()));
  server.stderr.on('data', (d) => (serverLog += d.toString()));
  try {
    await waitFor(`${BASE}/categories`);
  } catch (e) {
    console.log(serverLog.slice(-6000));
    throw e;
  }
  check('server booted', true);
  check('change streams active (replica set)', /Watching change streams/.test(serverLog), serverLog.slice(-800));

  // ---- public catalogue
  let r = await api('GET', '/categories');
  check('GET /categories', r.status === 200 && r.json.items.length === 3, r.json);
  r = await api('GET', '/vendors?near=6.59,3.36');
  check('GET /vendors near', r.status === 200 && r.json.items.length === 2 && typeof r.json.items[0].distanceKm === 'number', r.json);
  const vendorSlug = r.json.items[0].slug;
  r = await api('GET', `/vendors/${vendorSlug}`);
  check('GET /vendors/:slug', r.status === 200 && r.json.slug === vendorSlug, r.json);
  r = await api('GET', '/products');
  check('GET /products', r.status === 200 && r.json.items.length === 10 && r.json.items[0].id, r.json);
  const product = r.json.items.find((p) => p.name === 'Jollof Rice & Chicken');
  r = await api('GET', '/products?q=jollof');
  check('GET /products?q= regex fallback', r.status === 200 && r.json.items.length === 1, r.json);
  r = await api('GET', '/products?limit=3');
  check('cursor pagination', r.status === 200 && r.json.items.length === 3 && r.json.nextCursor, r.json);
  const r2 = await api('GET', `/products?limit=3&cursor=${encodeURIComponent(r.json.nextCursor)}`);
  check('cursor page 2 distinct', r2.status === 200 && r2.json.items[0].id !== r.json.items[0].id, r2.json);
  const imageId = product.images[0].imageId;
  let img = await fetch(`${BASE}/images/${imageId}?size=thumb`);
  const etag = img.headers.get('etag');
  check('GET /images thumb', img.status === 200 && img.headers.get('content-type') === 'image/png' && img.headers.get('cache-control').includes('max-age=31536000') && etag, img.status);
  img = await fetch(`${BASE}/images/${imageId}?size=thumb`, { headers: { 'if-none-match': etag } });
  check('GET /images 304 on ETag', img.status === 304, img.status);

  // ---- auth
  r = await api('POST', '/auth/login', { body: { email: 'customer@instant.local', password: 'Password123!' } });
  check('login customer', r.status === 200 && r.json.accessToken && r.json.refreshToken && r.json.user.id, r.json);
  const customer = r.json.accessToken;
  const refresh1 = r.json.refreshToken;
  r = await api('POST', '/auth/refresh', { body: { refreshToken: refresh1 } });
  check('refresh rotates', r.status === 200 && r.json.refreshToken !== refresh1, r.json);
  const refresh2 = r.json.refreshToken;
  r = await api('POST', '/auth/refresh', { body: { refreshToken: refresh1 } });
  check('reuse detected', r.status === 401 && r.json.code === 'REFRESH_TOKEN_REUSED', r.json);
  r = await api('POST', '/auth/refresh', { body: { refreshToken: refresh2 } });
  check('family revoked', r.status === 401, r.json);
  r = await api('GET', '/auth/me');
  check('401 envelope', r.status === 401 && r.json.code === 'UNAUTHENTICATED', r.json);
  r = await api('GET', '/auth/me', { token: customer });
  check('GET /auth/me', r.status === 200 && r.json.email === 'customer@instant.local' && !r.json.passwordHash, r.json);
  r = await api('POST', '/auth/register', { body: { email: 'newowner@instant.local', password: 'Password123!', fullName: 'New Owner', role: 'vendor_owner', vendorName: 'Pop-up Store' } });
  check('register vendor_owner creates pending vendor', r.status === 201 && r.json.user.vendorId, r.json);
  const pendingVendorId = r.json.user.vendorId;
  r = await api('POST', '/auth/register', { body: { email: 'newrider@instant.local', password: 'Password123!', fullName: 'New Rider', role: 'rider', vendorId: pendingVendorId } });
  check('register rider creates pending profile', r.status === 201, r.json);
  r = await api('POST', '/auth/register', { body: { email: 'x@instant.local', password: 'short', fullName: 'X', role: 'customer' } });
  check('validation error envelope', r.status === 400 && r.json.code === 'VALIDATION_ERROR' && Array.isArray(r.json.details), r.json);

  // ---- vendor + rider logins
  r = await api('POST', '/auth/login', { body: { email: 'owner1@instant.local', password: 'Password123!' } });
  const vendor = r.json.accessToken;
  const vendorId = r.json.user.vendorId;
  r = await api('POST', '/auth/login', { body: { email: 'rider1@instant.local', password: 'Password123!' } });
  const rider = r.json.accessToken;
  r = await api('POST', '/auth/login', { body: { email: 'admin@instant.local', password: 'Admin12345!' } });
  check('login admin', r.status === 200, r.json);
  const admin = r.json.accessToken;

  r = await api('GET', '/vendor', { token: customer });
  check('role guard blocks customer on /vendor', r.status === 403 && r.json.code === 'FORBIDDEN_ROLE', r.json);
  r = await api('GET', '/vendor', { token: vendor });
  check('GET /vendor', r.status === 200 && r.json.id === vendorId, r.json);
  r = await api('GET', `/vendor/products?vendorId=${pendingVendorId}`, { token: vendor });
  check('vendor scope guard', r.status === 403 && r.json.code === 'VENDOR_SCOPE_VIOLATION', r.json);

  // ---- vendor product CRUD + stock
  r = await api('POST', '/vendor/products', { token: vendor, body: { name: 'Test Drink', basePriceKobo: 1000, stock: 2, status: 'active', variants: [{ name: 'Small', priceKobo: 1000, stock: 3 }, { name: 'Large', priceKobo: 1500, stock: 0 }] } });
  check('POST /vendor/products with variants', r.status === 201 && r.json.hasVariants && r.json.variants.length === 2 && r.json.variants[0].id, r.json);
  const variantProduct = r.json;
  r = await api('POST', `/vendor/products/${variantProduct.id}/stock`, { token: vendor, body: { variantId: variantProduct.variants[1].id, delta: 5, reason: 'restock' } });
  check('stock adjust variant', r.status === 201 && r.json.product.variants[1].stock === 5, r.json);
  r = await api('POST', `/vendor/products/${variantProduct.id}/stock`, { token: vendor, body: { variantId: variantProduct.variants[1].id, delta: -9, reason: 'adjustment' } });
  check('stock adjust guarded', r.status === 409 && r.json.code === 'INSUFFICIENT_STOCK', r.json);
  r = await api('GET', '/vendor/inventory/movements', { token: vendor });
  check('GET movements', r.status === 200 && r.json.items.length >= 1, r.json);

  // ---- cart + order
  r = await api('GET', '/me/addresses', { token: customer });
  const address = r.json.items[0];
  check('GET /me/addresses', r.status === 200 && address, r.json);
  const cartItems = [
    { productId: product.id, vendorId: product.vendorId, qty: 2, priceKoboSnapshot: 1, nameSnapshot: 'client lies' },
    { productId: variantProduct.id, variantId: variantProduct.variants[0].id, vendorId: vendorId, qty: 1, priceKoboSnapshot: 1, nameSnapshot: 'x' },
  ];
  r = await api('PUT', '/me/cart', { token: customer, body: { items: cartItems } });
  check('PUT /me/cart', r.status === 200 && r.json.items.length === 2, r.json);
  r = await api('POST', '/orders', { token: customer, body: { addressId: address.id } });
  check('POST /orders', r.status === 201 && r.json.order && r.json.subOrders.length === 1 && r.json.payment.clientSecret, r.json);
  const order = r.json.order;
  const sub = r.json.subOrders[0];
  check('prices snapshotted from DB', sub.items[0].priceKoboSnapshot === product.basePriceKobo && sub.subtotalKobo === product.basePriceKobo * 2 + 1000, sub);
  check('commission from vendor bps', sub.commissionKobo === Math.round(sub.subtotalKobo * 0.1) && sub.deliveryFeeKobo > 0, sub);
  check('awaiting_payment', sub.status === 'awaiting_payment' && order.paymentStatus === 'pending', sub);
  r = await api('GET', `/products/${product.id}`);
  check('stock reserved', r.json.stock === product.stock - 2, r.json);
  r = await api('GET', '/vendor/orders', { token: vendor });
  check('vendor cannot see unpaid', r.status === 200 && r.json.items.length === 0, r.json);
  r = await api('GET', '/me/cart', { token: customer });
  check('cart cleared', r.json.items.length === 0, r.json);

  // stock failure rollback
  r = await api('PUT', '/me/cart', { token: customer, body: { items: [{ productId: product.id, vendorId: product.vendorId, qty: 1, priceKoboSnapshot: 1, nameSnapshot: 'a' }, { productId: variantProduct.id, variantId: variantProduct.variants[0].id, vendorId, qty: 999, priceKoboSnapshot: 1, nameSnapshot: 'x' }] } });
  r = await api('POST', '/orders', { token: customer, body: { addressId: address.id } });
  check('insufficient stock 409', r.status === 409 && r.json.code === 'INSUFFICIENT_STOCK', r.json);
  const afterFail = await api('GET', `/products/${product.id}`);
  check('rollback restored first line', afterFail.json.stock === product.stock - 2, afterFail.json);

  // ---- webhook (mock provider) idempotent
  const ev = { id: 'evt_1', type: 'payment_intent.succeeded', providerRef: sub && (await api('GET', `/orders/${order.id}/checkout`, { token: customer })).json.payment.providerRef };
  r = await api('POST', '/payments/webhook/stripe', { body: ev });
  check('webhook paid', r.status === 200 && r.json.outcome === 'paid', r.json);
  r = await api('POST', '/payments/webhook/stripe', { body: ev });
  check('webhook duplicate', r.status === 200 && r.json.outcome === 'duplicate', r.json);
  r = await api('GET', `/orders/${order.id}`, { token: customer });
  check('order paid + placed', r.json.order.paymentStatus === 'paid' && r.json.subOrders[0].status === 'placed', r.json);
  r = await api('GET', '/vendor/orders?status=placed', { token: vendor });
  check('vendor sees placed', r.json.items.length === 1, r.json);

  // ---- vendor transitions
  r = await api('POST', `/vendor/orders/${sub.id}/status`, { token: vendor, body: { status: 'ready' } });
  check('invalid transition 409', r.status === 409 && r.json.code === 'INVALID_TRANSITION', r.json);
  for (const s of ['accepted', 'preparing', 'ready']) {
    r = await api('POST', `/vendor/orders/${sub.id}/status`, { token: vendor, body: { status: s } });
    check(`transition -> ${s}`, r.status === 200 && r.json.status === s && r.json.timeline.at(-1).status === s, r.json);
  }
  check('delivery created on ready', r.json.deliveryId && r.json.deliveryOtp, r.json);
  const otp = r.json.deliveryOtp;
  const deliveryId = r.json.deliveryId;

  // ---- rider flow
  r = await api('GET', `/vendor/deliveries/${deliveryId}`, { token: vendor });
  check('GET vendor delivery', r.status === 200 && r.json.status === 'unassigned' && r.json.proof.otp !== otp, r.json);
  r = await api('POST', `/vendor/deliveries/${deliveryId}/auto-assign`, { token: vendor });
  check('auto-assign no rider online', r.status === 409 && r.json.code === 'NO_RIDER_AVAILABLE', r.json);
  r = await api('GET', '/vendor/riders', { token: vendor });
  check('GET /vendor/riders', r.status === 200 && r.json.items.length === 1 && r.json.items[0].user.email === 'rider1@instant.local', r.json);
  r = await api('PATCH', '/rider/profile', { token: rider, body: { isOnline: true } });
  check('rider online', r.status === 200 && r.json.isOnline === true, r.json);
  r = await api('POST', '/rider/location', { token: rider, body: { lat: 6.6, lng: 3.35, at: new Date().toISOString() } });
  check('rider location stored', r.status === 201 && r.json.stored === true, r.json);
  r = await api('POST', '/rider/location', { token: rider, body: { lat: 6.6, lng: 3.35, at: new Date().toISOString() } });
  check('rider location throttled', r.status === 201 && r.json.stored === false, r.json);
  r = await api('POST', `/vendor/deliveries/${deliveryId}/auto-assign`, { token: vendor });
  check('auto-assign nearest rider', r.status === 201 && r.json.status === 'offered' && r.json.riderId, r.json);
  r = await api('GET', '/rider/deliveries?status=offered', { token: rider });
  check('rider sees offer', r.json.items.length === 1, r.json);
  r = await api('POST', `/rider/deliveries/${deliveryId}/pickup`, { token: rider });
  check('pickup before accept 409', r.status === 409, r.json);
  r = await api('POST', `/rider/deliveries/${deliveryId}/respond`, { token: rider, body: { accept: true } });
  check('rider accepts', r.status === 201 && r.json.status === 'accepted', r.json);
  r = await api('POST', `/rider/deliveries/${deliveryId}/pickup`, { token: rider });
  check('pickup', r.status === 201 && r.json.status === 'picked_up', r.json);
  r = await api('GET', `/orders/${order.id}/tracking`, { token: customer });
  check('tracking shows rider location', r.json.subOrders[0].status === 'out_for_delivery' && r.json.subOrders[0].delivery.riderLocation, r.json);
  r = await api('POST', `/rider/deliveries/${deliveryId}/deliver`, { token: rider, body: { otp: '0000' === otp ? '1111' : '0000' } });
  check('wrong otp 403', r.status === 403 && r.json.code === 'INVALID_OTP', r.json);
  r = await api('POST', `/rider/deliveries/${deliveryId}/deliver`, { token: rider, body: { otp } });
  check('deliver with otp', r.status === 201 && r.json.status === 'delivered' && r.json.proof.otpVerifiedAt, r.json);
  r = await api('GET', `/vendor/orders/${sub.id}`, { token: vendor });
  check('subOrder delivered', r.json.status === 'delivered', r.json);
  r = await api('GET', '/vendor/ledger', { token: vendor });
  check('ledger sale+commission', r.json.items.length === 2 && r.json.balance.balanceKobo === sub.subtotalKobo + sub.deliveryFeeKobo - sub.commissionKobo, r.json);
  r = await api('POST', '/vendor/payouts', { token: vendor, body: {} });
  check('request payout', r.status === 201 && r.json.status === 'requested', r.json);
  const payoutId = r.json.id;
  r = await api('POST', `/admin/payouts/${payoutId}/mark-paid`, { token: admin, body: { reference: 'TRF-1' } });
  check('admin mark-paid', r.status === 200 && r.json.status === 'paid', r.json);
  r = await api('GET', '/vendor/ledger', { token: vendor });
  check('ledger payout row, balance 0', r.json.balance.balanceKobo === 0, r.json.balance);
  r = await api('GET', '/notifications', { token: customer });
  check('customer notifications', r.json.items.length >= 3, r.json.items.length);

  // ---- admin
  r = await api('GET', '/admin/stats', { token: admin });
  check('admin stats', r.status === 200 && r.json.counts.vendors.active === 2 && r.json.revenue.today.revenueKobo === order.totalKobo, r.json);
  r = await api('POST', `/admin/vendors/${pendingVendorId}/approve`, { token: admin });
  check('admin approve vendor', r.status === 200 && r.json.status === 'active', r.json);
  r = await api('GET', '/admin/stats', { token: customer });
  check('admin guard', r.status === 403, r.json);

  // ---- sync
  r = await api('GET', '/sync/pull?collections=products,vendors,categories,orders,subOrders,deliveries,carts,addresses', { token: customer });
  check('sync pull customer', r.status === 200 && r.json.changes.products.length === 11 && r.json.changes.orders.length === 1 && r.json.changes.subOrders.length === 1 && r.json.changes.deliveries.length === 1 && r.json.serverTime, Object.fromEntries(Object.entries(r.json.changes).map(([k, v]) => [k, v.length])));
  r = await api('GET', '/sync/pull?collections=orders,subOrders,vendorLedger', { token: vendor });
  check('sync pull vendor scoped', r.json.changes.orders.length === 0 && r.json.changes.subOrders.length === 1 && r.json.changes.vendorLedger.length === 3, Object.fromEntries(Object.entries(r.json.changes).map(([k, v]) => [k, v.length])));
  r = await api('GET', `/sync/pull?collections=products&limit=4`, { token: customer });
  check('sync pull paged', r.json.changes.products.length === 4 && r.json.nextCursor, r.json.nextCursor);
  r = await api('GET', `/sync/pull?collections=products&limit=4&cursor=${encodeURIComponent(r.json.nextCursor)}`, { token: customer });
  check('sync pull page 2', r.json.changes.products.length === 4 && r.json.nextCursor, r.json.nextCursor);
  const opId = '7c9e6679-7425-40de-944b-e07fc1f90ae7';
  const ops = [{ opId, entity: 'cart', action: 'upsert', payload: { items: [cartItems[0]] }, clientAt: new Date().toISOString() }];
  r = await api('POST', '/sync/push', { token: customer, body: { ops } });
  check('sync push applied', r.status === 200 && r.json.results[0].status === 'applied' && r.json.results[0].doc.items.length === 1, r.json);
  r = await api('POST', '/sync/push', { token: customer, body: { ops } });
  check('sync push duplicate', r.json.results[0].status === 'duplicate', r.json);
  r = await api('POST', '/sync/push', { token: vendor, body: { ops: [{ opId: '9b2d5f5e-1c3a-4e2b-9f1a-0d2c3b4a5e6f', entity: 'stock', action: 'custom', payload: { name: 'stock.adjust', productId: variantProduct.id, variantId: variantProduct.variants[1].id, delta: 2, reason: 'restock' }, clientAt: new Date().toISOString() }] } });
  check('sync push stock.adjust', r.json.results[0].status === 'applied' && r.json.results[0].doc.delta === 2, r.json);
  r = await api('POST', '/sync/push', { token: customer, body: { ops: [{ opId: '1b2d5f5e-1c3a-4e2b-9f1a-0d2c3b4a5e6f', entity: 'stock', action: 'custom', payload: { name: 'stock.adjust', productId: variantProduct.id, delta: 2 }, clientAt: new Date().toISOString() }] } });
  check('sync push stock rejected for customer', r.json.results[0].status === 'rejected' && r.json.results[0].code === 'VENDOR_SCOPE_REQUIRED', r.json);

  // ---- customer cancel + refund path on a new paid order
  r = await api('PUT', '/me/cart', { token: customer, body: { items: [cartItems[0]] } });
  r = await api('POST', '/orders', { token: customer, body: { addressId: address.id } });
  const order2 = r.json.order;
  r = await api('POST', '/payments/webhook/stripe', { body: { id: 'evt_2', type: 'payment_intent.succeeded', providerRef: r.json.payment.providerRef } });
  r = await api('POST', `/orders/${order2.id}/cancel`, { token: customer, body: { reason: 'changed my mind' } });
  check('customer cancel while placed', r.status === 200 && r.json.order.paymentStatus === 'refunded' && r.json.subOrders[0].status === 'cancelled', r.json);
  const afterCancel = await api('GET', `/products/${product.id}`);
  check('stock released on cancel', afterCancel.json.stock === product.stock - 2, afterCancel.json);

  // ---- expiry path: create unpaid order, force-expire
  r = await api('PUT', '/me/cart', { token: customer, body: { items: [cartItems[0]] } });
  r = await api('POST', '/orders', { token: customer, body: { addressId: address.id } });
  const order3 = r.json.order;
  r = await api('POST', '/payments/webhook/stripe', { body: { id: 'evt_3', type: 'payment_intent.payment_failed', providerRef: r.json.payment.providerRef } });
  check('webhook failed releases', r.json.outcome === 'failed', r.json);
  r = await api('GET', `/orders/${order3.id}`, { token: customer });
  check('order failed + cancelled', r.json.order.paymentStatus === 'failed' && r.json.subOrders[0].status === 'cancelled', r.json);
  r = await api('POST', `/payments/${order3.id}/retry`, { token: customer });
  check('retry reopens order', r.status === 200 && r.json.order.paymentStatus === 'pending' && r.json.subOrders[0].status === 'awaiting_payment' && r.json.payment.clientSecret, r.json);

  // ---- swagger
  const docs = await fetch(`http://127.0.0.1:${PORT}/docs`);
  check('swagger served', docs.status === 200, docs.status);

  if (/ERROR/.test(serverLog)) {
    console.log('--- server ERROR lines ---');
    console.log(serverLog.split('\n').filter((l) => /ERROR/.test(l)).join('\n'));
  }
} catch (err) {
  failures += 1;
  console.error('SMOKE CRASH', err);
} finally {
  server?.kill('SIGTERM');
  await new Promise((r) => setTimeout(r, 500));
  await mongo.stop();
}
console.log(failures === 0 ? '\nALL SMOKE CHECKS PASSED' : `\n${failures} SMOKE CHECK(S) FAILED`);
process.exit(failures === 0 ? 0 : 1);
