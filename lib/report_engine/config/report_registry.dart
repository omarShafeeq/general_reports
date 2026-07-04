import '../models/report_definition.dart';
import 'dashboards/finance_dashboard_config.dart';
import 'dashboards/hr_dashboard_config.dart';
import 'dashboards/sales_dashboard_config.dart';
import 'reports/ix_sales_chart_report_config.dart';
import 'reports/customer_report_config.dart';
import 'reports/finance_summary_config.dart';
import 'reports/hr_report_config.dart';
import 'reports/inventory_status_config.dart';
import 'reports/order_report_config.dart';
import 'reports/sales_overview_config.dart';

List<ReportDefinition> get allReportDefinitions => [
      salesOverviewReport,
      salesByCountryReport,
      salesByCustomerReport,
      financeSummaryReport,
      inventoryStatusReport,
      orderReport,
      ixSalesChartReport,
      customerReport,
      hrReport,
      hrDeptDetailReport,
      salesDashboardDefinition,
      financeDashboardDefinition,
      hrDashboardDefinition,
    ];

List<ReportDefinition> get catalogReports => [
      salesOverviewReport,
      financeSummaryReport,
      inventoryStatusReport,
      orderReport,
      ixSalesChartReport,
      customerReport,
      hrReport,
    ];

List<ReportDefinition> get dashboardDefinitions => [
      salesDashboardDefinition,
      financeDashboardDefinition,
      hrDashboardDefinition,
    ];
