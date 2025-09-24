import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/glass/glass_background.dart';
import 'core/glass/glass_navigation_shell.dart';
import 'core/glass/glass_container.dart';
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: GlassContainer(
          elevation: 4,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.menu_book,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Recipes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming Soon',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedPlaceholder extends StatelessWidget {
  const _SavedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: GlassContainer(
          elevation: 4,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.bookmark,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Saved Recipes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming Soon',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }