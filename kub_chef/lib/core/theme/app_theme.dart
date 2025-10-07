import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedLoadingIndicator extends StatefulWidget {
  final String message;
  const AnimatedLoadingIndicator({
    super.key,
    this.message = 'Analyzing ingredients...',
  });

  @override
  State<AnimatedLoadingIndicator> createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState
    extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotationTransition(
          turns: _controller,
          child: Icon(
            Icons.auto_awesome,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.message,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class AppTheme {
  static const _seed = Color(0xFF00C389); // เขียวมิ้นต์
  static const _secondary = Color(0xFFFF6B6B); // ส้มแดงสดใส
  static const _accent = Color(0xFFFFA94D); // ส้มทอง

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      secondary: _secondary,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Typography
    textTheme: GoogleFonts.promptTextTheme(ThemeData.light().textTheme),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: GoogleFonts.prompt(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // FilledButton Theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.prompt(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      secondary: _secondary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.promptTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: GoogleFonts.prompt(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}
