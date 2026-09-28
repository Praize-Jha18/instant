import { Global, Module } from '@nestjs/common';
import { RealtimeService } from './realtime.service.js';

/** Global, dependency-free emitter so any service can publish changes. */
@Global()
@Module({
  providers: [RealtimeService],
  exports: [RealtimeService],
})
export class RealtimeCoreModule {}
