import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instant_vendor/app/shell/app_shell.dart';

import 'test_helpers.dart';

const _destinations = [
  ShellDestination(label: 'Home', icon: Icons.home_outlined, branch: 0),
  ShellDestination(label: 'Orders', icon: Icons.receipt_long_outlined, branch: 1),
  ShellDestination(label: 'Products', icon: Icons.inventory_2_outlined, branch: 2),
  ShellDestination(label: 'Finance', icon: Icons.account_balance_wallet_outlined, branch: 3, compact: false),
  ShellDestination(label: 'More', icon: Icons.more_horiz_rounded, branch: 4, isMore: true),
];

Widget _shell({required int branch, ValueChanged<int>? onSelect, Map<int, int> badges = const {}}) {
  AppTypography.configure(useGoogleFonts: false, allowRuntimeFetching: false);
  return MaterialApp(
    theme: AppTheme.light(),
    home: AppShell(
      destinations: _destinations,
      currentBranch: branch,
      onSelectBranch: onSelect ?? (_) {},
      badges: badges,
      banner: const SizedBox(height: 4, key: ValueKey('banner')),
      child: const Text('content'),
    ),
  );
}

void main() {
  testWidgets('phone width uses a bottom NavigationBar', (tester) async {
    setSurface(tester, const Size(400, 800));
    await tester.pumpWidget(_shell(branch: 1));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('content'), findsOneWidget);
    expect(find.byKey(const ValueKey('banner')), findsOneWidget);
    // Non-compact destinations are folded into "More".
    expect(find.text('Finance'), findsNothing);
    expect(find.text('More'), findsOneWidget);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);
  });

  testWidgets('a hidden branch selects the More entry on phones', (tester) async {
    setSurface(tester, const Size(400, 800));
    await tester.pumpWidget(_shell(branch: 3));
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 3);
  });

  testWidgets('tablet width uses a NavigationRail and shows every destination', (tester) async {
    setSurface(tester, const Size(900, 800));
    await tester.pumpWidget(_shell(branch: 3));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Finance'), findsOneWidget);
    expect(find.text('More'), findsNothing);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.selectedIndex, 3);
    expect(rail.extended, isFalse);
  });

  testWidgets('desktop width extends the rail', (tester) async {
    setSurface(tester, const Size(1300, 800));
    await tester.pumpWidget(_shell(branch: 0));
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended, isTrue);
  });

  testWidgets('switches layout when the window is resized', (tester) async {
    setSurface(tester, const Size(1300, 800));
    await tester.pumpWidget(_shell(branch: 0));
    expect(find.byType(NavigationRail), findsOneWidget);
    tester.view.physicalSize = const Size(390, 800);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('selecting a destination reports its branch and badges render', (tester) async {
    setSurface(tester, const Size(400, 800));
    int? selected;
    await tester.pumpWidget(_shell(branch: 0, onSelect: (b) => selected = b, badges: const {1: 3}));
    expect(find.text('3'), findsOneWidget);
    await tester.tap(find.text('Orders'));
    await tester.pump();
    expect(selected, 1);
  });
}
