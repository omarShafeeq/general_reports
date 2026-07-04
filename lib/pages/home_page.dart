import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class _FeatureCategory {
  final String sectionKey;
  final IconData icon;
  final Color color;
  final List<String> routes;
  const _FeatureCategory(this.sectionKey, this.icon, this.color, this.routes);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _categories = [
    _FeatureCategory('cartesianCharts', Icons.show_chart, Color(0xFF1565C0), [
      RouteNames.lineChart,
      RouteNames.fastLineChart,
      RouteNames.splineChart,
      RouteNames.splineAreaChart,
      RouteNames.areaChart,
      RouteNames.stepLineChart,
      RouteNames.stepAreaChart,
      RouteNames.stackedAreaChart,
      RouteNames.rangeAreaChart,
    ]),
    _FeatureCategory('columnCharts', Icons.bar_chart, Color(0xFF00897B), [
      RouteNames.columnChart,
      RouteNames.barChart,
      RouteNames.stackedColumnChart,
      RouteNames.stackedBarChart,
      RouteNames.stackedColumn100Chart,
      RouteNames.stackedBar100Chart,
      RouteNames.rangeColumnChart,
    ]),
    _FeatureCategory('circularCharts', Icons.pie_chart_outline, Color(0xFFF57C00), [
      RouteNames.pieChart,
      RouteNames.doughnutChart,
      RouteNames.radialBarChart,
    ]),
    _FeatureCategory('pyramidFunnelCharts', Icons.filter_list, Color(0xFF8E24AA), [
      RouteNames.pyramidChart,
      RouteNames.funnelChart,
    ]),
    _FeatureCategory('financialCharts', Icons.candlestick_chart, Color(0xFFD81B60), [
      RouteNames.candleChart,
      RouteNames.hiloChart,
      RouteNames.hiloOpenCloseChart,
    ]),
    _FeatureCategory('scatterCharts', Icons.scatter_plot, Color(0xFF43A047), [
      RouteNames.scatterChart,
      RouteNames.bubbleChart,
    ]),
    _FeatureCategory('specialCharts', Icons.auto_graph, Color(0xFFE53935), [
      RouteNames.waterfallChart,
      RouteNames.boxWhiskerChart,
      RouteNames.histogramChart,
      RouteNames.errorBarChart,
      RouteNames.trendlineChart,
      RouteNames.paretoChart,
      RouteNames.combinationChart,
    ]),
    _FeatureCategory('chartCustomization', Icons.tune, Color(0xFF5C6BC0), [
      RouteNames.chartLegend,
      RouteNames.chartTooltip,
      RouteNames.chartTrackball,
      RouteNames.chartCrosshair,
      RouteNames.chartZoomPan,
      RouteNames.chartAxis,
      RouteNames.chartAnnotations,
      RouteNames.chartMarkersLabels,
      RouteNames.chartAnimation,
      RouteNames.chartStyling,
      RouteNames.chartSelection,
      RouteNames.chartLiveData,
      RouteNames.chartExport,
    ]),
    _FeatureCategory('navGrids', Icons.grid_on, Color(0xFF00ACC1), [
      RouteNames.basicGrid,
      RouteNames.columnTypes,
      RouteNames.frozenGrid,
      RouteNames.stackedHeaders,
      RouteNames.summaryGrid,
      RouteNames.sortingGrid,
      RouteNames.groupByGrid,
      RouteNames.orderByGrid,
      RouteNames.gridOptionsGrid,
      RouteNames.filteringGrid,
      RouteNames.pagingGrid,
      RouteNames.editingGrid,
      RouteNames.selectionGrid,
      RouteNames.stylingGrid,
      RouteNames.columnOpsGrid,
      RouteNames.exportGrid,
      RouteNames.performanceGrid,
    ]),
    _FeatureCategory('navDashboards', Icons.dashboard, Color(0xFFFFB300), [
      RouteNames.salesDashboard,
      RouteNames.revenueDashboard,
      RouteNames.inventoryDashboard,
      RouteNames.financeDashboard,
      RouteNames.hrDashboard,
      RouteNames.manufacturingDashboard,
      RouteNames.projectDashboard,
      RouteNames.healthcareDashboard,
      RouteNames.educationDashboard,
      RouteNames.executiveDashboard,
    ]),
    _FeatureCategory('navReports', Icons.assessment, Color(0xFF6D4C41), [
      RouteNames.salesReport,
      RouteNames.financeReport,
      RouteNames.inventoryReport,
    ]),
    _FeatureCategory('navReportEngine', Icons.dynamic_form, Color(0xFF0277BD), [
      RouteNames.reportCatalog,
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Enterprise Reports',
      currentRoute: RouteNames.home,
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _CategoryCard(category: category);
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _FeatureCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: category.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(category.icon, color: category.color, size: 24),
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  l10n.sectionTitle(category.sectionKey),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.featuresCount(category.routes.length),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.xs,
              children: category.routes.map((route) {
                return ActionChip(
                  label: Text(l10n.pageTitle(route)),
                  onPressed: () => context.goNamed(route),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
