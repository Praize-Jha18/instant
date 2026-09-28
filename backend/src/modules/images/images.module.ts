import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ImagesController } from './images.controller.js';
import { ImagesService } from './images.service.js';
import { Image, ImageSchema } from './schemas/image.schema.js';

@Module({
  imports: [MongooseModule.forFeature([{ name: Image.name, schema: ImageSchema }])],
  controllers: [ImagesController],
  providers: [ImagesService],
  exports: [ImagesService, MongooseModule],
})
export class ImagesModule {}
