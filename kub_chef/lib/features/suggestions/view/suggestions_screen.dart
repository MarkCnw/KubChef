import 'package:flutter/material.dart';
import 'package:kub_chef/data/models/scan_result.dart';
import 'package:kub_chef/features/recipe_detail/view/recipe_detail_screen.dart';
import 'package:kub_chef/features/suggestions/widgets/ingredient_chip.dart';
import 'package:kub_chef/features/suggestions/widgets/recipe_card.dart';

class SuggestionsScreen extends StatelessWidget {
  final ScanResult result;  const SuggestionsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Results')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.ingredients
                .map((i) => IngredientChip(text: i.name))
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Recommended Dishes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final r in result.recipes)
            RecipeCard(
              recipe: r,
              onView: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: r),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
