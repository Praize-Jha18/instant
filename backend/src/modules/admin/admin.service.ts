import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { notDeleted } from '../../common/schemas/base.js';
import { OrdersService } from '../orders/orders.service.js';
import { SubOrder } from '../orders/schemas/sub-order.schema.js';
import { ProductsService } from '../products/products.service.js';
import { UsersService } from '../users/users.service.js';
import { VendorsService } from '../vendors/vendors.service.js';

export interface RevenueWindow {
  revenueKobo: number;
  orders: number;
  commissionKobo: number;
}

export interface AdminStats {
  counts: {
    users: number;
    customers: number;
    riders: number;
    vendors: Record<string, number>;
    products: number;
    activeProducts: number;
    orders: number;
    paidOrders: number;
    openSubOrders: number;
  };
  revenue: { today: RevenueWindow; last7d: RevenueWindow; last30d: RevenueWindow };
  generatedAt: string;
}

@Injectable()
export class AdminService {
  constructor(
    @InjectModel(SubOrder.name) private readonly subOrders: Model<SubOrder>,
    private readonly users: UsersService,
    private readonly vendors: VendorsService,
    private readonly products: ProductsService,
    private readonly orders: OrdersService,
  ) {}

  async stats(now: Date = new Date()): Promise<AdminStats> {
    const startOfToday = new Date(now);
    startOfToday.setHours(0, 0, 0, 0);
    const d7 = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
    const d30 = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);

    const [users, customers, riders, vendorRows, products, activeProducts, orders, paidOrders, openSubOrders, today, last7d, last30d] =
      await Promise.all([
        this.users.count(),
        this.users.count({ roles: 'customer' }),
        this.users.count({ roles: 'rider' }),
        this.vendors.countByStatus(),
        this.products.count(),
        this.products.count({ status: 'active' }),
        this.orders.count(),
        this.orders.count({ paymentStatus: 'paid' }),
        this.subOrders.countDocuments({ status: { $in: ['placed', 'accepted', 'preparing', 'ready', 'out_for_delivery'] }, ...notDeleted }).exec(),
        this.window(startOfToday),
        this.window(d7),
        this.window(d30),
      ]);

    const vendors: Record<string, number> = { pending: 0, active: 0, suspended: 0 };
    for (const row of vendorRows) vendors[row._id] = row.count;

    return {
      counts: { users, customers, riders, vendors, products, activeProducts, orders, paidOrders, openSubOrders },
      revenue: { today, last7d, last30d },
      generatedAt: now.toISOString(),
    };
  }

  private async window(since: Date): Promise<RevenueWindow> {
    const [rev, commission] = await Promise.all([
      this.orders.revenueSince(since),
      this.subOrders
        .aggregate<{ commissionKobo: number }>([
          { $match: { status: 'delivered', updatedAt: { $gte: since }, ...notDeleted } },
          { $group: { _id: null, commissionKobo: { $sum: '$commissionKobo' } } },
        ])
        .exec(),
    ]);
    return { revenueKobo: rev.revenueKobo, orders: rev.orders, commissionKobo: commission[0]?.commissionKobo ?? 0 };
  }
}
