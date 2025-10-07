import 'package:flutter/material.dart';
import 'package:kub_chef/data/models/scan_result.dart';
import 'package:kub_chef/features/recipe_detail/view/recipe_detail_screen.dart';
import 'package:kub_chef/features/suggestions/widgets/ingredient_chip.dart';
import 'package:kub_chef/features/suggestions/widgets/recipe_card.dart';

class SuggestionsScreen extends StatefulWidget {
  final ScanResult result;

  const SuggestionsScreen({super.key, required this.result});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showIngredients = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasIngredients = widget.result.ingredients.isNotEmpty;
    final hasRecipes = widget.result.recipes.isNotEmpty;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Scan Results',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),

          // Statistics Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 0,
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        Icons.restaurant,
                        '${widget.result.ingredients.length}',
                        'Ingredients',
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: colorScheme.outline.withOpacity(0.3),
                      ),
                      _buildStatItem(
                        context,
                        Icons.menu_book,
                        '${widget.result.recipes.length}',
                        'Recipes',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Ingredients Section
          if (hasIngredients)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detected Ingredients',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            _showIngredients
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                          onPressed: () {
                            setState(
                              () => _showIngredients = !_showIngredients,
                            );
                          },
                        ),
                      ],
                    ),
                    if (_showIngredients) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.result.ingredients
                            .map((i) => IngredientChip(text: i.name))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _buildEmptyState(
                  context,
                  Icons.no_food,
                  'No Ingredients Detected',
                  'Try taking a clearer photo with better lighting',
                ),
              ),
            ),

          // Recipes Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended Recipes',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (hasRecipes)
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Filter recipes
                      },
                      icon: const Icon(Icons.filter_list, size: 18),
                      label: const Text('Filter'),
                    ),
                ],
              ),
            ),
          ),

          // Recipes List
          if (hasRecipes)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recipe = widget.result.recipes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: RecipeCard(
                      recipe: recipe,
                      onView: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      ),
                    ),
                  );
                }, childCount: widget.result.recipes.length),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildEmptyState(
                  context,
                  Icons.restaurant_menu,
                  'No Recipes Found',
                  'We couldn\'t find matching recipes. Try scanning different ingredients.',
                ),
              ),
            ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.camera_alt),
        label: const Text('Scan Again'),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
