import 'package:flutter/material.dart';

import '../../models/models.dart';

final salesOverviewReport = ReportDefinition(
  id: 'sales-overview',
  title: 'Sales Overview',
  description: 'Comprehensive view of sales performance across regions and time periods',
  category: 'Sales',
  icon: Icons.point_of_sale,
  datasource: 'sales-overview',
  filters: const [
    FilterDefinition(
      id: 'year',
      label: 'Year',
      type: ReportFilterType.year,
      defaultValue: 2025,
    ),
    FilterDefinition(
      id: 'quarter',
      label: 'Quarter',
      type: ReportFilterType.quarter,
    ),
    FilterDefinition(
      id: 'region',
      label: 'Region',
      type: ReportFilterType.singleSelect,
      apiEndpoint: '/api/regions',
    ),
    FilterDefinition(
      id: 'country',
      label: 'Country',
      type: ReportFilterType.singleSelect,
      apiEndpoint: '/api/countries',
      dependsOn: ['region'],
    ),
    FilterDefinition(
      id: 'status',
      label: 'Status',
      type: ReportFilterType.multiSelect,
      apiEndpoint: '/api/statuses',
    ),
  ],
  cards: [
    CardDefinition(
      id: 'revenue-card',
      title: 'Total Revenue',
      dataKey: 'totalRevenue',
      trendKey: 'totalRevenueTrend',
      icon: Icons.monetization_on,
      color: const Color(0xFF1565C0),
      isCurrency: true,
    ),
    CardDefinition(
      id: 'orders-card',
      title: 'Total Orders',
      dataKey: 'totalOrders',
      trendKey: 'totalOrdersTrend',
      icon: Icons.shopping_cart,
      color: const Color(0xFF00897B),
    ),
    CardDefinition(
      id: 'avg-order-card',
      title: 'Avg Order Value',
      dataKey: 'avgOrderValue',
      trendKey: 'avgOrderValueTrend',
      icon: Icons.assessment,
      color: const Color(0xFFF57C00),
      isCurrency: true,
    ),
    CardDefinition(
      id: 'conversion-card',
      title: 'Conversion Rate',
      dataKey: 'conversionRate',
      trendKey: 'conversionRateTrend',
      icon: Icons.trending_up,
      color: const Color(0xFF8E24AA),
      formatString: '#0.0%',
    ),
  ],
  charts: [
    ChartDefinition(
      id: 'monthly-trend',
      title: 'Monthly Revenue Trend',
      subtitle: 'Revenue and orders over the year',
      chartType: ReportChartType.line,
      dataKey: 'monthlyTrend',
      xField: 'month',
      yFields: ['revenue', 'profit'],
      legend: const ChartLegendConfig(visible: true, position: 'bottom'),
      tooltip: const ChartTooltipConfig(enabled: true, shared: true),
      xAxis: const ChartAxisConfig(title: 'Month'),
      yAxis: const ChartAxisConfig(title: 'Amount (\$)'),
    ),
    ChartDefinition(
      id: 'region-sales',
      title: 'Sales by Region',
      chartType: ReportChartType.column,
      dataKey: 'regionSales',
      xField: 'region',
      yFields: ['revenue'],
      legend: const ChartLegendConfig(visible: false),
      tooltip: const ChartTooltipConfig(enabled: true),
      drillDown: const DrillDownDefinition(
        targetReportId: 'sales-by-country',
        paramField: 'region',
        paramKey: 'region',
        label: 'Sales in {value}',
      ),
    ),
  ],
  grids: [
    GridDefinition(
      id: 'order-details',
      title: 'Order Details',
      subtitle: 'All orders with status and region breakdown',
      dataKey: 'orderDetails',
      columns: const [
        GridColumnDefinition(
          field: 'orderId',
          title: 'Order ID',
          width: 120,
        ),
        GridColumnDefinition(
          field: 'customer',
          title: 'Customer',
          width: 160,
        ),
        GridColumnDefinition(
          field: 'region',
          title: 'Region',
          width: 140,
          filterable: true,
        ),
        GridColumnDefinition(
          field: 'product',
          title: 'Product',
          width: 150,
        ),
        GridColumnDefinition(
          field: 'quantity',
          title: 'Qty',
          width: 80,
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
        ),
        GridColumnDefinition(
          field: 'total',
          title: 'Total',
          width: 120,
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          formatString: '#,##0',
          aggregate: 'sum',
        ),
        GridColumnDefinition(
          field: 'date',
          title: 'Date',
          width: 120,
          columnType: ColumnType.date,
        ),
        GridColumnDefinition(
          field: 'status',
          title: 'Status',
          width: 110,
          filterable: true,
        ),
      ],
      sorting: const GridSortConfig(field: 'date', ascending: false),
      allowFiltering: true,
      paging: const GridPagingConfig(pageSize: 20),
      summaries: const [
        GridSummaryConfig(field: 'total', type: 'sum', title: 'Total'),
        GridSummaryConfig(field: 'quantity', type: 'sum', title: 'Total Qty'),
      ],
      displayOptions: const GridDisplayOptions(
        showColumnPicker: true,
        showSummaryPicker: true,
      ),
    ),
  ],
  sections: const [
    SectionDefinition(
      id: 'filters-section',
      type: SectionType.filters,
    ),
    SectionDefinition(
      id: 'kpi-section',
      type: SectionType.cards,
      columns: 4,
      childIds: ['revenue-card', 'orders-card', 'avg-order-card', 'conversion-card'],
    ),
    SectionDefinition(
      id: 'charts-section',
      type: SectionType.charts,
      columns: 2,
      childIds: ['monthly-trend', 'region-sales'],
    ),
    SectionDefinition(
      id: 'grid-section',
      type: SectionType.grids,
      title: 'Order Details',
      collapsible: true,
      childIds: ['order-details'],
    ),
  ],
);

final salesByCountryReport = ReportDefinition(
  id: 'sales-by-country',
  title: 'Sales by Country',
  description: 'Drill-down: sales breakdown by country within a region',
  category: 'Sales',
  icon: Icons.public,
  datasource: 'sales-by-country',
  cards: [
    CardDefinition(
      id: 'country-revenue',
      title: 'Region Revenue',
      dataKey: 'totalRevenue',
      trendKey: 'totalRevenueTrend',
      icon: Icons.monetization_on,
      isCurrency: true,
    ),
    CardDefinition(
      id: 'country-orders',
      title: 'Region Orders',
      dataKey: 'totalOrders',
      trendKey: 'totalOrdersTrend',
      icon: Icons.shopping_cart,
    ),
  ],
  charts: [
    ChartDefinition(
      id: 'country-chart',
      title: 'Revenue by Country',
      chartType: ReportChartType.bar,
      dataKey: 'countrySales',
      xField: 'country',
      yFields: ['revenue'],
      tooltip: const ChartTooltipConfig(enabled: true),
      drillDown: const DrillDownDefinition(
        targetReportId: 'sales-by-customer',
        paramField: 'country',
        paramKey: 'country',
        label: 'Customers in {value}',
      ),
    ),
  ],
  grids: [
    GridDefinition(
      id: 'country-details',
      title: 'Country Details',
      dataKey: 'countryDetails',
      columns: const [
        GridColumnDefinition(field: 'country', title: 'Country', width: 180),
        GridColumnDefinition(
          field: 'revenue',
          title: 'Revenue',
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          formatString: '#,##0',
          aggregate: 'sum',
        ),
        GridColumnDefinition(
          field: 'orders',
          title: 'Orders',
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          aggregate: 'sum',
        ),
        GridColumnDefinition(
          field: 'growth',
          title: 'Growth %',
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          formatString: '#0.0',
        ),
      ],
      summaries: const [
        GridSummaryConfig(field: 'revenue', type: 'sum'),
        GridSummaryConfig(field: 'orders', type: 'sum'),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(
      id: 'kpi',
      type: SectionType.cards,
      columns: 2,
    ),
    SectionDefinition(
      id: 'chart',
      type: SectionType.charts,
      columns: 1,
    ),
    SectionDefinition(
      id: 'grid',
      type: SectionType.grids,
    ),
  ],
);

final salesByCustomerReport = ReportDefinition(
  id: 'sales-by-customer',
  title: 'Sales by Customer',
  description: 'Drill-down: individual customer sales',
  category: 'Sales',
  icon: Icons.people,
  datasource: 'sales-by-customer',
  cards: [
    CardDefinition(
      id: 'cust-revenue',
      title: 'Total Revenue',
      dataKey: 'totalRevenue',
      trendKey: 'totalRevenueTrend',
      icon: Icons.monetization_on,
      isCurrency: true,
    ),
  ],
  grids: [
    GridDefinition(
      id: 'customer-grid',
      title: 'Customer Sales',
      dataKey: 'customerDetails',
      columns: const [
        GridColumnDefinition(field: 'customer', title: 'Customer', width: 200),
        GridColumnDefinition(
          field: 'orders',
          title: 'Orders',
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          aggregate: 'sum',
        ),
        GridColumnDefinition(
          field: 'revenue',
          title: 'Revenue',
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          formatString: '#,##0',
          aggregate: 'sum',
        ),
        GridColumnDefinition(
          field: 'lastOrder',
          title: 'Last Order',
          columnType: ColumnType.date,
        ),
      ],
      sorting: const GridSortConfig(field: 'revenue', ascending: false),
      summaries: const [
        GridSummaryConfig(field: 'revenue', type: 'sum'),
        GridSummaryConfig(field: 'orders', type: 'sum'),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(id: 'kpi', type: SectionType.cards, columns: 1),
    SectionDefinition(id: 'grid', type: SectionType.grids),
  ],
);
