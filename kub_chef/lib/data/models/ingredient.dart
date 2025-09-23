class Ingredient {
  final String name;
  Ingredient({required this.name});

  factory Ingredient.fromJson(dynamic j) => Ingredient(
    name: j is Map ? (j['name'] ?? '') : (j?.toString() ?? ''),
  );
  dynamic toJson() => {'name': name};
}
