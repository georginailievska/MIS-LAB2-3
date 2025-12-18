import 'package:flutter/foundation.dart';
import 'meal.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<String, Meal> _favoritesById = {};

  List<Meal> get favorites => _favoritesById.values.toList(growable: false);

  bool isFavorite(String mealId) => _favoritesById.containsKey(mealId);

  void toggleFavorite(Meal meal) {
    if (meal.id.isEmpty) return;

    if (_favoritesById.containsKey(meal.id)) {
      _favoritesById.remove(meal.id);
    } else {
      _favoritesById[meal.id] = meal;
    }

    notifyListeners();
  }
}
