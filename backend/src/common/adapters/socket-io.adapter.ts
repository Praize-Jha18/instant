import type { INestApplicationContext } from '@nestjs/common';
import { IoAdapter } from '@nestjs/platform-socket.io';
import type { Server, ServerOptions } from 'socket.io';

/** Socket.IO adapter that applies the CORS allow-list from the environment. */
export class ConfiguredIoAdapter extends IoAdapter {
  constructor(
    app: INestApplicationContext,
    private readonly origins: true | string[],
  ) {
    super(app);
  }

  override createIOServer(port: number, options?: ServerOptions): Server {
    const merged = { ...options, cors: { origin: this.origins, credentials: true } } as ServerOptions;
    return super.createIOServer(port, merged) as Server;
  }
}
