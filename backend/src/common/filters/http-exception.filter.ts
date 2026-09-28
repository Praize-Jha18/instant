import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { Error as MongooseError } from 'mongoose';
import type { ErrorBody } from '../errors/app-error.js';

const STATUS_CODES: Record<number, string> = {
  400: 'BAD_REQUEST',
  401: 'UNAUTHORIZED',
  403: 'FORBIDDEN',
  404: 'NOT_FOUND',
  405: 'METHOD_NOT_ALLOWED',
  409: 'CONFLICT',
  413: 'PAYLOAD_TOO_LARGE',
  415: 'UNSUPPORTED_MEDIA_TYPE',
  422: 'UNPROCESSABLE_ENTITY',
  429: 'TOO_MANY_REQUESTS',
  500: 'INTERNAL_ERROR',
  503: 'SERVICE_UNAVAILABLE',
};

interface MongoServerErrorLike {
  code?: number;
  keyValue?: Record<string, unknown>;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

/**
 * Normalises every error into `{ statusCode, code, message, details? }`.
 */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const res = ctx.getResponse<Response>();
    const req = ctx.getRequest<Request>();
    const body = this.toBody(exception);

    if (body.statusCode >= 500) {
      const err = exception instanceof Error ? exception : new Error(String(exception));
      this.logger.error(`${req.method} ${req.url} -> ${body.code}: ${err.message}`, err.stack);
    }

    res.status(body.statusCode).json(body);
  }

  toBody(exception: unknown): ErrorBody {
    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const response = exception.getResponse();
      if (isRecord(response)) {
        const code =
          typeof response['code'] === 'string'
            ? response['code']
            : status === HttpStatus.BAD_REQUEST && Array.isArray(response['message'])
              ? 'VALIDATION_ERROR'
              : (STATUS_CODES[status] ?? 'ERROR');
        const rawMessage = response['message'];
        const message = Array.isArray(rawMessage)
          ? 'Validation failed'
          : typeof rawMessage === 'string'
            ? rawMessage
            : exception.message;
        const body: ErrorBody = { statusCode: status, code, message };
        if (response['details'] !== undefined) body.details = response['details'];
        else if (Array.isArray(rawMessage)) body.details = rawMessage;
        return body;
      }
      return {
        statusCode: status,
        code: STATUS_CODES[status] ?? 'ERROR',
        message: typeof response === 'string' ? response : exception.message,
      };
    }

    if (exception instanceof MongooseError.ValidationError) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        code: 'VALIDATION_ERROR',
        message: exception.message,
        details: Object.keys(exception.errors),
      };
    }

    if (exception instanceof MongooseError.CastError) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        code: 'INVALID_ID',
        message: `Invalid value for ${exception.path}`,
      };
    }

    const mongoErr = exception as MongoServerErrorLike;
    if (isRecord(exception) && mongoErr.code === 11000) {
      return {
        statusCode: HttpStatus.CONFLICT,
        code: 'DUPLICATE_KEY',
        message: 'A record with the same unique value already exists',
        details: mongoErr.keyValue,
      };
    }

    return {
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      code: 'INTERNAL_ERROR',
      message: 'Internal server error',
    };
  }
}
