import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { NotificationsModule } from '../notifications/notifications.module.js';
import { VendorLedgerController } from './ledger.controller.js';
import { LedgerService } from './ledger.service.js';
import { Payout, PayoutSchema } from './schemas/payout.schema.js';
import { VendorLedgerEntry, VendorLedgerEntrySchema } from './schemas/vendor-ledger.schema.js';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: VendorLedgerEntry.name, schema: VendorLedgerEntrySchema },
      { name: Payout.name, schema: PayoutSchema },
    ]),
    NotificationsModule,
  ],
  controllers: [VendorLedgerController],
  providers: [LedgerService],
  exports: [LedgerService, MongooseModule],
})
export class LedgerModule {}
