import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../theme.dart';

class IngredientItem extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientItem({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              ingredient.name,
              style: context.textStyles.bodyMedium?.semiBold,
            ),
          ),
          if (ingredient.measure.isNotEmpty)
            Text(
              ingredient.measure,
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}