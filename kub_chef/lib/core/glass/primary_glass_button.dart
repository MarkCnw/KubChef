import 'package:flutter/material.dart';
import 'package:kub_chef/core/glass/glass_container.dart';

class PrimaryGlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const PrimaryGlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: GlassContainer(
        interactive: onPressed != null,
        onTap: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        elevation: 2,
        child: content,
      ),
    );
  }
}
