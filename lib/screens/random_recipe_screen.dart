import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../widgets/ingredient_item.dart';
import '../theme.dart';

class RandomRecipeScreen extends StatefulWidget {
  const RandomRecipeScreen({super.key});

  @override
  State<RandomRecipeScreen> createState() => _RandomRecipeScreenState();
}

class _RandomRecipeScreenState extends State<RandomRecipeScreen> {
  final MealApiService _apiService = MealApiService();
  Meal? _meal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomMeal();
  }

  Future<void> _loadRandomMeal() async {
    setState(() => _isLoading = true);
    final meal = await _apiService.fetchRandomMeal();
    setState(() {
      _meal = meal;
      _isLoading = false;
    });
  }

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _meal == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load recipe',
              style: context.textStyles.titleLarge
                  ?.withColor(colorScheme.error),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _loadRandomMeal,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.shuffle,
                      color: colorScheme.primary),
                  tooltip: 'New Random Recipe',
                  onPressed: _loadRandomMeal,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _meal!.thumbnail,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Center(
                          child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.restaurant,
                          size: 64,
                          color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius:
                        BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome,
                              size: 18,
                              color: colorScheme.onPrimary),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Random Recipe',
                            style: context
                                .textStyles.labelLarge?.semiBold
                                .withColor(colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _meal!.name,
                    style:
                    context.textStyles.headlineMedium?.bold,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      if (_meal!.category != null)
                        Chip(
                          label: Text(_meal!.category!),
                          backgroundColor:
                          colorScheme.primaryContainer,
                          labelStyle: context
                              .textStyles.labelLarge
                              ?.withColor(colorScheme
                              .onPrimaryContainer),
                        ),
                      if (_meal!.area != null)
                        Chip(
                          label: Text(_meal!.area!),
                          backgroundColor: colorScheme
                              .surfaceContainerHighest,
                          labelStyle: context
                              .textStyles.labelLarge
                              ?.withColor(
                              colorScheme.onSurface),
                        ),
                    ],
                  ),
                  if (_meal!.youtubeUrl != null &&
                      _meal!.youtubeUrl!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _launchYouTube(_meal!.youtubeUrl!),
                        icon: const Icon(
                            Icons.play_circle_outline),
                        label: const Text('Watch on YouTube'),
                      ),
                    ),
                  ],
                  if (_meal!.ingredients.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      '🥘 Ingredients',
                      style: context
                          .textStyles.titleLarge?.bold,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ListView.separated(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: _meal!.ingredients.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) =>
                          IngredientItem(
                            ingredient: _meal!.ingredients[index],
                          ),
                    ),
                  ],
                  if (_meal!.instructions != null &&
                      _meal!.instructions!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      '📝 Instructions',
                      style: context
                          .textStyles.titleLarge?.bold,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: AppSpacing.paddingLg,
                      decoration: BoxDecoration(
                        color: colorScheme
                            .surfaceContainerHighest,
                        borderRadius:
                        BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _meal!.instructions!,
                        style: context.textStyles.bodyLarge
                            ?.copyWith(height: 1.6),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
