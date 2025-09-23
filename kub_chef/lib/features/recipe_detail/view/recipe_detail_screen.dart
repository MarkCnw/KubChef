import 'package:flutter/material.dart';
import 'package:kub_chef/data/models/recipe.dart';


class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text('Save Recipe'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (recipe.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(recipe.imageUrl),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              _pill(context, Icons.schedule, '${recipe.timeMinutes} min'),
              const SizedBox(width: 12),
              _pill(context, Icons.group, '${recipe.servings}'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ingredients',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final it in recipe.ingredients)
            Row(
              children: [
                const Icon(Icons.radio_button_unchecked, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(it)),
              ],
            ),
          const SizedBox(height: 16),
          Text(
            'Instructions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < recipe.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 14, child: Text('${i + 1}')),
                  const SizedBox(width: 12),
                  Expanded(child: Text(recipe.steps[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
