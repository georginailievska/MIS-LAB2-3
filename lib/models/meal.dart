import 'ingredient.dart';

class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? area;
  final String? instructions;
  final String? youtubeUrl;
  final List<Ingredient> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
    this.area,
    this.instructions,
    this.youtubeUrl,
    this.ingredients = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<Ingredient> parseIngredients() {
      final List<Ingredient> result = [];
      for (int i = 1; i <= 20; i++) {
        final ingredient = json['strIngredient$i'];
        final measure = json['strMeasure$i'];
        if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
          result.add(
            Ingredient(
              name: ingredient.toString().trim(),
              measure: measure?.toString().trim() ?? '',
            ),
          );
        }
      }
      return result;
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      youtubeUrl: json['strYoutube'],
      ingredients: parseIngredients(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbnail,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strYoutube': youtubeUrl,
    };

    for (int i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i].name;
      json['strMeasure${i + 1}'] = ingredients[i].measure;
    }

    return json;
  }
}
