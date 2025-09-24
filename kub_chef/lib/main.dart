import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/glass/glass_background.dart';
import 'core/glass/glass_navigation_shell.dart';
import 'features/scan/provider/scan_provider.dart';
import 'features/suggestions/provider/suggestions_provider.dart';
import 'features/scan/view/scan_screen.dart';

// (คุณสามารถแทนที่ SuggestionsScreen ใน nav ด้วยหน้าอื่นภายหลัง)

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => SuggestionsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KubChef',
        theme: AppTheme.dark, // เลือก dark เพื่อโชว์เอฟเฟ็กต์ glass เด่น
        home: const _Root(),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: GlassNavigationShell(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Scan',
          ),
            NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            label: 'Saved',
          ),
        ],
        pages: const [
          ScanScreen(),
          _RecipesPlaceholder(),
          _SavedPlaceholder(),
        ],
      ),
    );
  }
}

class _RecipesPlaceholder extends StatelessWidget {
  const _RecipesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Recipes Placeholder',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
    );
  }
}

class _SavedPlaceholder extends StatelessWidget {
  const _SavedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Saved Placeholder',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
    );
  }
}