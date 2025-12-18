import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/meal_category.dart';
import '../services/meal_api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar_widget.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealApiService _apiService = MealApiService();
  final TextEditingController _searchController = TextEditingController();
  List<MealCategory> _categories = [];
  List<MealCategory> _filteredCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final categories = await _apiService.fetchCategories();
    setState(() {
      _categories = categories;
      _filteredCategories = categories;
      _isLoading = false;
    });
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where(
              (category) => category.name
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterCategories('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Food Lab',
          style: context.textStyles.headlineSmall?.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle, color: colorScheme.primary),
            tooltip: 'Random Recipe',
            onPressed: () => context.push('/random'),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: colorScheme.primary),
            tooltip: 'Favorites',
            onPressed: () => context.push('/favorites'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.paddingMd,
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Search categories...',
              onChanged: _filterCategories,
              onClear: _clearSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCategories.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No categories found',
                    style: context.textStyles.titleLarge?.withColor(
                      colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadCategories,
              child: ListView.builder(
                padding: AppSpacing.paddingMd,
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  return Padding(
                    padding:
                    const EdgeInsets.only(bottom: AppSpacing.md),
                    child: CategoryCard(
                      category: category,
                      onTap: () =>
                          context.push('/meals/${category.name}'),
                    ),
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