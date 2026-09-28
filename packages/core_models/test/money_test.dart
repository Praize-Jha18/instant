import 'package:core_models/core_models.dart';
import 'package:test/test.dart';

void main() {
  group('Money', () {
    test('formats with naira symbol, thousands and two decimals', () {
      expect(Money.fromKobo(1250000).format(), '₦12,500.00');
      expect(Money.fromKobo(0).format(), '₦0.00');
      expect(Money.fromKobo(5).format(), '₦0.05');
      expect(Money.fromKobo(123456789).format(), '₦1,234,567.89');
      expect(Money.fromKobo(-150000).format(), '-₦1,500.00');
      expect(Money.fromKobo(1250000).format(showDecimals: false), '₦12,500');
      expect(Money.fromKobo(1250000).format(showSymbol: false), '12,500.00');
    });

    test('arithmetic and comparison', () {
      final a = Money.fromKobo(1000);
      final b = Money.fromKobo(250);
      expect(a + b, Money.fromKobo(1250));
      expect(a - b, Money.fromKobo(750));
      expect(a * 3, Money.fromKobo(3000));
      expect(a * 0.5, Money.fromKobo(500));
      expect(-a, Money.fromKobo(-1000));
      expect(a > b, isTrue);
      expect(b < a, isTrue);
      expect(a.percentBps(1000), Money.fromKobo(100));
      expect(Money.sum([a, b, b]), Money.fromKobo(1500));
      expect(Money.fromNaira(12.5), Money.fromKobo(1250));
      expect(1250.money.naira, 12.5);
    });
  });
}
