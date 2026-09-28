import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { CategoriesModule } from '../categories/categories.module.js';
import { ImagesModule } from '../images/images.module.js';
import { VendorsModule } from '../vendors/vendors.module.js';
import { ProductsPublicController, VendorInventoryController, VendorProductsController } from './products.controller.js';
import { ProductsService } from './products.service.js';
import { InventoryMovement, InventoryMovementSchema } from './schemas/inventory-movement.schema.js';
import { Product, ProductSchema } from './schemas/product.schema.js';
import { StockService } from './stock.service.js';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Product.name, schema: ProductSchema },
      { name: InventoryMovement.name, schema: InventoryMovementSchema },
    ]),
    ImagesModule,
    CategoriesModule,
    VendorsModule,
  ],
  controllers: [ProductsPublicController, VendorProductsController, VendorInventoryController],
  providers: [ProductsService, StockService],
  exports: [ProductsService, StockService, MongooseModule],
})
export class ProductsModule {}
