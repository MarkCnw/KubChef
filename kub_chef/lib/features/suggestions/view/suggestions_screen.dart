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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    GlassContainer(
                      elevation: 2,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: res.ingredients
                            .map(
                              (i) => GlassContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  i.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Recipes',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ...res.recipes.map((r) => GlassRecipeCard(recipe: r)),
                  ],
                ),
        ),
      ),
    );
  }
}
