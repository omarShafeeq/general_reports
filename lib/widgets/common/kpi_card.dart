import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/utils/formatters.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final double? change;
  final IconData icon;
  final Color? iconColor;
  final List<double>? sparklineData;
  final bool isCurrency;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.icon = Icons.trending_up,
    this.iconColor,
    this.sparklineData,
    this.isCurrency = false,
  });

  factory KpiCard.fromNumber({
    required String title,
    required num value,
    double? change,
    IconData icon = Icons.trending_up,
    Color? iconColor,
    List<double>? sparklineData,
    bool isCurrency = false,
    bool compact = true,
  }) {
    return KpiCard(
      title: title,
      value: Formatters.formatValue(value, compact: compact, isCurrency: isCurrency),
      change: change,
      icon: icon,
      iconColor: iconColor,
      sparklineData: sparklineData,
      isCurrency: isCurrency,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = (change ?? 0) >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor ?? theme.colorScheme.primary),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    title,
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
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Row(
              children: [
                if (change != null) ...[
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: changeColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    Formatters.formatChange(change!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: changeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (sparklineData != null && sparklineData!.length > 1) ...[
                  const Spacer(),
                  SizedBox(
                    width: 60,
                    height: 24,
                    child: SfSparkLineChart(
                      data: sparklineData!,
                      color: changeColor,
                      width: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
