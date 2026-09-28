import type { UserDocument } from '../../users/schemas/user.schema.js';

export const AUTH_PROVIDER = Symbol('AUTH_PROVIDER');

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegisterCredentials {
  email: string;
  password: string;
}

/** Material persisted on the user document for this provider. */
export interface CredentialMaterial {
  passwordHash: string;
}

/**
 * Authentication mechanism (§3). `LocalPasswordProvider` today, `FirebaseProvider` later.
 * Callers (AuthService) never know how credentials are verified.
 */
export interface AuthProvider {
  readonly name: string;
  /** Produces what must be stored for a new account. */
  createCredential(input: RegisterCredentials): Promise<CredentialMaterial>;
  /** Verifies credentials and returns the matching user or throws 401. */
  authenticate(input: LoginCredentials): Promise<UserDocument>;
}
