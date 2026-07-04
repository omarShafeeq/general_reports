import 'package:flutter/material.dart';

import '../../models/models.dart';

final customerReport = ReportDefinition(
  id: 'customer-report',
  title: 'Customer Analysis Report',
  description: 'Customer revenue, orders, and purchase history',
  category: 'Sales',
  icon: Icons.people_outline,
  datasource: 'sales-by-customer',
  filters: const [
    FilterDefinition(id: 'dateRange', label: 'Date Range', type: ReportFilterType.dateRange),
    FilterDefinition(id: 'region', label: 'Region', type: ReportFilterType.singleSelect, apiEndpoint: '/api/regions'),
  ],
  cards: const [
    CardDefinition(id: 'totalRevenue', title: 'Customer Revenue', dataKey: 'totalRevenue', trendKey: 'totalRevenueTrend', icon: Icons.attach_money, isCurrency: true, color: Colors.blue),
  ],
  charts: const [
    ChartDefinition(
      id: 'customerRevenueChart',
      title: 'Top Customers by Revenue',
      chartType: ReportChartType.bar,
      dataKey: 'customerSales',
      xField: 'customer',
      yFields: ['revenue'],
      tooltip: ChartTooltipConfig(enabled: true),
      dataLabels: ChartDataLabelConfig(visible: true),
    ),
  ],
  grids: const [
    GridDefinition(
      id: 'customerGrid',
      title: 'Customers',
      dataKey: 'customerDetails',
      allowFiltering: true,
      allowColumnResize: true,
      paging: GridPagingConfig(pageSize: 15),
      columns: [
        GridColumnDefinition(field: 'customer', title: 'Customer'),
        GridColumnDefinition(field: 'orders', title: 'Orders', columnType: ColumnType.numeric, alignment: ColumnAlignment.right),
        GridColumnDefinition(field: 'revenue', title: 'Revenue', columnType: ColumnType.numeric, alignment: ColumnAlignment.right, formatString: '\$#,##0'),
        GridColumnDefinition(field: 'lastOrder', title: 'Last Order', columnType: ColumnType.date),
      ],
      sorting: GridSortConfig(field: 'revenue', ascending: false),
      nestedGrids: [
        NestedGridDefinition(
          id: 'customerOrdersNested',
          parentKeyField: 'customer',
          childDatasource: 'order-items',
          childFilterKey: 'customer',
          gridDefinition: GridDefinition(
            id: 'customerOrderItemGrid',
            title: 'Order Items',
            dataKey: 'items',
            columns: [
              GridColumnDefinition(field: 'itemId', title: 'Item ID'),
              GridColumnDefinition(field: 'product', title: 'Product'),
              GridColumnDefinition(field: 'quantity', title: 'Qty', columnType: ColumnType.numeric, alignment: ColumnAlignment.right),
              GridColumnDefinition(field: 'unitPrice', title: 'Unit Price', columnType: ColumnType.numeric, alignment: ColumnAlignment.right, formatString: '\$#,##0.00'),
              GridColumnDefinition(field: 'total', title: 'Total', columnType: ColumnType.numeric, alignment: ColumnAlignment.right, formatString: '\$#,##0'),
            ],
          ),
        ),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(id: 'filter-section', type: SectionType.filters),
    SectionDefinition(id: 'cards-section', type: SectionType.cards, columns: 1),
    SectionDefinition(id: 'chart-section', type: SectionType.charts),
    SectionDefinition(id: 'grid-section', type: SectionType.grids),
  ],
);
