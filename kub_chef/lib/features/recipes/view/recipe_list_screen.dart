import 'package:flutter/material.dart';
import 'package:kub_chef/data/models/recipe.dart';
import 'package:kub_chef/features/recipe_detail/view/recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snacks',
  ];

  // Mock data - ในอนาคตจะดึงจาก API
  final List<Recipe> _recipes = [
    Recipe(
      id: '1',
      title: 'Thai Green Curry',
      imageUrl:
          'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd',
      timeMinutes: 30,
      servings: 4,
      ingredients: ['Chicken', 'Green Curry Paste', 'Coconut Milk'],
      steps: ['Prepare ingredients', 'Cook curry'],
    ),
    Recipe(
      id: '2',
      title: 'Pad Thai',
      imageUrl:
          'https://images.unsplash.com/photo-1559314809-0d155014e29e',
      timeMinutes: 25,
      servings: 2,
      ingredients: ['Rice Noodles', 'Shrimp', 'Peanuts'],
      steps: ['Soak noodles', 'Stir fry'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                  ),
                );
              },
            ),
          ),

          // Recipe Grid
          Expanded(
            child: _recipes.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      return _buildRecipeGridItem(_recipes[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeGridItem(Recipe recipe) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceVariant,
                        child: const Icon(Icons.restaurant, size: 40),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.timeMinutes} min',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Recipes Found',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try scanning some ingredients first!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Recipes'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter recipe name...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            // TODO: Implement search
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
