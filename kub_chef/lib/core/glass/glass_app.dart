import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              leading ??
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.maybeOf(context)?.openDrawer();
                    },
                  ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  textAlign: centerTitle
                      ? TextAlign.center
                      : TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (actions != null)
                ...actions!
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}
