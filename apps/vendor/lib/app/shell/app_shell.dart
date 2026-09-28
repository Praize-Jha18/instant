import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// One entry of the navigation shell. [branch] is the index handed back to
/// `onSelectBranch`. Entries with [compact] false are folded into the entry
/// flagged [isMore] on phones.
class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.branch,
    IconData? selectedIcon,
    this.compact = true,
    this.isMore = false,
  }) : selectedIcon = selectedIcon ?? icon;

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int branch;
  final bool compact;
  final bool isMore;
}

/// Responsive navigation chrome: bottom [NavigationBar] under 600 px, a
/// [NavigationRail] (extended from 1100 px) beside the content otherwise.
/// Pure widget (no router dependency) so it can be tested directly.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.destinations,
    required this.currentBranch,
    required this.onSelectBranch,
    required this.child,
    this.banner,
    this.badges = const {},
    this.railHeader,
    this.railTrailing,
  });

  static const double compactBreakpoint = 600;
  static const double extendedBreakpoint = 1100;

  final List<ShellDestination> destinations;
  final int currentBranch;
  final ValueChanged<int> onSelectBranch;
  final Widget child;

  /// Rendered above the content (connectivity banner).
  final Widget? banner;

  /// Branch → count, rendered as a badge on the icon.
  final Map<int, int> badges;
  final Widget? railHeader;
  final Widget? railTrailing;

  static bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < compactBreakpoint;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final content = Column(
      children: [
        ?banner,
        Expanded(child: child),
      ],
    );

    if (width < compactBreakpoint) {
      final compact = destinations.where((d) => d.compact || d.isMore).toList();
      var selected = compact.indexWhere((d) => d.branch == currentBranch);
      if (selected == -1) selected = compact.indexWhere((d) => d.isMore);
      if (selected == -1) selected = 0;
      return Scaffold(
        body: content,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (i) => onSelectBranch(compact[i].branch),
          destinations: [
            for (final d in compact)
              NavigationDestination(
                icon: _badged(d, Icon(d.icon)),
                selectedIcon: _badged(d, Icon(d.selectedIcon)),
                label: d.label,
                tooltip: d.label,
              ),
          ],
        ),
      );
    }

    final wide = destinations.where((d) => !d.isMore).toList();
    final selectedIndex = wide.indexWhere((d) => d.branch == currentBranch);
    final extended = width >= extendedBreakpoint;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            minExtendedWidth: 220,
            selectedIndex: selectedIndex == -1 ? null : selectedIndex,
            onDestinationSelected: (i) => onSelectBranch(wide[i].branch),
            labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
            leading: railHeader,
            trailing: railTrailing == null
                ? null
                : Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(padding: const EdgeInsets.only(bottom: AppSpacing.lg), child: railTrailing),
                    ),
                  ),
            destinations: [
              for (final d in wide)
                NavigationRailDestination(
                  icon: _badged(d, Icon(d.icon)),
                  selectedIcon: _badged(d, Icon(d.selectedIcon)),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _badged(ShellDestination d, Widget icon) {
    final count = badges[d.branch] ?? 0;
    if (count <= 0) return icon;
    return Badge.count(count: count, child: icon);
  }
}
