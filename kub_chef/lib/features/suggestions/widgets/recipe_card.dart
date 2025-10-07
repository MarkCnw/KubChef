import 'package:flutter/material.dart';
import '../../../data/models/recipe.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onView;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onView,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: widget.onView,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and save button
              Row(
                children: [
                  // Difficulty badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          _getDifficulty(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Save button
                  IconButton(
                    icon: Icon(
                      _isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: _isSaved
                          ? colorScheme.primary
                          : Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() => _isSaved = !_isSaved);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isSaved ? 'Recipe saved!' : 'Recipe removed',
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                widget.recipe.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Info chips in a row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    context,
                    Icons.schedule,
                    '${widget.recipe.timeMinutes} min',
                    colorScheme.primaryContainer,
                  ),
                  _buildInfoChip(
                    context,
                    Icons.restaurant,
                    '${widget.recipe.servings} servings',
                    colorScheme.secondaryContainer,
                  ),
                  _buildInfoChip(
                    context,
                    Icons.inventory_2_outlined,
                    '${widget.recipe.ingredients.length} items',
                    colorScheme.tertiaryContainer,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // View Recipe Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: widget.onView,
                  icon: const Icon(Icons.restaurant_menu, size: 18),
                  label: const Text('View Recipe'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficulty() {
    if (widget.recipe.timeMinutes < 20) return 'Easy';
    if (widget.recipe.timeMinutes < 40) return 'Medium';
    return 'Hard';
  }

  Color _getDifficultyColor(BuildContext context) {
    if (widget.recipe.timeMinutes < 20) {
      return Colors.green;
    } else if (widget.recipe.timeMinutes < 40) {
      return Colors.orange;
    }
    return Colors.red;
  }
}
