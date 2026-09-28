import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import type { Connection } from 'mongoose';
import { timestampsVersionPlugin } from '../common/plugins/timestamps-version.plugin.js';
import { AppConfig } from '../config/app-config.service.js';

@Module({
  imports: [
    MongooseModule.forRootAsync({
      inject: [AppConfig],
      useFactory: (config: AppConfig) => ({
        uri: config.mongodbUri,
        autoIndex: true,
        connectionFactory: (connection: Connection) => {
          connection.plugin(timestampsVersionPlugin);
          return connection;
        },
      }),
    }),
  ],
})
export class DatabaseModule {}
