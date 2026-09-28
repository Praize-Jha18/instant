import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { MongooseModule } from '@nestjs/mongoose';
import { PassportModule } from '@nestjs/passport';
import { AppConfig } from '../../config/app-config.service.js';
import { RidersModule } from '../riders/riders.module.js';
import { UsersModule } from '../users/users.module.js';
import { VendorsModule } from '../vendors/vendors.module.js';
import { AuthController } from './auth.controller.js';
import { AuthService } from './auth.service.js';
import { AUTH_PROVIDER } from './providers/auth-provider.interface.js';
import { LocalPasswordProvider } from './providers/local-password.provider.js';
import { RefreshTokenService } from './refresh-token.service.js';
import { RefreshToken, RefreshTokenSchema } from './schemas/refresh-token.schema.js';
import { JwtStrategy } from './strategies/jwt.strategy.js';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: RefreshToken.name, schema: RefreshTokenSchema }]),
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      inject: [AppConfig],
      useFactory: (config: AppConfig) => ({
        secret: config.jwtSecret,
        signOptions: { expiresIn: config.jwtAccessTtl, algorithm: 'HS256' },
      }),
    }),
    UsersModule,
    VendorsModule,
    RidersModule,
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    RefreshTokenService,
    JwtStrategy,
    LocalPasswordProvider,
    { provide: AUTH_PROVIDER, useExisting: LocalPasswordProvider },
  ],
  exports: [AuthService, RefreshTokenService, JwtModule],
})
export class AuthModule {}
