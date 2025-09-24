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
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: GlassContainer(
          elevation: 6,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Row(
            children: [
              leading ??
                  GestureDetector(
                    onTap: () {
                      Scaffold.maybeOf(context)?.openDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  textAlign: centerTitle
                      ? TextAlign.center
                      : TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (actions != null)
                ...actions!
              else
                const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }
}
