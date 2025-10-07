import 'package:flutter/material.dart';
import 'package:kub_chef/features/home/view/home_screen.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/scan/provider/scan_provider.dart';
import 'features/suggestions/provider/suggestions_provider.dart';


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
        title: 'Kub Chef',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
