import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_card.dart';
import '../widgets/search_bar_widget.dart';
import '../theme.dart';
import '../models/favorites_provider.dart';

class MealsScreen extends StatefulWidget {
  final String categoryName;

  const MealsScreen({super.key, required this.categoryName});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealApiService _apiService = MealApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  bool _isLoading = true;
  bool _isSearchMode = false;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMeals() async {
    setState(() => _isLoading = true);
    final meals = await _apiService.fetchMealsByCategory(widget.categoryName);
    setState(() {
      _meals = meals;
      _filteredMeals = meals;
      _isLoading = false;
    });
  }

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearchMode = false;
        _filteredMeals = _meals;
      });
      return;
    }

    setState(() {
      _isSearchMode = true;
      _isLoading = true;
    });

    final searchResults = await _apiService.searchMealsByName(query);
    setState(() {
      _filteredMeals = searchResults;
      _isLoading = false;
    });

  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchMode = false;
      _filteredMeals = _meals;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: context.textStyles.headlineSmall?.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.paddingMd,
            child: SearchBarWidget(
              controller: _searchController,
              hintText:
              'Search ${widget.categoryName.toLowerCase()} recipes...',
              onChanged: _searchMeals,
              onClear: _clearSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMeals.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No meals found',
                    style: context.textStyles.titleLarge?.withColor(
                      colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadMeals,
              child: Consumer<FavoritesProvider>(
                builder: (context, favorites, _) {
                  return GridView.builder(
                    padding: AppSpacing.paddingMd,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _filteredMeals[index];
                      final isFavorite =
                      favorites.isFavorite(meal.id);

                      return MealCard(
                        meal: meal,
                        onTap: () => context.push(
                          '/detail',
                          extra: meal,
                        ),
                        isFavorite: isFavorite,
                        onToggleFavorite: () =>
                            favorites.toggleFavorite(meal),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
