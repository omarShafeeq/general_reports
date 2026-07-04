import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:general_reports/routing/route_names.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String _pick(String en, String ar) => isArabic ? ar : en;

  // ── App shell ──────────────────────────────────────────────────────────────
  String get appTitle => _pick('Enterprise Reports', 'التقارير المؤسسية');
  String get appSubtitle =>
      _pick('Syncfusion Dashboard Showcase', 'عرض لوحات Syncfusion');
  String get navHome => _pick('Home', 'الرئيسية');
  String get navGrids => _pick('Data Grids', 'جداول البيانات');
  String get navDashboards => _pick('Dashboards', 'لوحات المعلومات');
  String get navReports => _pick('Reports', 'التقارير');
  String get navReportEngine => _pick('Report Engine', 'محرك التقارير');
  String get cartesianCharts =>
      _pick('Cartesian Charts', 'مخططات ديكارتية');
  String get columnCharts =>
      _pick('Column & Bar Charts', 'مخططات أعمدة وأشرطة');
  String get circularCharts => _pick('Circular Charts', 'مخططات دائرية');
  String get pyramidFunnelCharts =>
      _pick('Pyramid & Funnel', 'هرم وقمع');
  String get financialCharts => _pick('Financial Charts', 'مخططات مالية');
  String get scatterCharts =>
      _pick('Scatter & Bubble', 'مبعثر وفقاعات');
  String get specialCharts => _pick('Special Charts', 'مخططات خاصة');
  String get chartCustomization =>
      _pick('Chart Customization', 'تخصيص المخططات');
  String get loading => _pick('Loading...', 'جاري التحميل...');
  String get noData => _pick('No data available', 'لا توجد بيانات');
  String get error => _pick('Something went wrong', 'حدث خطأ ما');
  String get retry => _pick('Retry', 'إعادة المحاولة');
  String get comingSoon => _pick('Coming soon...', 'قريباً...');
  String get navPivotReports => _pick('Pivot Reports', 'التقارير المحورية');
  String get navAiAssistant => _pick('AI Assistant', 'المساعد الذكي');
  String get aiAssistant => _pick('AI Assistant', 'المساعد الذكي');
  String get aiAskPlaceholder =>
      _pick('Ask about your data...', 'اسأل عن بياناتك...');
  String get aiNewConversation =>
      _pick('New Conversation', 'محادثة جديدة');
  String get aiClearChat => _pick('Clear Chat', 'مسح المحادثة');
  String get aiCopied =>
      _pick('Copied to clipboard', 'تم النسخ إلى الحافظة');
  String get aiRetry => _pick('Retry', 'إعادة المحاولة');
  String get aiSearchConversations =>
      _pick('Search conversations...', 'بحث في المحادثات...');
  String get aiNoConversations =>
      _pick('No conversations yet', 'لا توجد محادثات بعد');
  String get aiRenameConversation =>
      _pick('Rename Conversation', 'إعادة تسمية المحادثة');
  String get aiDeleteConversation =>
      _pick('Delete Conversation', 'حذف المحادثة');
  String get aiPin => _pick('Pin', 'تثبيت');
  String get aiUnpin => _pick('Unpin', 'إلغاء التثبيت');
  String get aiFavorite => _pick('Favorite', 'مفضلة');
  String get aiExportChat =>
      _pick('Export Conversation', 'تصدير المحادثة');
  String get lightMode => _pick('Light Mode', 'الوضع الفاتح');
  String get darkMode => _pick('Dark Mode', 'الوضع الداكن');
  String get switchToArabic => _pick('Arabic (RTL)', 'العربية (من اليمين)');
  String get switchToEnglish => _pick('English (LTR)', 'الإنجليزية (من اليسار)');
  String get export => _pick('Export', 'تصدير');
  String get exportPdf => _pick('Export PDF', 'تصدير PDF');
  String get exportExcel => _pick('Export Excel', 'تصدير Excel');
  String get saveAsImage => _pick('Save as Image', 'حفظ كصورة');
  String get printLabel => _pick('Print', 'طباعة');
  String get reset => _pick('Reset', 'إعادة تعيين');
  String featuresCount(int count) =>
      _pick('$count features', '$count ميزة');

  String sectionTitle(String key) {
    return switch (key) {
      'navHome' => navHome,
      'cartesianCharts' => cartesianCharts,
      'columnCharts' => columnCharts,
      'circularCharts' => circularCharts,
      'pyramidFunnelCharts' => pyramidFunnelCharts,
      'financialCharts' => financialCharts,
      'scatterCharts' => scatterCharts,
      'specialCharts' => specialCharts,
      'chartCustomization' => chartCustomization,
      'navGrids' => navGrids,
      'navDashboards' => navDashboards,
      'navReports' => navReports,
      'navReportEngine' => navReportEngine,
      'navPivotReports' => navPivotReports,
      'navAiAssistant' => navAiAssistant,
      _ => key,
    };
  }

  String pageTitle(String route) {
    final titles = isArabic ? _pageTitlesAr : _pageTitlesEn;
    return titles[route] ?? route;
  }

  static const _pageTitlesEn = {
    RouteNames.home: 'Overview',
    RouteNames.lineChart: 'Line',
    RouteNames.fastLineChart: 'Fast Line',
    RouteNames.splineChart: 'Spline',
    RouteNames.splineAreaChart: 'Spline Area',
    RouteNames.areaChart: 'Area',
    RouteNames.stepLineChart: 'Step Line',
    RouteNames.stepAreaChart: 'Step Area',
    RouteNames.stackedAreaChart: 'Stacked Area',
    RouteNames.rangeAreaChart: 'Range Area',
    RouteNames.columnChart: 'Column',
    RouteNames.barChart: 'Bar',
    RouteNames.stackedColumnChart: 'Stacked Column',
    RouteNames.stackedBarChart: 'Stacked Bar',
    RouteNames.stackedColumn100Chart: '100% Stacked Col',
    RouteNames.stackedBar100Chart: '100% Stacked Bar',
    RouteNames.rangeColumnChart: 'Range Column',
    RouteNames.pieChart: 'Pie',
    RouteNames.doughnutChart: 'Doughnut',
    RouteNames.radialBarChart: 'Radial Bar',
    RouteNames.pyramidChart: 'Pyramid',
    RouteNames.funnelChart: 'Funnel',
    RouteNames.candleChart: 'Candle',
    RouteNames.hiloChart: 'Hilo',
    RouteNames.hiloOpenCloseChart: 'Hilo Open Close',
    RouteNames.scatterChart: 'Scatter',
    RouteNames.bubbleChart: 'Bubble',
    RouteNames.waterfallChart: 'Waterfall',
    RouteNames.boxWhiskerChart: 'Box & Whisker',
    RouteNames.histogramChart: 'Histogram',
    RouteNames.errorBarChart: 'Error Bar',
    RouteNames.trendlineChart: 'Trendline',
    RouteNames.paretoChart: 'Pareto',
    RouteNames.combinationChart: 'Combination',
    RouteNames.chartLegend: 'Legend',
    RouteNames.chartTooltip: 'Tooltip',
    RouteNames.chartTrackball: 'Trackball',
    RouteNames.chartCrosshair: 'Crosshair',
    RouteNames.chartZoomPan: 'Zoom & Pan',
    RouteNames.chartAxis: 'Axes',
    RouteNames.chartAnnotations: 'Annotations',
    RouteNames.chartMarkersLabels: 'Markers & Labels',
    RouteNames.chartAnimation: 'Animation',
    RouteNames.chartStyling: 'Styling',
    RouteNames.chartSelection: 'Selection',
    RouteNames.chartLiveData: 'Live Data',
    RouteNames.chartExport: 'Export',
    RouteNames.basicGrid: 'Basic Grid',
    RouteNames.columnTypes: 'Column Types',
    RouteNames.frozenGrid: 'Frozen',
    RouteNames.stackedHeaders: 'Stacked Headers',
    RouteNames.summaryGrid: 'Summary',
    RouteNames.sortingGrid: 'Sorting',
    RouteNames.groupByGrid: 'Group By',
    RouteNames.orderByGrid: 'Order By',
    RouteNames.gridOptionsGrid: 'Columns & Sum',
    RouteNames.filteringGrid: 'Filtering',
    RouteNames.pagingGrid: 'Paging',
    RouteNames.editingGrid: 'Editing',
    RouteNames.selectionGrid: 'Selection',
    RouteNames.stylingGrid: 'Styling',
    RouteNames.columnOpsGrid: 'Column Ops',
    RouteNames.exportGrid: 'Export',
    RouteNames.performanceGrid: 'Performance',
    RouteNames.salesDashboard: 'Sales',
    RouteNames.revenueDashboard: 'Revenue',
    RouteNames.inventoryDashboard: 'Inventory',
    RouteNames.financeDashboard: 'Finance',
    RouteNames.hrDashboard: 'HR',
    RouteNames.manufacturingDashboard: 'Manufacturing',
    RouteNames.projectDashboard: 'Project',
    RouteNames.healthcareDashboard: 'Healthcare',
    RouteNames.educationDashboard: 'Education',
    RouteNames.executiveDashboard: 'Executive',
    RouteNames.salesReport: 'Sales Report',
    RouteNames.financeReport: 'Finance Report',
    RouteNames.inventoryReport: 'Inventory Report',
    RouteNames.reportCatalog: 'Report Catalog',
    RouteNames.reportViewer: 'Report Viewer',
    RouteNames.pivotReports: 'Pivot Reports',
    RouteNames.aiAssistant: 'AI Assistant',
  };

  static const _pageTitlesAr = {
    RouteNames.home: 'نظرة عامة',
    RouteNames.lineChart: 'خط',
    RouteNames.fastLineChart: 'خط سريع',
    RouteNames.splineChart: 'منحنى سلس',
    RouteNames.splineAreaChart: 'منطقة منحنية',
    RouteNames.areaChart: 'منطقة',
    RouteNames.stepLineChart: 'خط متدرج',
    RouteNames.stepAreaChart: 'منطقة متدرجة',
    RouteNames.stackedAreaChart: 'منطقة متراكمة',
    RouteNames.rangeAreaChart: 'منطقة نطاق',
    RouteNames.columnChart: 'عمود',
    RouteNames.barChart: 'شريط',
    RouteNames.stackedColumnChart: 'عمود متراكم',
    RouteNames.stackedBarChart: 'شريط متراكم',
    RouteNames.stackedColumn100Chart: 'عمود 100% متراكم',
    RouteNames.stackedBar100Chart: 'شريط 100% متراكم',
    RouteNames.rangeColumnChart: 'عمود نطاق',
    RouteNames.pieChart: 'دائري',
    RouteNames.doughnutChart: 'حلقي',
    RouteNames.radialBarChart: 'شريط شعاعي',
    RouteNames.pyramidChart: 'هرم',
    RouteNames.funnelChart: 'قمع',
    RouteNames.candleChart: 'شموع',
    RouteNames.hiloChart: 'أعلى-أدنى',
    RouteNames.hiloOpenCloseChart: 'فتح-إغلاق',
    RouteNames.scatterChart: 'مبعثر',
    RouteNames.bubbleChart: 'فقاعات',
    RouteNames.waterfallChart: 'شلال',
    RouteNames.boxWhiskerChart: 'صندوق وشارب',
    RouteNames.histogramChart: 'مدرج تكراري',
    RouteNames.errorBarChart: 'شريط خطأ',
    RouteNames.trendlineChart: 'خط اتجاه',
    RouteNames.paretoChart: 'باريتو',
    RouteNames.combinationChart: 'مركب',
    RouteNames.chartLegend: 'وسيلة الإيضاح',
    RouteNames.chartTooltip: 'تلميح',
    RouteNames.chartTrackball: 'كرة التتبع',
    RouteNames.chartCrosshair: 'خط متقاطع',
    RouteNames.chartZoomPan: 'تكبير وتحريك',
    RouteNames.chartAxis: 'محاور',
    RouteNames.chartAnnotations: 'تعليقات',
    RouteNames.chartMarkersLabels: 'علامات وتسميات',
    RouteNames.chartAnimation: 'حركة',
    RouteNames.chartStyling: 'تنسيق',
    RouteNames.chartSelection: 'تحديد',
    RouteNames.chartLiveData: 'بيانات حية',
    RouteNames.chartExport: 'تصدير',
    RouteNames.basicGrid: 'جدول أساسي',
    RouteNames.columnTypes: 'أنواع الأعمدة',
    RouteNames.frozenGrid: 'تجميد',
    RouteNames.stackedHeaders: 'رؤوس متراكبة',
    RouteNames.summaryGrid: 'ملخص',
    RouteNames.sortingGrid: 'فرز',
    RouteNames.groupByGrid: 'تجميع',
    RouteNames.orderByGrid: 'ترتيب',
    RouteNames.gridOptionsGrid: 'الأعمدة والمجموع',
    RouteNames.filteringGrid: 'تصفية',
    RouteNames.pagingGrid: 'ترقيم الصفحات',
    RouteNames.editingGrid: 'تحرير',
    RouteNames.selectionGrid: 'تحديد',
    RouteNames.stylingGrid: 'تنسيق',
    RouteNames.columnOpsGrid: 'عمليات الأعمدة',
    RouteNames.exportGrid: 'تصدير',
    RouteNames.performanceGrid: 'أداء',
    RouteNames.salesDashboard: 'المبيعات',
    RouteNames.revenueDashboard: 'الإيرادات',
    RouteNames.inventoryDashboard: 'المخزون',
    RouteNames.financeDashboard: 'المالية',
    RouteNames.hrDashboard: 'الموارد البشرية',
    RouteNames.manufacturingDashboard: 'التصنيع',
    RouteNames.projectDashboard: 'المشاريع',
    RouteNames.healthcareDashboard: 'الرعاية الصحية',
    RouteNames.educationDashboard: 'التعليم',
    RouteNames.executiveDashboard: 'تنفيذي',
    RouteNames.salesReport: 'تقرير المبيعات',
    RouteNames.financeReport: 'تقرير مالي',
    RouteNames.inventoryReport: 'تقرير المخزون',
    RouteNames.reportCatalog: 'فهرس التقارير',
    RouteNames.reportViewer: 'عارض التقارير',
    RouteNames.pivotReports: 'التقارير المحورية',
    RouteNames.aiAssistant: 'المساعد الذكي',
  };
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) => false;
}
