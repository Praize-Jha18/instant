import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import sharp from 'sharp';
import { AppError } from '../../common/errors/app-error.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { Image, type ImageDocument, type ImageOwnerType } from './schemas/image.schema.js';

export const MAX_IMAGE_BYTES = 2 * 1024 * 1024;
export const MAX_IMAGE_EDGE = 1200;
export const THUMB_EDGE = 200;
export const ALLOWED_IMAGE_TYPES = new Set(['image/jpeg', 'image/png', 'image/webp']);

export interface StoreImageInput {
  buffer: Buffer;
  mimetype: string;
  ownerType: ImageOwnerType;
  ownerId?: Types.ObjectId | null;
  uploadedBy: Types.ObjectId;
}

export interface ImageBinary {
  id: string;
  buffer: Buffer;
  contentType: string;
  version: number;
  updatedAt: Date;
}

/**
 * Images live in MongoDB as Buffers for now. Swapping to blob storage means
 * changing only this service (§4).
 */
@Injectable()
export class ImagesService {
  constructor(@InjectModel(Image.name) private readonly images: Model<Image>) {}

  async store(input: StoreImageInput): Promise<ImageDocument> {
    if (!ALLOWED_IMAGE_TYPES.has(input.mimetype)) {
      throw AppError.badRequest('UNSUPPORTED_IMAGE_TYPE', 'Only JPEG, PNG and WebP images are accepted');
    }
    if (input.buffer.byteLength > MAX_IMAGE_BYTES) {
      throw AppError.tooLarge('IMAGE_TOO_LARGE', 'Images must be 2 MB or smaller');
    }

    const keepPng = input.mimetype === 'image/png';
    const base = sharp(input.buffer, { failOn: 'error' }).rotate();
    const main = base
      .clone()
      .resize({ width: MAX_IMAGE_EDGE, height: MAX_IMAGE_EDGE, fit: 'inside', withoutEnlargement: true });
    const thumb = base.clone().resize({ width: THUMB_EDGE, height: THUMB_EDGE, fit: 'cover' });

    const [mainOut, thumbOut] = await Promise.all([
      (keepPng ? main.png({ compressionLevel: 9 }) : main.jpeg({ quality: 85, mozjpeg: true })).toBuffer({
        resolveWithObject: true,
      }),
      (keepPng ? thumb.png({ compressionLevel: 9 }) : thumb.jpeg({ quality: 80, mozjpeg: true })).toBuffer(),
    ]).catch(() => {
      throw AppError.badRequest('INVALID_IMAGE', 'Could not decode image');
    });

    return this.images.create({
      data: mainOut.data,
      thumb: thumbOut,
      contentType: keepPng ? 'image/png' : 'image/jpeg',
      size: mainOut.data.byteLength,
      width: mainOut.info.width,
      height: mainOut.info.height,
      ownerType: input.ownerType,
      ownerId: input.ownerId ?? null,
      uploadedBy: input.uploadedBy,
    });
  }

  async getBinary(id: string, size: 'full' | 'thumb'): Promise<ImageBinary> {
    const field = size === 'thumb' ? 'thumb' : 'data';
    const doc = await this.images
      .findOne({ _id: oid(id, 'imageId'), ...notDeleted })
      .select(`+${field} contentType version updatedAt`)
      .exec();
    if (!doc) throw AppError.notFound('IMAGE_NOT_FOUND', 'Image not found');
    return {
      id: String(doc._id),
      buffer: size === 'thumb' ? doc.thumb : doc.data,
      contentType: doc.contentType,
      version: doc.version,
      updatedAt: doc.updatedAt,
    };
  }

  async softDelete(id: Types.ObjectId | string): Promise<void> {
    await this.images.updateOne({ _id: id, ...notDeleted }, { $set: { deletedAt: new Date() } }).exec();
  }

  async attachOwner(id: Types.ObjectId, ownerType: ImageOwnerType, ownerId: Types.ObjectId): Promise<void> {
    await this.images.updateOne({ _id: id }, { $set: { ownerType, ownerId } }).exec();
  }
}
