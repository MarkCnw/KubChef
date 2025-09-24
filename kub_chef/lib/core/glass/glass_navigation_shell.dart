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
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(index),
          child: widget.pages[index],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: GlassContainer(
          padding: EdgeInsets.zero,
          elevation: 8,
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: index,
            onTap: (i) => setState(() => index = i),
            items: widget.destinations
                .map(
                  (d) => BottomNavigationBarItem(
                    icon: d.icon,
                    label: d.label,
                  ),
                )
                .toList(),
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
