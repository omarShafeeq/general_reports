import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Empty-state placeholder shown when a conversation has no messages.
///
/// Displays a branded header with suggested prompt chips.
class AIPlaceholder extends StatelessWidget {
  final void Function(String prompt) onSuggestionTap;

  const AIPlaceholder({super.key, required this.onSuggestionTap});

  static const _suggestions = [
    'Show monthly sales overview',
    'Top 10 customers by revenue',
    'Compare this year vs last year',
    'Inventory below minimum stock',
    'Financial summary and profit margins',
    'What can you help me with?',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColors.seedColor.withAlpha(80),
                          AppColors.secondarySeed.withAlpha(80),
                        ]
                      : AppColors.dashboardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 48,
                color: isDark
                    ? theme.colorScheme.onSurface
                    : Colors.white,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Enterprise AI Assistant',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Ask me about your business data, generate reports, or navigate the app.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              alignment: WrapAlignment.center,
              children: _suggestions.map((s) {
                return ActionChip(
                  avatar: const Icon(Icons.lightbulb_outline, size: 18),
                  label: Text(s),
                  onPressed: () => onSuggestionTap(s),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
