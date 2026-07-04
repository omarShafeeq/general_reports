import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../models/card_definition.dart';

class DynamicCardRenderer extends StatelessWidget {
  final CardDefinition definition;
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const DynamicCardRenderer({
    super.key,
    required this.definition,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rawValue = data[definition.dataKey];
    final trendValue = definition.trendKey != null
        ? data[definition.trendKey] as num?
        : null;
    final isPositive = (trendValue ?? 0) >= 0;
    final trendColor = isPositive ? AppColors.positive : AppColors.negative;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    definition.icon,
                    size: 20,
                    color: definition.color ?? theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      definition.title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                _formatValue(rawValue),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (trendValue != null) ...[
                const SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: trendColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${isPositive ? '+' : ''}${trendValue.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: trendColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '--';

    if (definition.formatString != null && value is num) {
      try {
        return NumberFormat(definition.formatString).format(value);
      } catch (_) {}
    }

    if (definition.isCurrency && value is num) {
      return NumberFormat.compactCurrency(symbol: '\$').format(value);
    }

    if (value is num) {
      return NumberFormat.compact().format(value);
    }

    return value.toString();
  }
}
