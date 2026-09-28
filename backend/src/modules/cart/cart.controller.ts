import { Body, Controller, Get, Put } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { CartService } from './cart.service.js';
import { ReplaceCartDto } from './dto/cart.dto.js';

@ApiTags('customer')
@ApiBearerAuth()
@Controller('me/cart')
export class CartController {
  constructor(private readonly cart: CartService) {}

  @Get()
  get(@CurrentUser('userId') userId: string) {
    return this.cart.get(userId);
  }

  @Put()
  replace(@CurrentUser('userId') userId: string, @Body() dto: ReplaceCartDto) {
    return this.cart.replace(userId, dto.items);
  }
}
