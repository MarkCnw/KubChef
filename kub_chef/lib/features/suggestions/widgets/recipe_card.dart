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

// Enhanced Ingredient Chip (ใช้แทน ingredient_chip.dart เดิม)
class EnhancedIngredientChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool selected;

  const EnhancedIngredientChip({
    super.key,
    required this.text,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceVariant.withOpacity(0.5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: selected ? colorScheme.primary : Colors.grey[400],
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: selected ? colorScheme.primary : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: widget.recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: colorScheme.surfaceVariant,
                              child: Center(
                                child: Icon(
                                  Icons.restaurant,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                          loadingBuilder:
                              (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: colorScheme.surfaceVariant,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                        )
                      : Container(
                          color: colorScheme.surfaceVariant,
                          child: Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 48,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),

                // Difficulty badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getDifficulty(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Save button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() => _isSaved = !_isSaved);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isSaved
                                  ? 'Recipe saved!'
                                  : 'Recipe removed',
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 20,
                          color: _isSaved
                              ? colorScheme.primary
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.recipe.title,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Info chips
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.schedule,
                        '${widget.recipe.timeMinutes} min',
                        colorScheme.primaryContainer,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        context,
                        Icons.restaurant,
                        '${widget.recipe.servings} servings',
                        colorScheme.secondaryContainer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Ingredients preview
                  if (widget.recipe.ingredients.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${widget.recipe.ingredients.length} ingredients',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // View button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: widget.onView,
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text('View Recipe'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
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
}
