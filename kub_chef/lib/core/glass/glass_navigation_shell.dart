import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassNavigationShell extends StatefulWidget {
  final List<Widget> pages;
  final List<NavigationDestination> destinations;
  final int initialIndex;

  const GlassNavigationShell({
    super.key,
    required this.pages,
    required this.destinations,
    this.initialIndex = 0,
  });

  @override
  State<GlassNavigationShell> createState() =>
      _GlassNavigationShellState();
}

class _GlassNavigationShellState extends State<GlassNavigationShell> {
  late int index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        switchInCurve: Curves.easeOutQuart,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey(index),
          child: widget.pages[index],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: GlassContainer(
          padding: EdgeInsets.zero,
          elevation: 4,
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            selectedIndex: index,
            onDestinationSelected: (i) => setState(() => index = i),
            destinations: widget.destinations,
            height: 70,
          ),
        ),
      ),
    );
  }
}
