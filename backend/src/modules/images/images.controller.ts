import { Controller, Get, Headers, Param, Query, Res } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import type { Response } from 'express';
import { Public } from '../../common/decorators/public.decorator.js';
import { ImagesService } from './images.service.js';

const ONE_YEAR = 60 * 60 * 24 * 365;

@ApiTags('images')
@Controller('images')
export class ImagesController {
  constructor(private readonly images: ImagesService) {}

  @Public()
  @Get(':id')
  async get(
    @Param('id') id: string,
    @Query('size') size: string | undefined,
    @Headers('if-none-match') ifNoneMatch: string | undefined,
    @Res() res: Response,
  ): Promise<void> {
    const variant = size === 'thumb' ? 'thumb' : 'full';
    const image = await this.images.getBinary(id, variant);
    const etag = `"${image.id}-${variant}-v${image.version}"`;

    res.setHeader('Cache-Control', `public, max-age=${ONE_YEAR}, immutable`);
    res.setHeader('ETag', etag);
    res.setHeader('Last-Modified', image.updatedAt.toUTCString());
    if (ifNoneMatch && ifNoneMatch.split(',').some((t) => t.trim() === etag)) {
      res.status(304).end();
      return;
    }
    res.setHeader('Content-Type', image.contentType);
    res.setHeader('Content-Length', String(image.buffer.byteLength));
    res.status(200).end(image.buffer);
  }
}
