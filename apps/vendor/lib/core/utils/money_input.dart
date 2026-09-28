import 'package:core_models/core_models.dart';
import 'package:flutter/services.dart';

/// Parses a naira amount typed by a user ("12,500", "₦1 200.50", "0.5") into
/// integer kobo. Returns null when the text is not a valid non-negative amount.
int? parseNairaToKobo(String text) {
  final cleaned = text.replaceAll(RegExp(r'[₦,\s_]'), '').trim();
  if (cleaned.isEmpty) return null;
  if (!RegExp(r'^\d+(\.\d{0,2})?$').hasMatch(cleaned)) return null;
  final parts = cleaned.split('.');
  final whole = int.tryParse(parts[0]);
  if (whole == null) return null;
  var cents = 0;
  if (parts.length == 2 && parts[1].isNotEmpty) {
    cents = int.parse(parts[1].padRight(2, '0'));
  }
  return whole * 100 + cents;
}

/// Formats kobo as an editable naira string (`12500.50`, `1200`).
String koboToNairaText(int kobo) {
  if (kobo % 100 == 0) return (kobo ~/ 100).toString();
  return Money.fromKobo(kobo).naira.toStringAsFixed(2);
}

/// Allows digits, one decimal point and up to two decimals.
final nairaInputFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp(r'[\d.,\s₦]')),
];
