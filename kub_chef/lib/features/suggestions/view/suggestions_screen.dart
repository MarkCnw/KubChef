import 'package:flutter/material.dart';
import 'package:kub_chef/data/models/scan_result.dart';
import 'package:kub_chef/features/recipe_detail/view/recipe_detail_screen.dart';
import 'package:kub_chef/features/suggestions/widgets/ingredient_chip.dart';
import 'package:kub_chef/features/suggestions/widgets/recipe_card.dart';

class SuggestionsScreen extends StatelessWidget {
  final ScanResult result;

  const SuggestionsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Results')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Debug information
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.yellow.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Debug Info:'),
                Text('Ingredients: ${result.ingredients.length}'),
                Text('Recipes: ${result.recipes.length}'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // แสดง ingredients ถ้ามี
          if (result.ingredients.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.ingredients
                  .map((i) => IngredientChip(text: i.name))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('No ingredients detected'),
            ),
            const SizedBox(height: 16),
          ],

          Text(
            'Recommended Dishes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          // แสดง recipes ถ้ามี
          if (result.recipes.isNotEmpty) ...[
            for (final r in result.recipes)
              RecipeCard(
                recipe: r,
                onView: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: r),
                  ),
                ),
              ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.restaurant, size: 48, color: Colors.orange),
                  SizedBox(height: 8),
                  Text('No recipes found'),
                  SizedBox(height: 8),
                  Text(
                    'Try uploading a clearer food image or check if the AI service is working properly.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
