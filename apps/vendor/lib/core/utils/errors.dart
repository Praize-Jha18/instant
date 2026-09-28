import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

/// Human-readable message for any thrown object.
String errorMessage(Object? error) {
  if (error == null) return 'Something went wrong.';
  if (error is ApiException) {
    if (error.isOffline) return 'You are offline. Connect to the internet and try again.';
    if (error.isUnauthorized) return 'Your session has expired. Please sign in again.';
    if (error is ValidationException) {
      final details = error.details;
      if (details is List && details.isNotEmpty) return details.join('\n');
      if (details is Map && details.isNotEmpty) {
        return details.entries.map((e) => '${e.key}: ${e.value}').join('\n');
      }
    }
    return error.message.isEmpty ? error.code : error.message;
  }
  return error.toString();
}

bool isOfflineError(Object? error) => error is ApiException && error.isOffline;

void showSnack(BuildContext context, String message, {bool error = false}) {
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  final scheme = Theme.of(context).colorScheme;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? scheme.error : null,
      ),
    );
}

void showError(BuildContext context, Object? error) =>
    showSnack(context, errorMessage(error), error: true);
