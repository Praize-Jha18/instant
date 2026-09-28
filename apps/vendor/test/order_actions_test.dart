import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_vendor/features/orders/presentation/order_widgets.dart';

Widget _wrap(Widget child) {
  AppTypography.configure(useGoogleFonts: false, allowRuntimeFetching: false);
  return MaterialApp(theme: AppTheme.light(), home: Scaffold(body: child));
}

Finder _action(SubOrderStatus s) => find.byKey(ValueKey('action-${s.json}'));

void main() {
  testWidgets('placed offers accept and cancel only', (tester) async {
    await tester.pumpWidget(_wrap(OrderActions(status: SubOrderStatus.placed, onAction: (_) async {})));
    expect(_action(SubOrderStatus.accepted), findsOneWidget);
    expect(_action(SubOrderStatus.cancelled), findsOneWidget);
    expect(_action(SubOrderStatus.preparing), findsNothing);
    expect(_action(SubOrderStatus.ready), findsNothing);
    expect(_action(SubOrderStatus.delivered), findsNothing);
  });

  testWidgets('preparing offers ready and cancel', (tester) async {
    await tester.pumpWidget(_wrap(OrderActions(status: SubOrderStatus.preparing, onAction: (_) async {})));
    expect(_action(SubOrderStatus.ready), findsOneWidget);
    expect(_action(SubOrderStatus.cancelled), findsOneWidget);
    expect(_action(SubOrderStatus.accepted), findsNothing);
  });

  testWidgets('ready, out for delivery and terminal states offer no vendor action', (tester) async {
    for (final s in [SubOrderStatus.ready, SubOrderStatus.outForDelivery, SubOrderStatus.delivered, SubOrderStatus.cancelled]) {
      await tester.pumpWidget(_wrap(OrderActions(status: s, onAction: (_) async {})));
      expect(find.byType(AppButton), findsNothing, reason: 'no vendor transitions from ${s.json}');
    }
  });

  testWidgets('buttons only ever show allowed transitions and report the tapped status', (tester) async {
    for (final from in SubOrderStatus.values) {
      SubOrderStatus? tapped;
      await tester.pumpWidget(_wrap(OrderActions(status: from, onAction: (n) async => tapped = n)));
      final allowed = vendorNextSubOrderStatuses(from);
      for (final to in SubOrderStatus.values) {
        expect(_action(to), allowed.contains(to) ? findsOneWidget : findsNothing, reason: '$from → $to');
      }
      if (allowed.isNotEmpty) {
        final first = allowed.first;
        await tester.tap(_action(first));
        await tester.pump();
        expect(tapped, first);
      }
    }
  });

  testWidgets('disabled while offline with a tooltip', (tester) async {
    await tester.pumpWidget(_wrap(OrderActions(
      status: SubOrderStatus.placed,
      enabled: false,
      disabledReason: 'You are offline',
      onAction: (_) async {},
    )));
    final button = tester.widget<FilledButton>(find.descendant(of: _action(SubOrderStatus.accepted), matching: find.byType(FilledButton)));
    expect(button.onPressed, isNull);
    expect(find.byTooltip('You are offline'), findsNWidgets(2));
  });
}
