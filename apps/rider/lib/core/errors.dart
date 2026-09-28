import 'package:api_client/api_client.dart';

/// Human-readable message for anything thrown by the API layer.
String friendlyError(Object error) {
  if (error is ApiException) {
    if (error.isOffline) return 'You are offline. Check your connection and try again.';
    switch (error) {
      case UnauthorizedException():
        return 'Your session has expired. Please sign in again.';
      case ForbiddenException():
        return 'You do not have permission to do that.';
      case NotFoundException():
        return 'We could not find that. It may have been removed.';
      case ConflictException():
        return error.message.isNotEmpty ? error.message : 'That action is no longer possible.';
      case ValidationException():
        return error.message.isNotEmpty ? error.message : 'Please check the details and try again.';
      case RateLimitedException():
        return 'Too many attempts. Please wait a moment.';
      case ServerException():
        return 'The server had a problem. Please try again shortly.';
      default:
        return error.message.isNotEmpty ? error.message : 'Something went wrong.';
    }
  }
  return 'Something went wrong. Please try again.';
}

/// True when [error] means "no connectivity" rather than a server verdict.
bool isOfflineError(Object error) => error is ApiException && error.isOffline;
