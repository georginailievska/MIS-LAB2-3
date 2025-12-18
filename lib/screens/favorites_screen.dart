import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/favorites_provider.dart';
import '../widgets/meal_card.dart';
import '../theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Favorite Recipes',
          style: context.textStyles.headlineSmall?.bold,
        ),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favorites, _) {
          final items = favorites.favorites;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 72,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No favorites yet',
                      style: context.textStyles.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap the heart on any recipe card to save it here.',
                      style: context.textStyles.bodyMedium?.withColor(
                        colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: AppSpacing.paddingMd,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final meal = items[index];
              final isFavorite = favorites.isFavorite(meal.id);

              return MealCard(
                meal: meal,
                onTap: () => context.push(
                  '/detail',
                  extra: meal,
                ),
                isFavorite: isFavorite,
                onToggleFavorite: () => favorites.toggleFavorite(meal),
              );
            },
          );
        },
      ),
    );
  }
}
