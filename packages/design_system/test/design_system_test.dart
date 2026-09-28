import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  setUpAll(() => AppTypography.configure(useGoogleFonts: false, allowRuntimeFetching: false));

  group('theme', () {
    test('light and dark build from tokens with semantic extension', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();
      expect(light.useMaterial3, isTrue);
      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(light.extension<AppSemanticColors>(), AppSemanticColors.light);
      expect(dark.extension<AppSemanticColors>(), AppSemanticColors.dark);
      expect(light.textTheme.bodyLarge?.fontFamilyFallback, contains('Roboto'));
      final shape = light.cardTheme.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, AppRadius.mdAll);
    });

    test('tokens match §9', () {
      expect(AppSpacing.xs, 4);
      expect(AppSpacing.lg, 16);
      expect([AppRadius.sm, AppRadius.md, AppRadius.lg], [12, 16, 24]);
      expect(AppMotion.fast.inMilliseconds, 150);
      expect(AppMotion.normal.inMilliseconds, 250);
      expect(AppMotion.slow.inMilliseconds, 400);
      expect(AppMotion.curve, Curves.easeOutCubic);
    });
  });

  group('widgets', () {
    testWidgets('AppButton taps, disables while loading, shows tooltip when disabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(AppButton(label: 'Pay', onPressed: () => taps++)));
      await tester.tap(find.text('Pay'));
      await tester.pump();
      expect(taps, 1);

      await tester.pumpWidget(_wrap(AppButton(label: 'Pay', loading: true, onPressed: () => taps++)));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Pay'), warnIfMissed: false);
      await tester.pump();
      expect(taps, 1);

      await tester.pumpWidget(_wrap(const AppButton(label: 'Pay', tooltip: 'You are offline')));
      expect(find.byTooltip('You are offline'), findsOneWidget);
    });

    testWidgets('all AppButton variants render', (tester) async {
      await tester.pumpWidget(_wrap(Column(children: [
        AppButton.primary(label: 'a', onPressed: () {}),
        AppButton.secondary(label: 'b', onPressed: () {}),
        AppButton.ghost(label: 'c', onPressed: () {}),
        AppButton.danger(label: 'd', onPressed: () {}),
      ])));
      expect(find.byType(FilledButton), findsNWidgets(2));
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('StatusChip maps statuses to labels', (tester) async {
      await tester.pumpWidget(_wrap(Column(children: [
        StatusChip.subOrder(SubOrderStatus.outForDelivery),
        StatusChip.delivery(DeliveryStatus.pickedUp),
        StatusChip.payment(PaymentStatus.partiallyRefunded),
        StatusChip.subOrder(SubOrderStatus.awaitingPayment),
      ])));
      expect(find.text('Out for delivery'), findsOneWidget);
      expect(find.text('Picked up'), findsOneWidget);
      expect(find.text('Partially refunded'), findsOneWidget);
      expect(find.text('Awaiting payment'), findsOneWidget);
      expect(StatusChip.subOrderTone(SubOrderStatus.cancelled), StatusTone.danger);
      expect(StatusChip.deliveryTone(DeliveryStatus.delivered), StatusTone.success);
    });

    testWidgets('MoneyText formats kobo', (tester) async {
      await tester.pumpWidget(_wrap(Column(children: [
        MoneyText.kobo(1250000),
        const MoneyText(Money.fromKobo(99), showDecimals: false),
      ])));
      expect(find.text('₦12,500.00'), findsOneWidget);
      expect(find.text('₦0'), findsOneWidget);
    });

    testWidgets('QuantityStepper clamps and reports changes', (tester) async {
      var value = 1;
      var removed = 0;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => QuantityStepper(
          value: value,
          max: 2,
          onChanged: (v) => setState(() => value = v),
          onRemove: () => removed++,
        ),
      )));
      await tester.tap(find.byTooltip('Increase'));
      await tester.pumpAndSettle();
      expect(value, 2);
      await tester.tap(find.byTooltip('Increase'));
      await tester.pumpAndSettle();
      expect(value, 2, reason: 'clamped at max');
      await tester.tap(find.byTooltip('Decrease'));
      await tester.pumpAndSettle();
      expect(value, 1);
      await tester.tap(find.byTooltip('Remove'));
      await tester.pumpAndSettle();
      expect(removed, 1);
    });

    testWidgets('ConnectivityBanner shows offline and pending copy, hides when idle', (tester) async {
      // The syncing state shows an indeterminate spinner, so pump fixed
      // durations rather than settling.
      await tester.pumpWidget(_wrap(const ConnectivityBanner(offline: true, pendingCount: 3)));
      await tester.pump(AppMotion.normal);
      expect(find.textContaining('offline'), findsOneWidget);
      expect(find.textContaining('3 pending'), findsOneWidget);

      await tester.pumpWidget(_wrap(const ConnectivityBanner(offline: false, syncing: true, pendingCount: 2)));
      await tester.pump(AppMotion.normal);
      expect(find.text('Syncing 2 changes…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpWidget(_wrap(const ConnectivityBanner(offline: false)));
      await tester.pump(AppMotion.normal);
      await tester.pump(AppMotion.normal);
      expect(find.byIcon(Icons.wifi_off_rounded), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('ConnectivityBanner.stream rebuilds from a stream', (tester) async {
      final stream = Stream<({bool offline, int pending})>.fromIterable([(offline: true, pending: 1)]);
      await tester.pumpWidget(_wrap(ConnectivityBanner.stream(
        stream: stream,
        offline: (s) => s.offline,
        pendingCount: (s) => s.pending,
      )));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });

    testWidgets('EmptyState and ErrorState render with retry', (tester) async {
      var retries = 0;
      await tester.pumpWidget(_wrap(EmptyState(
          title: 'No orders yet', message: 'Browse vendors', action: AppButton(label: 'Browse', onPressed: () {}))));
      await tester.pumpAndSettle();
      expect(find.text('No orders yet'), findsOneWidget);
      expect(find.text('Browse'), findsOneWidget);

      await tester.pumpWidget(_wrap(ErrorState(offline: true, onRetry: () => retries++)));
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      await tester.pump();
      expect(retries, 1);

      // Height-constrained: scrolls instead of overflowing.
      await tester.pumpWidget(_wrap(SizedBox(height: 120, child: ErrorState(onRetry: () {}))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Skeleton, SkeletonList, AppCard, AppListTile, SectionHeader, AppTextField', (tester) async {
      var cardTaps = 0;
      var tileTaps = 0;
      await tester.pumpWidget(_wrap(ListView(children: [
        const SizedBox(height: 200, child: SkeletonList(itemCount: 2)),
        AppCard(onTap: () => cardTaps++, child: const Text('card')),
        AppListTile(title: 'Tile', subtitle: 'Sub', leadingIcon: Icons.person, onTap: () => tileTaps++),
        SectionHeader(title: 'Popular', actionLabel: 'See all', onAction: () {}),
        const AppTextField(label: 'Name', hint: 'Your name'),
        AppTextField.password(),
      ])));
      // Skeletons shimmer forever, so pump fixed frames instead of settling.
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Skeleton), findsWidgets);
      await tester.tap(find.text('card'));
      await tester.pump(AppMotion.fast);
      expect(cardTaps, 1);
      await tester.tap(find.text('Tile'));
      await tester.pump(AppMotion.fast);
      expect(tileTaps, 1);
      expect(find.text('See all'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      await tester.tap(find.byTooltip('Show password'));
      await tester.pump();
      expect(find.byTooltip('Hide password'), findsOneWidget);
    });

    testWidgets('AppImage shows error tile for empty url; FadeSlideIn settles', (tester) async {
      await tester.pumpWidget(_wrap(const FadeSlideIn(child: AppImage(url: '', width: 40, height: 40))));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('AppBottomSheet.confirm resolves', (tester) async {
      bool? result;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => AppButton(
              label: 'open',
              onPressed: () async {
                result = await AppBottomSheet.confirm(context, title: 'Cancel order?', message: 'Sure?');
              },
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel order?'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });
  });
}
