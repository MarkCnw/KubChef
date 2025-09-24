import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kub_chef/core/glass/glass_token.dart';


class GlassContainer extends StatelessWidget {
  static const _accentColor = Color(0xFF6B46C1); // Match theme seed
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final bool interactive;
  final GestureTapCallback? onTap;
  final Color? overlayColor;
  final double elevation;
  final Duration duration;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.radius,
    this.interactive = false,
    this.onTap,
    this.overlayColor,
    this.elevation = 0,
    this.duration = const Duration(milliseconds: 380),
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<GlassTokens>()!;
    final r = radius ??
        (elevation > 0 ? tokens.elevatedRadius : tokens.defaultRadius);

    Widget panel = AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: r,
        border: Border.all(
          width: 1.2,
            color: tokens.baseGlassColor.withOpacity(tokens.borderOpacity),
        ),
        gradient: LinearGradient(
          colors: [
            tokens.baseGlassColor.withOpacity(tokens.tintOpacity),
            tokens.baseGlassColor.withOpacity(tokens.tintOpacity * 0.4),
            tokens.baseGlassColor.withOpacity(tokens.tintOpacity * 0.15),
          ],
          stops: const [0.0, 0.6, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: elevation == 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20 * (elevation / 8 + 1),
                  offset: Offset(0, 4 + elevation * 1.5),
                ),
                BoxShadow(
                  color: _accentColor.withOpacity(0.08),
                  blurRadius: 30 * (elevation / 8 + 1),
                  offset: Offset(0, 8 + elevation * 2),
                ),
              ],
      ),
      padding: padding,
      child: child,
    );

    panel = ClipRRect(
      borderRadius: r,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: tokens.blurSigma,
              sigmaY: tokens.blurSigma,
            ),
            child: const SizedBox.expand(),
          ),
          panel,
          if (overlayColor != null)
            Container(
              decoration: BoxDecoration(
                color: overlayColor,
                borderRadius: r,
              ),
            ),
        ],
      ),
    );

    if (interactive) {
      panel = InkWell(
        borderRadius: r,
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.15),
        child: panel,
      );
    }

    return Container(
      margin: margin,
      child: panel,
    );
  }
}