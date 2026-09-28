import 'package:core_models/core_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_vendor/core/utils/money_input.dart';
import 'package:instant_vendor/features/products/data/products_repository.dart';
import 'package:instant_vendor/features/products/domain/product_draft.dart';
import 'package:instant_vendor/features/products/presentation/product_form_screen.dart';

import 'test_helpers.dart';

void main() {
  group('naira → kobo', () {
    test('parses plain, grouped and decimal amounts', () {
      expect(parseNairaToKobo('12500'), 1250000);
      expect(parseNairaToKobo('12,500.50'), 1250050);
      expect(parseNairaToKobo('₦1 200.5'), 120050);
      expect(parseNairaToKobo('0.05'), 5);
      expect(parseNairaToKobo('0'), 0);
    });

    test('rejects invalid input', () {
      expect(parseNairaToKobo(''), isNull);
      expect(parseNairaToKobo('abc'), isNull);
      expect(parseNairaToKobo('12.345'), isNull);
      expect(parseNairaToKobo('-5'), isNull);
    });

    test('kobo renders back as editable naira text', () {
      expect(koboToNairaText(1250000), '12500');
      expect(koboToNairaText(1250050), '12500.50');
    });
  });

  group('ProductDraft', () {
    test('validates required fields and variant rows', () {
      final draft = ProductDraft();
      expect(draft.validate(), containsPair('name', 'Name is required'));
      expect(draft.validate(), containsPair('basePrice', 'Enter a valid price'));

      draft
        ..name = 'Jollof'
        ..basePriceKobo = 150000
        ..hasVariants = true;
      expect(draft.validate(), containsPair('variants', 'Add at least one variant'));

      draft.variants.add(VariantDraft(name: '', priceKobo: null));
      final errors = draft.validate();
      expect(errors['variant.0.name'], 'Variant name is required');
      expect(errors['variant.0.price'], 'Enter a valid price');

      draft.variants[0]
        ..name = 'Large'
        ..priceKobo = 200000
        ..stock = 3;
      expect(draft.validate(), isEmpty);
    });

    test('toInput sends kobo integers and variant rows', () {
      final draft = ProductDraft(
        name: ' Suya ',
        basePriceKobo: parseNairaToKobo('2,500'),
        hasVariants: true,
        variants: [
          VariantDraft(name: 'Beef', sku: 'SUYA-B', priceKobo: parseNairaToKobo('2500'), stock: 10, attributes: {'meat': 'beef'}),
          VariantDraft(name: 'Chicken', priceKobo: parseNairaToKobo('3,000.50'), stock: 4),
        ],
        tags: ['spicy', ''],
        status: ProductStatus.active,
      );
      final input = draft.toInput(creating: true);
      expect(input.name, 'Suya');
      expect(input.basePriceKobo, 250000);
      expect(input.hasVariants, isTrue);
      expect(input.variants, hasLength(2));
      expect(input.variants![0].priceKobo, 250000);
      expect(input.variants![0].sku, 'SUYA-B');
      expect(input.variants![0].attributes, {'meat': 'beef'});
      expect(input.variants![1].priceKobo, 300050);
      expect(input.stock, isNull, reason: 'stock lives on variants');
      expect(input.tags, ['spicy']);
      expect(input.status, ProductStatus.active);
    });

    test('request body omits empty ids on new variants', () {
      final draft = ProductDraft(
        name: 'Suya',
        basePriceKobo: 100,
        hasVariants: true,
        variants: [VariantDraft(name: 'New', priceKobo: 100), VariantDraft(id: '507f1f77bcf86cd799439011', name: 'Old', priceKobo: 100)],
      );
      final body = ProductsRepository.productInputBody(draft.toInput());
      final variants = (body['variants'] as List).cast<Map<String, Object?>>();
      expect(variants[0].containsKey('id'), isFalse);
      expect(variants[1]['id'], '507f1f77bcf86cd799439011');
    });

    test('text-only changes are detected for the offline path', () {
      final original = Product(id: 'p1', vendorId: 'v1', name: 'Rice', slug: 'rice', basePriceKobo: 1000, stock: 5);
      final draft = ProductDraft.fromProduct(original)..name = 'Fried rice';
      expect(draft.isTextOnlyChangeFrom(original), isTrue);
      draft.basePriceKobo = 2000;
      expect(draft.isTextOnlyChangeFrom(original), isFalse);
    });
  });

  group('ProductFormScreen', () {
    testWidgets('shows validation errors and blocks saving an empty form', (tester) async {
      setSurface(tester, const Size(1400, 2200));
      await tester.pumpWidget(testApp(const ProductFormScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('save-product')));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Enter a valid price'), findsOneWidget);
    });

    testWidgets('converts the typed naira price to kobo', (tester) async {
      setSurface(tester, const Size(1400, 2200));
      await tester.pumpWidget(testApp(const ProductFormScreen()));
      await tester.pumpAndSettle();

      final priceField = find.descendant(of: find.byKey(const ValueKey('price-field')), matching: find.byType(TextFormField));
      await tester.enterText(priceField, '12,500.50');
      await tester.pumpAndSettle();

      expect(find.text('= ₦12,500.50 (1250050 kobo)'), findsOneWidget);
    });

    testWidgets('variant toggle adds editable rows', (tester) async {
      setSurface(tester, const Size(1400, 2600));
      await tester.pumpWidget(testApp(const ProductFormScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(VariantRow), findsNothing);
      await tester.tap(find.byKey(const ValueKey('has-variants')));
      await tester.pumpAndSettle();
      expect(find.byType(VariantRow), findsOneWidget);
      expect(find.text('Variant 1'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('add-variant')));
      await tester.pumpAndSettle();
      expect(find.byType(VariantRow), findsNWidgets(2));
      expect(find.text('Variant 2'), findsOneWidget);

      await tester.tap(find.byTooltip('Remove variant').first);
      await tester.pumpAndSettle();
      expect(find.byType(VariantRow), findsOneWidget);
    });
  });
}
