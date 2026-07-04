import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:general_reports/pages/home_page.dart';
import 'package:general_reports/pages/placeholder_page.dart';
import 'package:general_reports/ai_assistant/pages/ai_chat_page.dart';
import 'package:general_reports/pivot_reports/pages/pivot_report_page.dart';
import 'package:general_reports/report_engine/pages/report_catalog_page.dart';
import 'package:general_reports/report_engine/pages/report_viewer_page.dart';
import 'package:general_reports/report_engine/pdf_viewer/pdf_viewer_page.dart';
import 'package:general_reports/routing/route_names.dart';

// Cartesian charts
import 'package:general_reports/pages/charts/cartesian/line_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/fast_line_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/spline_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/spline_area_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/area_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/step_line_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/step_area_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/stacked_area_chart_page.dart';
import 'package:general_reports/pages/charts/cartesian/range_area_chart_page.dart';

// Column/Bar charts
import 'package:general_reports/pages/charts/column/column_chart_page.dart';
import 'package:general_reports/pages/charts/column/bar_chart_page.dart';
import 'package:general_reports/pages/charts/column/stacked_column_chart_page.dart';
import 'package:general_reports/pages/charts/column/stacked_bar_chart_page.dart';
import 'package:general_reports/pages/charts/column/stacked_column_100_chart_page.dart';
import 'package:general_reports/pages/charts/column/stacked_bar_100_chart_page.dart';
import 'package:general_reports/pages/charts/column/range_column_chart_page.dart';

// Circular charts
import 'package:general_reports/pages/charts/circular/pie_chart_page.dart';
import 'package:general_reports/pages/charts/circular/doughnut_chart_page.dart';
import 'package:general_reports/pages/charts/circular/radial_bar_chart_page.dart';

// Pyramid & Funnel
import 'package:general_reports/pages/charts/pyramid_funnel/pyramid_chart_page.dart';
import 'package:general_reports/pages/charts/pyramid_funnel/funnel_chart_page.dart';

// Financial charts
import 'package:general_reports/pages/charts/financial/candle_chart_page.dart';
import 'package:general_reports/pages/charts/financial/hilo_chart_page.dart';
import 'package:general_reports/pages/charts/financial/hilo_open_close_chart_page.dart';

// Scatter charts
import 'package:general_reports/pages/charts/scatter/scatter_chart_page.dart';
import 'package:general_reports/pages/charts/scatter/bubble_chart_page.dart';

// Special charts
import 'package:general_reports/pages/charts/special/waterfall_chart_page.dart';
import 'package:general_reports/pages/charts/special/box_whisker_chart_page.dart';
import 'package:general_reports/pages/charts/special/histogram_chart_page.dart';
import 'package:general_reports/pages/charts/special/error_bar_chart_page.dart';
import 'package:general_reports/pages/charts/special/trendline_chart_page.dart';
import 'package:general_reports/pages/charts/special/pareto_chart_page.dart';

// Combination charts
import 'package:general_reports/pages/charts/combination/combination_chart_page.dart';

// Chart customization
import 'package:general_reports/pages/charts/customization/chart_legend_page.dart';
import 'package:general_reports/pages/charts/customization/chart_tooltip_page.dart';
import 'package:general_reports/pages/charts/customization/chart_trackball_page.dart';
import 'package:general_reports/pages/charts/customization/chart_crosshair_page.dart';
import 'package:general_reports/pages/charts/customization/chart_zoom_pan_page.dart';
import 'package:general_reports/pages/charts/customization/chart_axis_page.dart';
import 'package:general_reports/pages/charts/customization/chart_annotations_page.dart';
import 'package:general_reports/pages/charts/customization/chart_markers_labels_page.dart';
import 'package:general_reports/pages/charts/customization/chart_animation_page.dart';
import 'package:general_reports/pages/charts/customization/chart_styling_page.dart';
import 'package:general_reports/pages/charts/customization/chart_selection_page.dart';
import 'package:general_reports/pages/charts/customization/chart_live_data_page.dart';
import 'package:general_reports/pages/charts/customization/chart_export_page.dart';

// Data grids
import 'package:general_reports/pages/grids/basic_grid_page.dart';
import 'package:general_reports/pages/grids/column_types_page.dart';
import 'package:general_reports/pages/grids/frozen_page.dart';
import 'package:general_reports/pages/grids/stacked_headers_page.dart';
import 'package:general_reports/pages/grids/summary_page.dart';
import 'package:general_reports/pages/grids/group_by_page.dart';
import 'package:general_reports/pages/grids/order_by_page.dart';
import 'package:general_reports/pages/grids/grid_options_page.dart';
import 'package:general_reports/pages/grids/sorting_page.dart';
import 'package:general_reports/pages/grids/filtering_page.dart';
import 'package:general_reports/pages/grids/paging_page.dart';
import 'package:general_reports/pages/grids/editing_page.dart';
import 'package:general_reports/pages/grids/selection_page.dart';
import 'package:general_reports/pages/grids/styling_page.dart';
import 'package:general_reports/pages/grids/column_operations_page.dart';
import 'package:general_reports/pages/grids/export_page.dart';
import 'package:general_reports/pages/grids/performance_page.dart';

GoRouter createRouter() {
  final pages = <String, Widget Function()>{
    RouteNames.home: () => const HomePage(),

    // Cartesian
    RouteNames.lineChart: () => const LineChartPage(),
    RouteNames.fastLineChart: () => const FastLineChartPage(),
    RouteNames.splineChart: () => const SplineChartPage(),
    RouteNames.splineAreaChart: () => const SplineAreaChartPage(),
    RouteNames.areaChart: () => const AreaChartPage(),
    RouteNames.stepLineChart: () => const StepLineChartPage(),
    RouteNames.stepAreaChart: () => const StepAreaChartPage(),
    RouteNames.stackedAreaChart: () => const StackedAreaChartPage(),
    RouteNames.rangeAreaChart: () => const RangeAreaChartPage(),

    // Column/Bar
    RouteNames.columnChart: () => const ColumnChartPage(),
    RouteNames.barChart: () => const BarChartPage(),
    RouteNames.stackedColumnChart: () => const StackedColumnChartPage(),
    RouteNames.stackedBarChart: () => const StackedBarChartPage(),
    RouteNames.stackedColumn100Chart: () => const StackedColumn100ChartPage(),
    RouteNames.stackedBar100Chart: () => const StackedBar100ChartPage(),
    RouteNames.rangeColumnChart: () => const RangeColumnChartPage(),

    // Circular
    RouteNames.pieChart: () => const PieChartPage(),
    RouteNames.doughnutChart: () => const DoughnutChartPage(),
    RouteNames.radialBarChart: () => const RadialBarChartPage(),

    // Pyramid & Funnel
    RouteNames.pyramidChart: () => const PyramidChartPage(),
    RouteNames.funnelChart: () => const FunnelChartPage(),

    // Financial
    RouteNames.candleChart: () => const CandleChartPage(),
    RouteNames.hiloChart: () => const HiloChartPage(),
    RouteNames.hiloOpenCloseChart: () => const HiloOpenCloseChartPage(),

    // Scatter
    RouteNames.scatterChart: () => const ScatterChartPage(),
    RouteNames.bubbleChart: () => const BubbleChartPage(),

    // Special
    RouteNames.waterfallChart: () => const WaterfallChartPage(),
    RouteNames.boxWhiskerChart: () => const BoxWhiskerChartPage(),
    RouteNames.histogramChart: () => const HistogramChartPage(),
    RouteNames.errorBarChart: () => const ErrorBarChartPage(),
    RouteNames.trendlineChart: () => const TrendlineChartPage(),
    RouteNames.paretoChart: () => const ParetoChartPage(),
    RouteNames.combinationChart: () => const CombinationChartPage(),

    // Customization
    RouteNames.chartLegend: () => const ChartLegendPage(),
    RouteNames.chartTooltip: () => const ChartTooltipPage(),
    RouteNames.chartTrackball: () => const ChartTrackballPage(),
    RouteNames.chartCrosshair: () => const ChartCrosshairPage(),
    RouteNames.chartZoomPan: () => const ChartZoomPanPage(),
    RouteNames.chartAxis: () => const ChartAxisPage(),
    RouteNames.chartAnnotations: () => const ChartAnnotationsPage(),
    RouteNames.chartMarkersLabels: () => const ChartMarkersLabelsPage(),
    RouteNames.chartAnimation: () => const ChartAnimationPage(),
    RouteNames.chartStyling: () => const ChartStylingPage(),
    RouteNames.chartSelection: () => const ChartSelectionPage(),
    RouteNames.chartLiveData: () => const ChartLiveDataPage(),
    RouteNames.chartExport: () => const ChartExportPage(),

    // Grids
    RouteNames.basicGrid: () => const BasicGridPage(),
    RouteNames.columnTypes: () => const ColumnTypesPage(),
    RouteNames.frozenGrid: () => const FrozenPage(),
    RouteNames.stackedHeaders: () => const StackedHeadersPage(),
    RouteNames.summaryGrid: () => const SummaryPage(),
    RouteNames.sortingGrid: () => const SortingPage(),
    RouteNames.groupByGrid: () => const GroupByPage(),
    RouteNames.orderByGrid: () => const OrderByPage(),
    RouteNames.gridOptionsGrid: () => const GridOptionsPage(),
    RouteNames.filteringGrid: () => const FilteringPage(),
    RouteNames.pagingGrid: () => const PagingPage(),
    RouteNames.editingGrid: () => const EditingPage(),
    RouteNames.selectionGrid: () => const SelectionPage(),
    RouteNames.stylingGrid: () => const StylingPage(),
    RouteNames.columnOpsGrid: () => const ColumnOperationsPage(),
    RouteNames.exportGrid: () => const ExportPage(),
    RouteNames.performanceGrid: () => const PerformancePage(),

    // Dashboards
    RouteNames.salesDashboard: () => const ReportViewerPage(reportId: 'sales-dashboard'),
    RouteNames.revenueDashboard: () => const ReportViewerPage(reportId: 'sales-dashboard'),
    RouteNames.inventoryDashboard: () => const ReportViewerPage(reportId: 'inventory-status'),
    RouteNames.financeDashboard: () => const ReportViewerPage(reportId: 'finance-dashboard'),
    RouteNames.hrDashboard: () => const ReportViewerPage(reportId: 'hr-dashboard'),
    RouteNames.manufacturingDashboard: () => const PlaceholderPage(title: 'Manufacturing Dashboard', routeName: RouteNames.manufacturingDashboard),
    RouteNames.projectDashboard: () => const PlaceholderPage(title: 'Project Dashboard', routeName: RouteNames.projectDashboard),
    RouteNames.healthcareDashboard: () => const PlaceholderPage(title: 'Healthcare Dashboard', routeName: RouteNames.healthcareDashboard),
    RouteNames.educationDashboard: () => const PlaceholderPage(title: 'Education Dashboard', routeName: RouteNames.educationDashboard),
    RouteNames.executiveDashboard: () => const ReportViewerPage(reportId: 'sales-dashboard'),

    // Reports
    RouteNames.salesReport: () => const ReportViewerPage(reportId: 'sales-overview'),
    RouteNames.financeReport: () => const ReportViewerPage(reportId: 'finance-summary'),
    RouteNames.inventoryReport: () => const ReportViewerPage(reportId: 'inventory-status'),

    // Report Engine
    RouteNames.reportCatalog: () => const ReportCatalogPage(),

    // Pivot Reports
    RouteNames.pivotReports: () => const PivotReportPage(),

    // AI Assistant
    RouteNames.aiAssistant: () => const AIChatPage(),
  };

  return GoRouter(
    initialLocation: '/',
    routes: [
      ...pages.entries.map((entry) {
        final path = entry.key == RouteNames.home ? '/' : '/${entry.key}';
        return GoRoute(
          path: path,
          name: entry.key,
          builder: (context, state) => entry.value(),
        );
      }),
      GoRoute(
        path: '/${RouteNames.reportViewer}',
        name: RouteNames.reportViewer,
        builder: (context, state) {
          final reportId = state.uri.queryParameters['id'] ?? '';
          return ReportViewerPage(reportId: reportId);
        },
      ),
      GoRoute(
        path: '/${RouteNames.pdfViewer}',
        name: RouteNames.pdfViewer,
        builder: (context, state) {
          final url = state.uri.queryParameters['url'];
          final title = state.uri.queryParameters['title'] ?? 'PDF Viewer';
          return PdfViewerPage(url: url, title: title);
        },
      ),
    ],
  );
}
