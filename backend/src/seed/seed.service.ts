import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import bcrypt from 'bcrypt';
import { Model, Types } from 'mongoose';
import sharp from 'sharp';
import { notDeleted } from '../common/schemas/base.js';
import type { Role } from '../common/types/auth-user.js';
import { slugify, uniqueSlug } from '../common/utils/slug.js';
import { AppConfig } from '../config/app-config.service.js';
import { BCRYPT_COST } from '../modules/auth/providers/local-password.provider.js';
import { Address } from '../modules/addresses/schemas/address.schema.js';
import { CategoriesService } from '../modules/categories/categories.service.js';
import { ImagesService } from '../modules/images/images.service.js';
import { buildSearchText } from '../modules/products/products.service.js';
import { Product } from '../modules/products/schemas/product.schema.js';
import { RiderProfile } from '../modules/riders/schemas/rider-profile.schema.js';
import { User, type UserDocument } from '../modules/users/schemas/user.schema.js';
import { Vendor, type VendorDocument } from '../modules/vendors/schemas/vendor.schema.js';

export const SEED_PASSWORD = 'Password123!';

interface SeedVendor {
  name: string;
  description: string;
  owner: { email: string; fullName: string; phone: string };
  rider: { email: string; fullName: string; phone: string };
  address: { line1: string; city: string; state: string; lat: number; lng: number };
  products: Array<{ name: string; priceKobo: number; stock: number; category: string; colour: string; tags: string[] }>;
}

const CATEGORIES = [
  { name: 'Food & Drinks', slug: 'food-drinks', sortOrder: 1 },
  { name: 'Groceries', slug: 'groceries', sortOrder: 2 },
  { name: 'Pharmacy', slug: 'pharmacy', sortOrder: 3 },
];

const VENDORS: SeedVendor[] = [
  {
    name: 'Mama Put Kitchen',
    description: 'Home-style Nigerian meals, cooked fresh every day.',
    owner: { email: 'owner1@instant.local', fullName: 'Adaeze Okoro', phone: '+2348010000001' },
    rider: { email: 'rider1@instant.local', fullName: 'Tunde Bakare', phone: '+2348010000011' },
    address: { line1: '12 Allen Avenue', city: 'Ikeja', state: 'Lagos', lat: 6.6018, lng: 3.3515 },
    products: [
      { name: 'Jollof Rice & Chicken', priceKobo: 350_000, stock: 40, category: 'food-drinks', colour: '#d9480f', tags: ['rice', 'lunch'] },
      { name: 'Egusi Soup with Pounded Yam', priceKobo: 420_000, stock: 25, category: 'food-drinks', colour: '#5c940d', tags: ['soup', 'swallow'] },
      { name: 'Suya Platter', priceKobo: 280_000, stock: 30, category: 'food-drinks', colour: '#862e9c', tags: ['grill', 'beef'] },
      { name: 'Moi Moi (2 wraps)', priceKobo: 120_000, stock: 60, category: 'food-drinks', colour: '#e67700', tags: ['beans', 'side'] },
      { name: 'Chapman (1L)', priceKobo: 150_000, stock: 50, category: 'food-drinks', colour: '#c92a2a', tags: ['drink'] },
    ],
  },
  {
    name: 'FreshMart Groceries',
    description: 'Fresh produce, pantry staples and everyday essentials.',
    owner: { email: 'owner2@instant.local', fullName: 'Chinedu Eze', phone: '+2348010000002' },
    rider: { email: 'rider2@instant.local', fullName: 'Bola Adeyemi', phone: '+2348010000022' },
    address: { line1: '4 Admiralty Way', city: 'Lekki', state: 'Lagos', lat: 6.4413, lng: 3.4527 },
    products: [
      { name: 'Golden Penny Semovita 2kg', priceKobo: 320_000, stock: 80, category: 'groceries', colour: '#f08c00', tags: ['staple'] },
      { name: 'Fresh Tomatoes (1kg)', priceKobo: 180_000, stock: 100, category: 'groceries', colour: '#e03131', tags: ['vegetable', 'fresh'] },
      { name: 'Peak Milk Powder 400g', priceKobo: 410_000, stock: 45, category: 'groceries', colour: '#1971c2', tags: ['dairy'] },
      { name: 'Paracetamol 500mg (24 tabs)', priceKobo: 60_000, stock: 200, category: 'pharmacy', colour: '#0c8599', tags: ['otc', 'pain'] },
      { name: 'Vitamin C 1000mg (30 tabs)', priceKobo: 250_000, stock: 70, category: 'pharmacy', colour: '#2f9e44', tags: ['supplement'] },
    ],
  },
];

const CUSTOMER = {
  email: 'customer@instant.local',
  fullName: 'Ngozi Nwosu',
  phone: '+2348010000099',
  address: { label: 'Home', line1: '25 Opebi Road', city: 'Ikeja', state: 'Lagos', lat: 6.5906, lng: 3.3606 },
};

/**
 * Idempotent development seed: admin, 3 categories, 2 active vendors with
 * owners and riders, 10 products with generated images, 1 customer.
 */
@Injectable()
export class SeedService {
  private readonly logger = new Logger(SeedService.name);

  constructor(
    @InjectModel(User.name) private readonly users: Model<User>,
    @InjectModel(Vendor.name) private readonly vendors: Model<Vendor>,
    @InjectModel(Product.name) private readonly products: Model<Product>,
    @InjectModel(RiderProfile.name) private readonly riderProfiles: Model<RiderProfile>,
    @InjectModel(Address.name) private readonly addresses: Model<Address>,
    private readonly categories: CategoriesService,
    private readonly images: ImagesService,
    private readonly config: AppConfig,
  ) {}

  async run(): Promise<void> {
    await this.seedAdmin();
    const categoryIds = await this.seedCategories();
    for (const spec of VENDORS) {
      const owner = await this.ensureUser(spec.owner.email, spec.owner.fullName, spec.owner.phone, ['vendor_owner']);
      const vendor = await this.ensureVendor(spec, owner);
      if (!owner.vendorId || !owner.vendorId.equals(vendor._id)) {
        await this.users.updateOne({ _id: owner._id }, { $set: { vendorId: vendor._id } }).exec();
      }
      await this.ensureRider(spec, vendor);
      await this.ensureProducts(spec, vendor, owner, categoryIds);
    }
    await this.seedCustomer();
    this.logger.log(`Seed complete. Non-admin password for all seeded accounts: ${SEED_PASSWORD}`);
  }

  private async seedAdmin(): Promise<void> {
    const email = this.config.adminEmail.toLowerCase();
    const password = this.config.adminPassword;
    if (!email || !password) throw new Error('ADMIN_EMAIL and ADMIN_PASSWORD must be set to seed the admin account');
    const passwordHash = await bcrypt.hash(password, BCRYPT_COST);
    const existing = await this.users.findOne({ email }).exec();
    if (existing) {
      await this.users.updateOne({ _id: existing._id }, { $set: { passwordHash, status: 'active' }, $addToSet: { roles: 'admin' } }).exec();
      this.logger.log(`Admin ${email} updated`);
      return;
    }
    await this.users.create({ email, passwordHash, fullName: 'Platform Admin', roles: ['admin'], status: 'active' });
    this.logger.log(`Admin ${email} created`);
  }

  private async seedCategories(): Promise<Map<string, Types.ObjectId>> {
    const ids = new Map<string, Types.ObjectId>();
    for (const c of CATEGORIES) {
      const doc = await this.categories.upsertBySlug(c);
      ids.set(c.slug, doc._id);
    }
    this.logger.log(`Categories: ${CATEGORIES.map((c) => c.name).join(', ')}`);
    return ids;
  }

  private async ensureUser(email: string, fullName: string, phone: string, roles: Role[], vendorId?: Types.ObjectId): Promise<UserDocument> {
    const existing = await this.users.findOne({ email }).exec();
    if (existing) return existing;
    const passwordHash = await bcrypt.hash(SEED_PASSWORD, BCRYPT_COST);
    const user = await this.users.create({ email, passwordHash, fullName, phone, roles, vendorId, status: 'active' });
    this.logger.log(`User ${email} (${roles.join(',')}) created`);
    return user;
  }

  private async ensureVendor(spec: SeedVendor, owner: UserDocument): Promise<VendorDocument> {
    const slug = slugify(spec.name);
    const existing = await this.vendors.findOne({ slug }).exec();
    if (existing) {
      if (existing.status !== 'active') await this.vendors.updateOne({ _id: existing._id }, { $set: { status: 'active' } }).exec();
      return existing;
    }
    const vendor = await this.vendors.create({
      name: spec.name,
      slug,
      description: spec.description,
      ownerUserId: owner._id,
      status: 'active',
      address: { ...spec.address, country: 'NG' },
      deliveryFee: { baseKobo: 50_000, perKmKobo: 10_000, freeAboveKobo: 2_000_000 },
      deliveryRadiusKm: 25,
      openingHours: [0, 1, 2, 3, 4, 5, 6].map((day) => ({ day, open: '08:00', close: '21:00' })),
      commissionBps: 1000,
      payout: { bankName: 'GTBank', accountNumber: '0123456789', accountName: spec.name },
    });
    this.logger.log(`Vendor ${spec.name} created`);
    return vendor;
  }

  private async ensureRider(spec: SeedVendor, vendor: VendorDocument): Promise<void> {
    const rider = await this.ensureUser(spec.rider.email, spec.rider.fullName, spec.rider.phone, ['rider'], vendor._id);
    const profile = await this.riderProfiles.findOne({ userId: rider._id }).exec();
    if (profile) return;
    await this.riderProfiles.create({ userId: rider._id, vendorId: vendor._id, status: 'active', vehicleType: 'bike', plateNumber: 'LND-123-XY', isOnline: false });
    this.logger.log(`Rider ${spec.rider.email} approved for ${spec.name}`);
  }

  private async ensureProducts(spec: SeedVendor, vendor: VendorDocument, owner: UserDocument, categoryIds: Map<string, Types.ObjectId>): Promise<void> {
    for (const p of spec.products) {
      const existing = await this.products.findOne({ vendorId: vendor._id, name: p.name, ...notDeleted }).exec();
      if (existing) continue;
      const png = await sharp({ create: { width: 800, height: 800, channels: 3, background: p.colour } }).png().toBuffer();
      const productId = new Types.ObjectId();
      const image = await this.images.store({ buffer: png, mimetype: 'image/png', ownerType: 'product', ownerId: productId, uploadedBy: owner._id });
      const categoryId = categoryIds.get(p.category);
      await this.products.create({
        _id: productId,
        vendorId: vendor._id,
        name: p.name,
        slug: uniqueSlug(p.name),
        description: `${p.name} from ${spec.name}.`,
        categoryIds: categoryId ? [categoryId] : [],
        images: [{ imageId: image._id, sortOrder: 0 }],
        basePriceKobo: p.priceKobo,
        variants: [],
        hasVariants: false,
        stock: p.stock,
        status: 'active',
        tags: p.tags,
        searchText: buildSearchText({ name: p.name, description: `${p.name} from ${spec.name}.`, tags: p.tags }),
      });
      this.logger.log(`Product ${p.name} created for ${spec.name}`);
    }
  }

  private async seedCustomer(): Promise<void> {
    const customer = await this.ensureUser(CUSTOMER.email, CUSTOMER.fullName, CUSTOMER.phone, ['customer']);
    const has = await this.addresses.exists({ userId: customer._id, ...notDeleted });
    if (has) return;
    await this.addresses.create({ userId: customer._id, ...CUSTOMER.address, line2: '', phone: CUSTOMER.phone, isDefault: true, clientUpdatedAt: new Date() });
    this.logger.log(`Customer ${CUSTOMER.email} created with a default address`);
  }
}
