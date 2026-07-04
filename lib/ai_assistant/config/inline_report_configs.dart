import 'package:flutter/material.dart';

import '../../report_engine/models/card_definition.dart';
import '../../report_engine/models/chart_definition.dart';
import '../../report_engine/models/enums.dart';
import '../../report_engine/models/grid_definition.dart';
import '../../report_engine/models/report_definition.dart';

/// Simplified report definitions for inline chat rendering.
///
/// These are lighter versions of the full dashboard reports — fewer charts,
/// no filters, no sections — designed to render compactly inside a chat
/// message bubble.
abstract final class InlineReportConfigs {
  static const salesOverview = ReportDefinition(
    id: 'sales-overview',
    title: 'Sales Overview',
    description: 'Key sales metrics and monthly trends',
    icon: Icons.point_of_sale,
    cards: [
      CardDefinition(
        id: 'inline-total-revenue',
        title: 'Total Revenue',
        dataKey: 'totalRevenue',
        trendKey: 'totalRevenueTrend',
        icon: Icons.attach_money,
        isCurrency: true,
      ),
      CardDefinition(
        id: 'inline-total-orders',
        title: 'Total Orders',
        dataKey: 'totalOrders',
        trendKey: 'totalOrdersTrend',
        icon: Icons.shopping_cart,
      ),
      CardDefinition(
        id: 'inline-avg-order',
        title: 'Avg Order Value',
        dataKey: 'avgOrderValue',
        trendKey: 'avgOrderValueTrend',
        icon: Icons.trending_up,
        isCurrency: true,
      ),
    ],
    charts: [
      ChartDefinition(
        id: 'inline-monthly-trend',
        title: 'Monthly Revenue Trend',
        chartType: ReportChartType.spline,
        dataKey: 'monthlyTrend',
        xField: 'month',
        yFields: ['revenue', 'profit'],
        legend: ChartLegendConfig(visible: true, position: 'bottom'),
        tooltip: ChartTooltipConfig(enabled: true),
      ),
    ],
  );

  static const financeSummary = ReportDefinition(
    id: 'finance-summary',
    title: 'Financial Summary',
    description: 'Profit, expenses, and quarterly performance',
    icon: Icons.account_balance,
    cards: [
      CardDefinition(
        id: 'inline-total-profit',
        title: 'Net Profit',
        dataKey: 'totalProfit',
        trendKey: 'totalProfitTrend',
        icon: Icons.trending_up,
        isCurrency: true,
      ),
      CardDefinition(
        id: 'inline-total-expenses',
        title: 'Total Expenses',
        dataKey: 'totalExpenses',
        trendKey: 'totalExpensesTrend',
        icon: Icons.money_off,
        isCurrency: true,
      ),
      CardDefinition(
        id: 'inline-profit-margin',
        title: 'Profit Margin',
        dataKey: 'profitMargin',
        trendKey: 'profitMarginTrend',
        icon: Icons.percent,
        formatString: '#,##0.0',
      ),
    ],
    charts: [
      ChartDefinition(
        id: 'inline-quarterly-pnl',
        title: 'Quarterly P&L',
        chartType: ReportChartType.stackedColumn,
        dataKey: 'quarterlyPnL',
        xField: 'quarter',
        yFields: ['revenue', 'expenses', 'profit'],
        legend: ChartLegendConfig(visible: true, position: 'bottom'),
        tooltip: ChartTooltipConfig(enabled: true, shared: true),
      ),
    ],
  );

  static const inventoryStatus = ReportDefinition(
    id: 'inventory-status',
    title: 'Inventory Status',
    description: 'Stock levels and category breakdown',
    icon: Icons.inventory_2,
    cards: [
      CardDefinition(
        id: 'inline-total-items',
        title: 'Total Items',
        dataKey: 'totalItems',
        trendKey: 'totalItemsTrend',
        icon: Icons.inventory,
      ),
      CardDefinition(
        id: 'inline-low-stock',
        title: 'Low Stock Alerts',
        dataKey: 'lowStockCount',
        trendKey: 'lowStockCountTrend',
        icon: Icons.warning_amber,
        color: Colors.orange,
      ),
      CardDefinition(
        id: 'inline-total-value',
        title: 'Inventory Value',
        dataKey: 'totalValue',
        trendKey: 'totalValueTrend',
        icon: Icons.account_balance_wallet,
        isCurrency: true,
      ),
    ],
    charts: [
      ChartDefinition(
        id: 'inline-by-category',
        title: 'Stock by Category',
        chartType: ReportChartType.doughnut,
        dataKey: 'byCategory',
        xField: 'category',
        yFields: ['value'],
        legend: ChartLegendConfig(visible: true, position: 'bottom'),
        tooltip: ChartTooltipConfig(enabled: true),
      ),
    ],
  );

  static const salesByCustomer = ReportDefinition(
    id: 'sales-by-customer',
    title: 'Customer Sales',
    description: 'Revenue breakdown by customer',
    icon: Icons.people,
    cards: [
      CardDefinition(
        id: 'inline-customer-revenue',
        title: 'Total Revenue',
        dataKey: 'totalRevenue',
        trendKey: 'totalRevenueTrend',
        icon: Icons.attach_money,
        isCurrency: true,
      ),
    ],
    charts: [
      ChartDefinition(
        id: 'inline-customer-bar',
        title: 'Top Customers by Revenue',
        chartType: ReportChartType.bar,
        dataKey: 'customerSales',
        xField: 'customer',
        yFields: ['revenue'],
        tooltip: ChartTooltipConfig(enabled: true),
      ),
    ],
    grids: [
      GridDefinition(
        id: 'inline-customer-grid',
        title: 'Customer Details',
        dataKey: 'customerDetails',
        columns: [
          GridColumnDefinition(field: 'customer', title: 'Customer', sortable: true),
          GridColumnDefinition(
            field: 'revenue',
            title: 'Revenue',
            columnType: ColumnType.numeric,
            alignment: ColumnAlignment.right,
            formatString: '#,##0',
            sortable: true,
          ),
          GridColumnDefinition(
            field: 'orders',
            title: 'Orders',
            columnType: ColumnType.numeric,
            alignment: ColumnAlignment.right,
            sortable: true,
          ),
        ],
        sorting: GridSortConfig(field: 'revenue', ascending: false),
      ),
    ],
  );

  static const Map<String, ReportDefinition> all = {
    'sales-overview': salesOverview,
    'finance-summary': financeSummary,
    'inventory-status': inventoryStatus,
    'sales-by-customer': salesByCustomer,
  };
}
