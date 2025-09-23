import 'package:flutter/material.dart';

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final int timeMinutes;
  final int servings;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.timeMinutes,
    required this.servings,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    id: j['id']?.toString() ?? UniqueKey().toString(),
    title: j['title'] ?? 'Recipe',
    imageUrl: j['imageUrl'] ?? '',
    timeMinutes: (j['timeMinutes'] ?? 20) as int,
    servings: (j['servings'] ?? 2) as int,
    ingredients: (j['ingredients'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    steps: (j['steps'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'timeMinutes': timeMinutes,
    'servings': servings,
    'ingredients': ingredients,
    'steps': steps,
  };
}
