import 'package:flutter/material.dart';
import 'package:kub_chef/core/glass/glass_app.dart';
import 'package:kub_chef/core/glass/glass_loading_overlay.dart';
import 'package:kub_chef/features/suggestions/widgets/glass_recipe_card.dart';
import 'package:provider/provider.dart';

import '../../../core/glass/glass_container.dart';
import '../../../data/models/scan_result.dart';
import '../../suggestions/provider/suggestions_provider.dart';

class SuggestionsScreen extends StatelessWidget {
  final ScanResult result;
  const SuggestionsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.read<SuggestionsProvider>()..setResult(result),
      child: const _SuggestionsBody(),
    );
  }
}

class _SuggestionsBody extends StatelessWidget {
  const _SuggestionsBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SuggestionsProvider>();
    final res = provider.current;

    return GlassLoadingOverlay(
      loading: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const GlassAppBar(title: 'Suggestions'),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: res == null
              ? const Center(child: Text('No data'))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  children: [
                    GlassContainer(
                      elevation: 3,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.eco,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Detected Ingredients',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: res.ingredients
                                .map(
                                  (i) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      i.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Recommended Recipes',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...res.recipes.map((r) => GlassRecipeCard(recipe: r)),
                  ],
                ),
        ),
      ),
    );
  }
}
