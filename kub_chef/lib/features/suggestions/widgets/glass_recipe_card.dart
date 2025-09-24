import 'package:flutter/material.dart';
import '../../../core/glass/glass_container.dart';
import '../../../data/models/recipe.dart';

class GlassRecipeCard extends StatelessWidget {
  final Recipe recipe;
  const GlassRecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recipe.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image, size: 40),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 4),
                    Text('${recipe.timeMinutes} min'),
                    const SizedBox(width: 16),
                    const Icon(Icons.group, size: 18),
                    const SizedBox(width: 4),
                    Text('${recipe.servings} servings'),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Ingredients (${recipe.ingredients.length}): '
                  '${recipe.ingredients.take(4).join(', ')}'
                  '${recipe.ingredients.length > 4 ? '...' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _showDetails(context),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('View Recipe'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GlassContainer(
            elevation: 6,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: ListView(
              controller: controller,
              children: [
                Text(
                  recipe.title,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 20),
                    const SizedBox(width: 4),
                    Text('${recipe.timeMinutes} min'),
                    const SizedBox(width: 16),
                    const Icon(Icons.group, size: 20),
                    const SizedBox(width: 4),
                    Text('${recipe.servings} servings'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...recipe.ingredients.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('•  '),
                        Expanded(child: Text(e)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Steps',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...recipe.steps.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${e.key + 1}. '),
                        Expanded(child: Text(e.value)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
