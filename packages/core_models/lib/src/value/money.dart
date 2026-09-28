import 'package:meta/meta.dart';

/// An amount of Nigerian Naira stored as integer kobo.
///
/// Money is always integer kobo on the wire (see ARCHITECTURE §4). This class
/// wraps that integer with formatting and arithmetic helpers.
@immutable
class Money implements Comparable<Money> {
  /// Creates a [Money] from an integer number of kobo.
  const Money.fromKobo(this.kobo);

  /// Creates a [Money] from a naira amount, rounding to the nearest kobo.
  Money.fromNaira(num naira) : kobo = (naira * 100).round();

  /// Zero naira.
  static const Money zero = Money.fromKobo(0);

  /// Currency symbol used by [format].
  static const String symbol = '₦';

  /// ISO currency code.
  static const String currency = 'NGN';

  /// Amount in kobo (1/100 naira).
  final int kobo;

  /// Amount in naira as a double (for display or calculations only).
  double get naira => kobo / 100;

  bool get isZero => kobo == 0;
  bool get isNegative => kobo < 0;
  bool get isPositive => kobo > 0;

  Money operator +(Money other) => Money.fromKobo(kobo + other.kobo);
  Money operator -(Money other) => Money.fromKobo(kobo - other.kobo);
  Money operator -() => Money.fromKobo(-kobo);
  Money operator *(num factor) => Money.fromKobo((kobo * factor).round());
  bool operator <(Money other) => kobo < other.kobo;
  bool operator <=(Money other) => kobo <= other.kobo;
  bool operator >(Money other) => kobo > other.kobo;
  bool operator >=(Money other) => kobo >= other.kobo;

  /// Applies a basis-point rate (e.g. `1000` = 10%), rounding to the nearest kobo.
  Money percentBps(int bps) => Money.fromKobo((kobo * bps / 10000).round());

  /// Sums a list of amounts.
  static Money sum(Iterable<Money> amounts) =>
      amounts.fold(Money.zero, (acc, m) => acc + m);

  /// Formats as `₦12,500.00`. With [showDecimals] false → `₦12,500`.
  /// With [showSymbol] false the currency symbol is omitted.
  String format({bool showDecimals = true, bool showSymbol = true}) {
    final abs = kobo.abs();
    final whole = abs ~/ 100;
    final cents = abs % 100;
    final wholeStr = _groupThousands(whole.toString());
    final buffer = StringBuffer();
    if (kobo < 0) buffer.write('-');
    if (showSymbol) buffer.write(symbol);
    buffer.write(wholeStr);
    if (showDecimals) {
      buffer
        ..write('.')
        ..write(cents.toString().padLeft(2, '0'));
    }
    return buffer.toString();
  }

  static String _groupThousands(String digits) {
    final out = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      out.write(digits[i]);
      if (remaining > 1 && remaining % 3 == 1) out.write(',');
    }
    return out.toString();
  }

  @override
  int compareTo(Money other) => kobo.compareTo(other.kobo);

  @override
  bool operator ==(Object other) => other is Money && other.kobo == kobo;

  @override
  int get hashCode => kobo.hashCode;

  @override
  String toString() => format();
}

/// Convenience accessors for kobo integers coming straight from models.
extension KoboInt on int {
  /// Wraps this kobo integer as [Money].
  Money get money => Money.fromKobo(this);
}
