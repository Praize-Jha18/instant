import { HttpException, HttpStatus } from '@nestjs/common';

export interface ErrorBody {
  statusCode: number;
  code: string;
  message: string;
  details?: unknown;
}

/**
 * HttpException carrying a stable SNAKE_CASE `code` (ARCHITECTURE §5).
 */
export class AppError extends HttpException {
  readonly code: string;
  readonly details?: unknown;

  constructor(
    status: HttpStatus,
    code: string,
    message: string,
    details?: unknown,
  ) {
    const body: ErrorBody = { statusCode: status, code, message };
    if (details !== undefined) body.details = details;
    super(body, status);
    this.code = code;
    this.details = details;
  }

  static badRequest(code: string, message: string, details?: unknown): AppError {
    return new AppError(HttpStatus.BAD_REQUEST, code, message, details);
  }

  static unauthorized(code: string, message: string): AppError {
    return new AppError(HttpStatus.UNAUTHORIZED, code, message);
  }

  static forbidden(code: string, message: string): AppError {
    return new AppError(HttpStatus.FORBIDDEN, code, message);
  }

  static notFound(code: string, message: string): AppError {
    return new AppError(HttpStatus.NOT_FOUND, code, message);
  }

  static conflict(code: string, message: string, details?: unknown): AppError {
    return new AppError(HttpStatus.CONFLICT, code, message, details);
  }

  static unprocessable(
    code: string,
    message: string,
    details?: unknown,
  ): AppError {
    return new AppError(
      HttpStatus.UNPROCESSABLE_ENTITY,
      code,
      message,
      details,
    );
  }

  static tooLarge(code: string, message: string): AppError {
    return new AppError(HttpStatus.PAYLOAD_TOO_LARGE, code, message);
  }

  static unavailable(code: string, message: string): AppError {
    return new AppError(HttpStatus.SERVICE_UNAVAILABLE, code, message);
  }
}
