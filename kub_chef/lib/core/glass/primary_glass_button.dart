import 'package:flutter/material.dart';
import 'package:kub_chef/core/glass/glass_container.dart';

class PrimaryGlassButton extends StatefulWidget {
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
  State<PrimaryGlassButton> createState() => _PrimaryGlassButtonState();
}

class _PrimaryGlassButtonState extends State<PrimaryGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: widget.onPressed == null ? 0.5 : 1,
            child: GestureDetector(
              onTapDown: widget.onPressed != null 
                  ? (_) => _controller.forward() 
                  : null,
              onTapUp: widget.onPressed != null 
                  ? (_) {
                      _controller.reverse();
                      widget.onPressed!();
                    }
                  : null,
              onTapCancel: () => _controller.reverse(),
              child: GlassContainer(
                interactive: false, // Handle interaction manually for better control
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                elevation: 4,
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }
}
