import 'package:flutter/material.dart';

import '../../models/models.dart';

final financeDashboardDefinition = ReportDefinition(
  id: 'finance-dashboard',
  title: 'Finance Dashboard',
  description: 'Financial performance and expense analysis',
  category: 'Dashboards',
  icon: Icons.account_balance,
  datasource: 'finance-summary',
  layout: const LayoutDefinition(
    desktopColumns: 2,
    tabletColumns: 2,
    mobileColumns: 1,
    spacing: 16,
    runSpacing: 16,
    widgets: [
      LayoutWidgetConfig(widgetId: 'filter-section', columnSpan: 2, order: 0),
      LayoutWidgetConfig(widgetId: 'cards', columnSpan: 2, order: 1, minHeight: 130),
      LayoutWidgetConfig(widgetId: 'pnl-chart', columnSpan: 1, order: 2, minHeight: 400),
      LayoutWidgetConfig(widgetId: 'expense-chart', columnSpan: 1, order: 3, minHeight: 400),
      LayoutWidgetConfig(widgetId: 'transactions', columnSpan: 2, order: 4, minHeight: 400),
    ],
  ),
  filters: const [
    FilterDefinition(id: 'period', label: 'Period', type: ReportFilterType.year),
    FilterDefinition(id: 'department', label: 'Department', type: ReportFilterType.singleSelect, apiEndpoint: '/api/departments'),
  ],
  cards: const [
    CardDefinition(id: 'totalProfit', title: 'Net Profit', dataKey: 'totalProfit', trendKey: 'totalProfitTrend', icon: Icons.trending_up, isCurrency: true, color: Colors.green),
    CardDefinition(id: 'totalExpenses', title: 'Total Expenses', dataKey: 'totalExpenses', trendKey: 'totalExpensesTrend', icon: Icons.money_off, isCurrency: true, color: Colors.red),
    CardDefinition(id: 'profitMargin', title: 'Profit Margin', dataKey: 'profitMargin', trendKey: 'profitMarginTrend', icon: Icons.pie_chart, formatString: '#,##0.0', color: Colors.blue),
    CardDefinition(id: 'cashFlow', title: 'Operating Cash Flow', dataKey: 'operatingCashFlow', trendKey: 'operatingCashFlowTrend', icon: Icons.account_balance_wallet, isCurrency: true, color: Colors.teal),
  ],
  charts: const [
    ChartDefinition(
      id: 'pnlChart',
      title: 'Quarterly P&L',
      chartType: ReportChartType.column,
      dataKey: 'quarterlyPnL',
      xField: 'quarter',
      yFields: ['revenue', 'expenses', 'profit'],
      legend: ChartLegendConfig(visible: true, position: 'bottom'),
      tooltip: ChartTooltipConfig(enabled: true, shared: true),
    ),
    ChartDefinition(
      id: 'expenseChart',
      title: 'Expense Breakdown',
      chartType: ReportChartType.pie,
      dataKey: 'expenseBreakdown',
      xField: 'category',
      yFields: ['amount'],
      legend: ChartLegendConfig(visible: true, position: 'right'),
      tooltip: ChartTooltipConfig(enabled: true),
      dataLabels: ChartDataLabelConfig(visible: true),
    ),
  ],
  grids: const [
    GridDefinition(
      id: 'transactionGrid',
      title: 'Recent Transactions',
      dataKey: 'transactions',
      allowFiltering: true,
      paging: GridPagingConfig(pageSize: 10),
      columns: [
        GridColumnDefinition(field: 'transactionId', title: 'Transaction ID'),
        GridColumnDefinition(field: 'date', title: 'Date', columnType: ColumnType.date),
        GridColumnDefinition(field: 'description', title: 'Description'),
        GridColumnDefinition(field: 'category', title: 'Category'),
        GridColumnDefinition(field: 'amount', title: 'Amount', columnType: ColumnType.numeric, alignment: ColumnAlignment.right, formatString: '\$#,##0'),
        GridColumnDefinition(field: 'type', title: 'Type'),
      ],
      sorting: GridSortConfig(field: 'date', ascending: false),
      conditionalFormats: [
        GridConditionalFormat(
          field: 'amount',
          conditionType: GridConditionType.lessThan,
          value: 0,
          style: GridCellStyle(textColor: 0xFFF44336, bold: true),
        ),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(id: 'filter-section', type: SectionType.filters),
    SectionDefinition(id: 'cards', type: SectionType.cards, columns: 4, columnSpan: 2),
    SectionDefinition(id: 'pnl-chart', type: SectionType.charts, childIds: ['pnlChart']),
    SectionDefinition(id: 'expense-chart', type: SectionType.charts, childIds: ['expenseChart']),
    SectionDefinition(id: 'transactions', type: SectionType.grids, columnSpan: 2),
  ],
);
