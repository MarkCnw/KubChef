import 'package:flutter/material.dart';
import 'package:kub_chef/data/models/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isSaved = false;
  late TabController _tabController;
  final List<bool> _checkedIngredients = [];
  final List<bool> _completedSteps = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkedIngredients.addAll(
      List.generate(widget.recipe.ingredients.length, (_) => false),
    );
    _completedSteps.addAll(
      List.generate(widget.recipe.steps.length, (_) => false),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image AppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.recipe.imageUrl.isNotEmpty)
                    Image.network(
                      widget.recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.restaurant,
                            size: 80,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.restaurant,
                        size: 80,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
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
              IconButton(
                icon: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_border,
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

          // Title Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.title,
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Info cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          Icons.schedule,
                          '${widget.recipe.timeMinutes}',
                          'Minutes',
                          colorScheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          Icons.restaurant,
                          '${widget.recipe.servings}',
                          'Servings',
                          colorScheme.secondaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          Icons.inventory_2,
                          '${widget.recipe.ingredients.length}',
                          'Items',
                          colorScheme.tertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Ingredients'),
                  Tab(text: 'Instructions'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [_buildIngredientsTab(), _buildInstructionsTab()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () {
              _showCookingModeDialog(context);
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Cooking'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.recipe.ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CheckboxListTile(
            value: _checkedIngredients[index],
            onChanged: (val) {
              setState(() => _checkedIngredients[index] = val ?? false);
            },
            title: Text(
              widget.recipe.ingredients[index],
              style: TextStyle(
                decoration: _checkedIngredients[index]
                    ? TextDecoration.lineThrough
                    : null,
                color: _checkedIngredients[index] ? Colors.grey : null,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.3),
          ),
        );
      },
    );
  }

  Widget _buildInstructionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.recipe.steps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 0,
            color: _completedSteps[index]
                ? Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.5)
                : Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
            child: CheckboxListTile(
              value: _completedSteps[index],
              onChanged: (val) {
                setState(() => _completedSteps[index] = val ?? false);
              },
              secondary: CircleAvatar(
                backgroundColor: _completedSteps[index]
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                foregroundColor: _completedSteps[index]
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                widget.recipe.steps[index],
                style: TextStyle(
                  decoration: _completedSteps[index]
                      ? TextDecoration.lineThrough
                      : null,
                  color: _completedSteps[index] ? Colors.grey : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCookingModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Cooking Mode'),
        content: const Text(
          'This will guide you through the recipe step by step. Are you ready?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cooking mode coming soon!')),
              );
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
