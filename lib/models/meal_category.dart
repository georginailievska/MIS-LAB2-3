class MealCategory {
  final String id;
  final String name;
  final String thumbnail;
  final String description;

  MealCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) => MealCategory(
    id: json['idCategory'] ?? '',
    name: json['strCategory'] ?? '',
    thumbnail: json['strCategoryThumb'] ?? '',
    description: json['strCategoryDescription'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'idCategory': id,
    'strCategory': name,
    'strCategoryThumb': thumbnail,
    'strCategoryDescription': description,
  };
}
