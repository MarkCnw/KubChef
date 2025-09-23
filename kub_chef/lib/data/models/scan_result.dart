import 'ingredient.dart';
import 'recipe.dart';

class ScanResult {
  final List<Ingredient> ingredients;
  final List<Recipe> recipes;

  ScanResult({required this.ingredients, required this.recipes});

  factory ScanResult.fromJson(Map<String, dynamic> j) => ScanResult(
    ingredients: (j['ingredients'] as List<dynamic>? ?? const [])
        .map((e) => Ingredient.fromJson(e))
        .toList(),
    recipes: (j['recipes'] as List<dynamic>? ?? const [])
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
