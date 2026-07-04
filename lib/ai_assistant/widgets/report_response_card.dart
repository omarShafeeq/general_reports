import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../report_engine/models/report_definition.dart';
import '../../report_engine/renderers/dynamic_card_renderer.dart';
import '../../report_engine/renderers/dynamic_chart_renderer.dart';
import '../../report_engine/renderers/dynamic_grid_renderer.dart';
import '../../routing/route_names.dart';

/// Renders an AI-generated [ReportDefinition] inline inside the chat.
///
/// Shows KPI cards, charts, and grids using the existing report engine
/// renderers, preserving visual consistency with the rest of the application.
class ReportResponseCard extends StatelessWidget {
  final ReportDefinition report;
  final Map<String, dynamic> data;

  const ReportResponseCard({
    super.key,
    required this.report,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(report.icon, color: AppColors.seedColor, size: 20),
                const SizedBox(width: AppSizes.xs),
                Expanded(
                  child: Text(
                    report.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openFullReport(context),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Open Full Report'),
                ),
              ],
            ),
            if (report.description.isNotEmpty) ...[
              const SizedBox(height: AppSizes.xs),
              Text(
                report.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (report.cards.isNotEmpty) ...[
              const SizedBox(height: AppSizes.md),
              _buildCards(context),
            ],
            if (report.charts.isNotEmpty) ...[
              const SizedBox(height: AppSizes.md),
              _buildCharts(),
            ],
            if (report.grids.isNotEmpty) ...[
              const SizedBox(height: AppSizes.md),
              _buildGrids(),
            ],
          ],
        ),
      ),
    );
  }

  void _openFullReport(BuildContext context) {
    context.goNamed(
      RouteNames.reportViewer,
      queryParameters: {'id': report.id},
    );
  }

  Widget _buildCards(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: report.cards.map((card) {
        return SizedBox(
          width: 180,
          child: DynamicCardRenderer(definition: card, data: data),
        );
      }).toList(),
    );
  }

  Widget _buildCharts() {
    return Column(
      children: report.charts.map((chart) {
        final chartData = data[chart.dataKey];
        final List<Map<String, dynamic>> typedData;
        if (chartData is List) {
          typedData = chartData.cast<Map<String, dynamic>>();
        } else {
          typedData = [];
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: SizedBox(
            height: 250,
            child: DynamicChartRenderer(definition: chart, data: typedData),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrids() {
    return Column(
      children: report.grids.map((grid) {
        final gridData = data[grid.dataKey];
        final List<Map<String, dynamic>> typedData;
        if (gridData is List) {
          typedData = gridData.cast<Map<String, dynamic>>();
        } else {
          typedData = [];
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: SizedBox(
            height: 300,
            child: DynamicGridRenderer(definition: grid, data: typedData),
          ),
        );
      }).toList(),
    );
  }
}
