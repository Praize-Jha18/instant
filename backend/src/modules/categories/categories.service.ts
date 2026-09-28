import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { AppError } from '../../common/errors/app-error.js';
import type { Page } from '../../common/pagination/cursor.js';
import { notDeleted } from '../../common/schemas/base.js';
import { oid } from '../../common/utils/ids.js';
import { slugify } from '../../common/utils/slug.js';
import type { CreateCategoryDto, UpdateCategoryDto } from './dto/category.dto.js';
import { Category, type CategoryDocument } from './schemas/category.schema.js';

@Injectable()
export class CategoriesService {
  constructor(@InjectModel(Category.name) private readonly categories: Model<Category>) {}

  async list(): Promise<Page<CategoryDocument>> {
    const items = await this.categories.find(notDeleted).sort({ sortOrder: 1, name: 1 }).limit(500).exec();
    return { items, nextCursor: null };
  }

  async getById(id: string): Promise<CategoryDocument> {
    const doc = await this.categories.findOne({ _id: oid(id, 'categoryId'), ...notDeleted }).exec();
    if (!doc) throw AppError.notFound('CATEGORY_NOT_FOUND', 'Category not found');
    return doc;
  }

  async existsAll(ids: string[]): Promise<boolean> {
    if (ids.length === 0) return true;
    const count = await this.categories.countDocuments({ _id: { $in: ids.map((i) => oid(i, 'categoryId')) }, ...notDeleted }).exec();
    return count === new Set(ids).size;
  }

  async create(dto: CreateCategoryDto): Promise<CategoryDocument> {
    const slug = dto.slug ?? slugify(dto.name);
    const clash = await this.categories.findOne({ slug }).exec();
    if (clash) {
      if (clash.deletedAt) {
        // Revive a soft-deleted category with the same slug instead of failing the unique index.
        clash.set({ name: dto.name, parentId: dto.parentId ? new Types.ObjectId(dto.parentId) : null, sortOrder: dto.sortOrder ?? 0, imageId: dto.imageId ? new Types.ObjectId(dto.imageId) : null, deletedAt: null });
        return clash.save();
      }
      throw AppError.conflict('CATEGORY_SLUG_TAKEN', `Slug ${slug} already exists`);
    }
    return this.categories.create({
      name: dto.name,
      slug,
      parentId: dto.parentId ? new Types.ObjectId(dto.parentId) : null,
      sortOrder: dto.sortOrder ?? 0,
      imageId: dto.imageId ? new Types.ObjectId(dto.imageId) : null,
    });
  }

  async update(id: string, dto: UpdateCategoryDto): Promise<CategoryDocument> {
    const doc = await this.getById(id);
    if (dto.name !== undefined) doc.name = dto.name;
    if (dto.slug !== undefined) doc.slug = dto.slug;
    if (dto.parentId !== undefined) doc.parentId = dto.parentId ? new Types.ObjectId(dto.parentId) : null;
    if (dto.sortOrder !== undefined) doc.sortOrder = dto.sortOrder;
    if (dto.imageId !== undefined) doc.imageId = dto.imageId ? new Types.ObjectId(dto.imageId) : null;
    return doc.save();
  }

  async remove(id: string): Promise<CategoryDocument> {
    const doc = await this.getById(id);
    doc.deletedAt = new Date();
    return doc.save();
  }

  /** Idempotent helper for the seed script. */
  async upsertBySlug(input: { name: string; slug: string; sortOrder: number }): Promise<CategoryDocument> {
    const doc = await this.categories
      .findOneAndUpdate(
        { slug: input.slug },
        { $set: { name: input.name, sortOrder: input.sortOrder, deletedAt: null } },
        { new: true, upsert: true },
      )
      .exec();
    return doc as CategoryDocument;
  }
}
