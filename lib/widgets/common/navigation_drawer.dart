import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:general_reports/blocs/theme/theme_cubit.dart';
import 'package:general_reports/blocs/theme/theme_state.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
import 'package:general_reports/routing/route_names.dart';

class _NavSection {
  final String sectionKey;
  final IconData icon;
  final List<_NavItem> items;
  const _NavSection(this.sectionKey, this.icon, this.items);
}

class _NavItem {
  final String route;
  final IconData icon;
  const _NavItem(this.route, this.icon);
}

class AppNavigationDrawer extends StatelessWidget {
  final String currentRoute;
  final VoidCallback? onClose;

  const AppNavigationDrawer({
    super.key,
    required this.currentRoute,
    this.onClose,
  });

  static const _sections = [
    _NavSection('navHome', Icons.home_outlined, [
      _NavItem(RouteNames.home, Icons.dashboard_outlined),
    ]),
    _NavSection('cartesianCharts', Icons.show_chart, [
      _NavItem(RouteNames.lineChart, Icons.timeline),
      _NavItem(RouteNames.fastLineChart, Icons.speed),
      _NavItem(RouteNames.splineChart, Icons.gesture),
      _NavItem(RouteNames.splineAreaChart, Icons.area_chart),
      _NavItem(RouteNames.areaChart, Icons.area_chart),
      _NavItem(RouteNames.stepLineChart, Icons.stacked_line_chart),
      _NavItem(RouteNames.stepAreaChart, Icons.stacked_line_chart),
      _NavItem(RouteNames.stackedAreaChart, Icons.layers),
      _NavItem(RouteNames.rangeAreaChart, Icons.unfold_more),
    ]),
    _NavSection('columnCharts', Icons.bar_chart, [
      _NavItem(RouteNames.columnChart, Icons.bar_chart),
      _NavItem(RouteNames.barChart, Icons.align_horizontal_left),
      _NavItem(RouteNames.stackedColumnChart, Icons.stacked_bar_chart),
      _NavItem(RouteNames.stackedBarChart, Icons.stacked_bar_chart),
      _NavItem(RouteNames.stackedColumn100Chart, Icons.stacked_bar_chart),
      _NavItem(RouteNames.stackedBar100Chart, Icons.stacked_bar_chart),
      _NavItem(RouteNames.rangeColumnChart, Icons.view_column),
    ]),
    _NavSection('circularCharts', Icons.pie_chart_outline, [
      _NavItem(RouteNames.pieChart, Icons.pie_chart),
      _NavItem(RouteNames.doughnutChart, Icons.donut_large),
      _NavItem(RouteNames.radialBarChart, Icons.track_changes),
    ]),
    _NavSection('pyramidFunnelCharts', Icons.filter_list, [
      _NavItem(RouteNames.pyramidChart, Icons.change_history),
      _NavItem(RouteNames.funnelChart, Icons.filter_alt),
    ]),
    _NavSection('financialCharts', Icons.candlestick_chart, [
      _NavItem(RouteNames.candleChart, Icons.candlestick_chart),
      _NavItem(RouteNames.hiloChart, Icons.trending_up),
      _NavItem(RouteNames.hiloOpenCloseChart, Icons.trending_up),
    ]),
    _NavSection('scatterCharts', Icons.scatter_plot, [
      _NavItem(RouteNames.scatterChart, Icons.scatter_plot),
      _NavItem(RouteNames.bubbleChart, Icons.bubble_chart),
    ]),
    _NavSection('specialCharts', Icons.auto_graph, [
      _NavItem(RouteNames.waterfallChart, Icons.waterfall_chart),
      _NavItem(RouteNames.boxWhiskerChart, Icons.candlestick_chart),
      _NavItem(RouteNames.histogramChart, Icons.equalizer),
      _NavItem(RouteNames.errorBarChart, Icons.error_outline),
      _NavItem(RouteNames.trendlineChart, Icons.trending_up),
      _NavItem(RouteNames.paretoChart, Icons.insert_chart),
      _NavItem(RouteNames.combinationChart, Icons.merge_type),
    ]),
    _NavSection('chartCustomization', Icons.tune, [
      _NavItem(RouteNames.chartLegend, Icons.list),
      _NavItem(RouteNames.chartTooltip, Icons.info_outline),
      _NavItem(RouteNames.chartTrackball, Icons.gps_fixed),
      _NavItem(RouteNames.chartCrosshair, Icons.control_camera),
      _NavItem(RouteNames.chartZoomPan, Icons.zoom_in),
      _NavItem(RouteNames.chartAxis, Icons.straighten),
      _NavItem(RouteNames.chartAnnotations, Icons.note_add),
      _NavItem(RouteNames.chartMarkersLabels, Icons.label),
      _NavItem(RouteNames.chartAnimation, Icons.animation),
      _NavItem(RouteNames.chartStyling, Icons.palette),
      _NavItem(RouteNames.chartSelection, Icons.touch_app),
      _NavItem(RouteNames.chartLiveData, Icons.stream),
      _NavItem(RouteNames.chartExport, Icons.file_download),
    ]),
    _NavSection('navGrids', Icons.grid_on, [
      _NavItem(RouteNames.basicGrid, Icons.table_chart),
      _NavItem(RouteNames.columnTypes, Icons.view_column),
      _NavItem(RouteNames.frozenGrid, Icons.ac_unit),
      _NavItem(RouteNames.stackedHeaders, Icons.view_agenda),
      _NavItem(RouteNames.summaryGrid, Icons.summarize),
      _NavItem(RouteNames.sortingGrid, Icons.sort),
      _NavItem(RouteNames.groupByGrid, Icons.account_tree),
      _NavItem(RouteNames.orderByGrid, Icons.sort_by_alpha),
      _NavItem(RouteNames.gridOptionsGrid, Icons.tune),
      _NavItem(RouteNames.filteringGrid, Icons.filter_list),
      _NavItem(RouteNames.pagingGrid, Icons.last_page),
      _NavItem(RouteNames.editingGrid, Icons.edit),
      _NavItem(RouteNames.selectionGrid, Icons.check_box),
      _NavItem(RouteNames.stylingGrid, Icons.format_paint),
      _NavItem(RouteNames.columnOpsGrid, Icons.view_week),
      _NavItem(RouteNames.exportGrid, Icons.file_download),
      _NavItem(RouteNames.performanceGrid, Icons.speed),
    ]),
    _NavSection('navDashboards', Icons.dashboard, [
      _NavItem(RouteNames.salesDashboard, Icons.point_of_sale),
      _NavItem(RouteNames.revenueDashboard, Icons.monetization_on),
      _NavItem(RouteNames.inventoryDashboard, Icons.inventory),
      _NavItem(RouteNames.financeDashboard, Icons.account_balance),
      _NavItem(RouteNames.hrDashboard, Icons.people),
      _NavItem(RouteNames.manufacturingDashboard, Icons.precision_manufacturing),
      _NavItem(RouteNames.projectDashboard, Icons.assignment),
      _NavItem(RouteNames.healthcareDashboard, Icons.local_hospital),
      _NavItem(RouteNames.educationDashboard, Icons.school),
      _NavItem(RouteNames.executiveDashboard, Icons.business_center),
    ]),
    _NavSection('navReports', Icons.assessment, [
      _NavItem(RouteNames.salesReport, Icons.receipt_long),
      _NavItem(RouteNames.financeReport, Icons.account_balance_wallet),
      _NavItem(RouteNames.inventoryReport, Icons.inventory_2),
    ]),
    _NavSection('navReportEngine', Icons.dynamic_form, [
      _NavItem(RouteNames.reportCatalog, Icons.list_alt),
    ]),
    _NavSection('navPivotReports', Icons.pivot_table_chart, [
      _NavItem(RouteNames.pivotReports, Icons.pivot_table_chart),
    ]),
    _NavSection('navAiAssistant', Icons.auto_awesome, [
      _NavItem(RouteNames.aiAssistant, Icons.smart_toy),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context, theme),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSizes.lg),
              children: _sections.map((section) {
                return _buildSection(context, section, theme);
              }).toList(),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + AppSizes.md,
        left: AppSizes.md,
        right: AppSizes.md,
        bottom: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.analytics, size: 40, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(height: AppSizes.sm),
          Text(
            l10n.appTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            l10n.appSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, _NavSection section, ThemeData theme) {
    final l10n = context.l10n;
    return ExpansionTile(
      leading: Icon(section.icon, size: 20),
      title: Text(l10n.sectionTitle(section.sectionKey), style: theme.textTheme.labelLarge),
      dense: true,
      childrenPadding: const EdgeInsets.only(left: AppSizes.md),
      initiallyExpanded: section.items.any((item) => item.route == currentRoute),
      children: section.items.map((item) {
        final isSelected = item.route == currentRoute;
        return ListTile(
          leading: Icon(item.icon, size: 18),
          title: Text(l10n.pageTitle(item.route)),
          dense: true,
          selected: isSelected,
          selectedTileColor: theme.colorScheme.primaryContainer.withAlpha(80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          onTap: () {
            onClose?.call();
            context.goNamed(item.route);
          },
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final l10n = context.l10n;
        return Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(state.isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: state.isDark ? l10n.lightMode : l10n.darkMode,
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              ),
              IconButton(
                icon: Icon(
                  state.isRtl
                      ? Icons.format_textdirection_l_to_r
                      : Icons.format_textdirection_r_to_l,
                ),
                tooltip:
                    state.isRtl ? l10n.switchToEnglish : l10n.switchToArabic,
                onPressed: () => context.read<ThemeCubit>().toggleRtl(),
              ),
            ],
          ),
        );
      },
    );
  }
}
