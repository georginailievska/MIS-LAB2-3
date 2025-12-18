import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/meal_category.dart';
import '../models/meal.dart';

class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<MealCategory>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoriesJson = data['categories'] ?? [];
        return categoriesJson
            .map((json) => MealCategory.fromJson(json))
            .toList();
      } else {
        debugPrint('Failed to fetch categories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> mealsJson = data['meals'] ?? [];
        return mealsJson.map((json) => Meal.fromJson(json)).toList();
      } else {
        debugPrint(
            'Failed to fetch meals by category: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching meals by category: $e');
      return [];
    }
  }

  Future<List<Meal>> searchMealsByName(String query) async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic>? mealsJson = data['meals'];
        if (mealsJson == null) return [];
        return mealsJson.map((json) => Meal.fromJson(json)).toList();
      } else {
        debugPrint('Failed to search meals: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error searching meals: $e');
      return [];
    }
  }

  Future<Meal?> fetchMealDetails(String id) async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic>? mealsJson = data['meals'];
        if (mealsJson == null || mealsJson.isEmpty) return null;
        return Meal.fromJson(mealsJson[0]);
      } else {
        debugPrint('Failed to fetch meal details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching meal details: $e');
      return null;
    }
  }

  Future<Meal?> fetchRandomMeal() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/random.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic>? mealsJson = data['meals'];
        if (mealsJson == null || mealsJson.isEmpty) return null;
        return Meal.fromJson(mealsJson[0]);
      } else {
        debugPrint('Failed to fetch random meal: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching random meal: $e');
      return null;
    }
  }
}