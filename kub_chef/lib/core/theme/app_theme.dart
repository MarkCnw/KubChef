import 'package:flutter/material.dart';
import 'package:kub_chef/core/glass/glass_token.dart';



class AppTheme {
  static const _seed = Color(0xFF00C389);

  static ThemeData light = _base(brightness: Brightness.light);
  static ThemeData dark = _base(brightness: Brightness.dark);

  static ThemeData _base({required Brightness brightness}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.white.withOpacity(0.16),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
      extensions: [
        GlassTokens(
          backgroundGradient: const LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          sheetGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          baseGlassColor: Colors.white,
          blurSigma: 26,
          borderOpacity: 0.30,
          tintOpacity: 0.22,
          defaultRadius: BorderRadius.circular(26),
          elevatedRadius: BorderRadius.circular(34),
        ),
      ],
    );
  }
}