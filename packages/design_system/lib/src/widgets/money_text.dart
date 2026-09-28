import 'package:core_models/core_models.dart';
import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Renders a [Money] as `₦12,500.00` with tabular figures.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.money, {
    super.key,
    this.style,
    this.showDecimals = true,
    this.emphasize = false,
    this.strikeThrough = false,
    this.color,
    this.textAlign,
  });

  /// From a raw kobo integer.
  MoneyText.kobo(
    int kobo, {
    Key? key,
    TextStyle? style,
    bool showDecimals = true,
    bool emphasize = false,
    bool strikeThrough = false,
    Color? color,
    TextAlign? textAlign,
  }) : this(
          Money.fromKobo(kobo),
          key: key,
          style: style,
          showDecimals: showDecimals,
          emphasize: emphasize,
          strikeThrough: strikeThrough,
          color: color,
          textAlign: textAlign,
        );

  final Money money;
  final TextStyle? style;
  final bool showDecimals;

  /// Use the semantic money colour and a heavier weight.
  final bool emphasize;

  /// For old prices / discounts.
  final bool strikeThrough;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = style ?? theme.textTheme.bodyLarge ?? const TextStyle();
    final resolvedColor = color ??
        (strikeThrough
            ? theme.colorScheme.onSurfaceVariant
            : emphasize
                ? context.semanticColors.money
                : base.color);
    return Text(
      money.format(showDecimals: showDecimals),
      textAlign: textAlign,
      style: base.copyWith(
        color: resolvedColor,
        fontWeight: emphasize ? FontWeight.w700 : base.fontWeight,
        fontFeatures: AppTypography.tabularFigures,
        decoration: strikeThrough ? TextDecoration.lineThrough : null,
      ),
      semanticsLabel: '${money.naira.toStringAsFixed(2)} naira',
    );
  }
}
