import { Injectable } from '@nestjs/common';
import bcrypt from 'bcrypt';
import { AppError } from '../../../common/errors/app-error.js';
import type { UserDocument } from '../../users/schemas/user.schema.js';
import { UsersService } from '../../users/users.service.js';
import type {
  AuthProvider,
  CredentialMaterial,
  LoginCredentials,
  RegisterCredentials,
} from './auth-provider.interface.js';

export const BCRYPT_COST = 12;

@Injectable()
export class LocalPasswordProvider implements AuthProvider {
  readonly name = 'local';

  constructor(private readonly users: UsersService) {}

  async createCredential(input: RegisterCredentials): Promise<CredentialMaterial> {
    return { passwordHash: await bcrypt.hash(input.password, BCRYPT_COST) };
  }

  async authenticate(input: LoginCredentials): Promise<UserDocument> {
    const user = await this.users.findByEmailWithSecret(input.email);
    const ok = user ? await bcrypt.compare(input.password, user.passwordHash) : false;
    if (!user || !ok) {
      throw AppError.unauthorized('INVALID_CREDENTIALS', 'Email or password is incorrect');
    }
    user.set('passwordHash', undefined);
    return user;
  }
}
