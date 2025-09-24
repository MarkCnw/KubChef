import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kub_chef/core/glass/glass_token.dart';



class AppTheme {
  static const _seed = Color(0xFF6B46C1); // Upgraded to premium purple

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
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: brightness == Brightness.dark ? Colors.white : Colors.black87,
        displayColor: brightness == Brightness.dark ? Colors.white : Colors.black87,
      ),
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
              Color(0xFF0F0C29), // Deep purple-blue
              Color(0xFF24243e), // Rich indigo
              Color(0xFF302B63), // Elegant purple
              Color(0xFF0F0C29), // Deep finish
            ],
            stops: [0.0, 0.33, 0.66, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          sheetGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
            stops: const [0.0, 0.7, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          baseGlassColor: Colors.white,
          blurSigma: 32,
          borderOpacity: 0.35,
          tintOpacity: 0.18,
          defaultRadius: BorderRadius.circular(28),
          elevatedRadius: BorderRadius.circular(36),
        ),
      ],
    );
  }
}