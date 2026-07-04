import 'package:flutter/material.dart';

import '../../models/models.dart';

final financeSummaryReport = ReportDefinition(
  id: 'finance-summary',
  title: 'Finance Summary',
  description: 'Quarterly profit & loss, expense analysis, and transaction details',
  category: 'Finance',
  icon: Icons.account_balance,
  datasource: 'finance-summary',
  filters: const [
    FilterDefinition(
      id: 'year',
      label: 'Fiscal Year',
      type: ReportFilterType.year,
      defaultValue: 2025,
    ),
    FilterDefinition(
      id: 'quarter',
      label: 'Quarter',
      type: ReportFilterType.quarter,
    ),
    FilterDefinition(
      id: 'department',
      label: 'Department',
      type: ReportFilterType.singleSelect,
      apiEndpoint: '/api/departments',
    ),
  ],
  cards: [
    CardDefinition(
      id: 'profit-card',
      title: 'Net Profit',
      dataKey: 'totalProfit',
      trendKey: 'totalProfitTrend',
      icon: Icons.trending_up,
      color: const Color(0xFF2E7D32),
      isCurrency: true,
    ),
    CardDefinition(
      id: 'expenses-card',
      title: 'Total Expenses',
      dataKey: 'totalExpenses',
      trendKey: 'totalExpensesTrend',
      icon: Icons.money_off,
      color: const Color(0xFFC62828),
      isCurrency: true,
    ),
    CardDefinition(
      id: 'margin-card',
      title: 'Profit Margin',
      dataKey: 'profitMargin',
      trendKey: 'profitMarginTrend',
      icon: Icons.percent,
      color: const Color(0xFF1565C0),
      formatString: '#0.0',
    ),
    CardDefinition(
      id: 'cashflow-card',
      title: 'Operating Cash Flow',
      dataKey: 'operatingCashFlow',
      trendKey: 'operatingCashFlowTrend',
      icon: Icons.account_balance_wallet,
      color: const Color(0xFFF57C00),
      isCurrency: true,
    ),
  ],
  charts: [
    ChartDefinition(
      id: 'quarterly-pnl',
      title: 'Quarterly P&L',
      subtitle: 'Revenue, expenses, and profit by quarter',
      chartType: ReportChartType.stackedColumn,
      dataKey: 'quarterlyPnL',
      xField: 'quarter',
      yFields: ['revenue', 'expenses', 'profit'],
      legend: const ChartLegendConfig(visible: true, position: 'bottom'),
      tooltip: const ChartTooltipConfig(enabled: true, shared: true),
    ),
    ChartDefinition(
      id: 'expense-breakdown',
      title: 'Expense Breakdown',
      subtitle: 'Distribution of expenses by category',
      chartType: ReportChartType.doughnut,
      dataKey: 'expenseBreakdown',
      xField: 'category',
      yFields: ['amount'],
      legend: const ChartLegendConfig(visible: true, position: 'right'),
      tooltip: const ChartTooltipConfig(enabled: true),
    ),
  ],
  grids: [
    GridDefinition(
      id: 'transactions',
      title: 'Transaction Ledger',
      subtitle: 'Recent financial transactions',
      dataKey: 'transactions',
      columns: const [
        GridColumnDefinition(
          field: 'transactionId',
          title: 'Transaction ID',
          width: 130,
        ),
        GridColumnDefinition(
          field: 'date',
          title: 'Date',
          width: 120,
          columnType: ColumnType.date,
          sortable: true,
        ),
        GridColumnDefinition(
          field: 'description',
          title: 'Description',
          width: 200,
        ),
        GridColumnDefinition(
          field: 'category',
          title: 'Category',
          width: 140,
          filterable: true,
        ),
        GridColumnDefinition(
          field: 'amount',
          title: 'Amount',
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          formatString: '#,##0',
          aggregate: 'sum',
        ),
        GridColumnDefinition(
          field: 'type',
          title: 'Type',
          width: 100,
          filterable: true,
        ),
      ],
      sorting: const GridSortConfig(field: 'date', ascending: false),
      allowFiltering: true,
      paging: const GridPagingConfig(pageSize: 15),
      summaries: const [
        GridSummaryConfig(field: 'amount', type: 'sum', title: 'Net Total'),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(
      id: 'filters',
      type: SectionType.filters,
    ),
    SectionDefinition(
      id: 'kpis',
      type: SectionType.cards,
      columns: 4,
    ),
    SectionDefinition(
      id: 'charts',
      type: SectionType.charts,
      columns: 2,
    ),
    SectionDefinition(
      id: 'transactions-grid',
      type: SectionType.grids,
      title: 'Transactions',
      collapsible: true,
    ),
  ],
);
