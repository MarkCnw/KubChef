import 'package:flutter/material.dart';
import 'package:kub_chef/core/glass/glass_token.dart';


class GlassBackground extends StatelessWidget {
  final Widget child;
  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<GlassTokens>()!;
    return Container(
      decoration: BoxDecoration(
        gradient: tokens.backgroundGradient,
      ),
      child: child,
    );
  }
}