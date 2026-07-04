import 'package:flutter/material.dart';

import '../../models/models.dart';

final hrDashboardDefinition = ReportDefinition(
  id: 'hr-dashboard',
  title: 'HR Dashboard',
  description: 'Workforce analytics and employee metrics',
  category: 'Dashboards',
  icon: Icons.people,
  datasource: 'hr-overview',
  layout: const LayoutDefinition(
    desktopColumns: 2,
    tabletColumns: 2,
    mobileColumns: 1,
    spacing: 16,
    runSpacing: 16,
    widgets: [
      LayoutWidgetConfig(widgetId: 'filter-section', columnSpan: 2, order: 0),
      LayoutWidgetConfig(widgetId: 'cards', columnSpan: 2, order: 1, minHeight: 130),
      LayoutWidgetConfig(widgetId: 'dept-chart', columnSpan: 1, order: 2, minHeight: 400),
      LayoutWidgetConfig(widgetId: 'tenure-chart', columnSpan: 1, order: 3, minHeight: 400),
      LayoutWidgetConfig(widgetId: 'employees', columnSpan: 2, order: 4, minHeight: 400),
    ],
  ),
  filters: const [
    FilterDefinition(id: 'department', label: 'Department', type: ReportFilterType.singleSelect, apiEndpoint: '/api/departments'),
    FilterDefinition(id: 'status', label: 'Status', type: ReportFilterType.singleSelect, apiEndpoint: '/api/statuses'),
  ],
  cards: const [
    CardDefinition(id: 'totalEmployees', title: 'Total Employees', dataKey: 'totalEmployees', trendKey: 'employeeTrend', icon: Icons.people, color: Colors.blue),
    CardDefinition(id: 'avgSalary', title: 'Avg Salary', dataKey: 'avgSalary', trendKey: 'salaryTrend', icon: Icons.attach_money, isCurrency: true, color: Colors.green),
    CardDefinition(id: 'turnoverRate', title: 'Turnover Rate', dataKey: 'turnoverRate', trendKey: 'turnoverTrend', icon: Icons.swap_horiz, formatString: '#,##0.0', color: Colors.orange),
    CardDefinition(id: 'openPositions', title: 'Open Positions', dataKey: 'openPositions', trendKey: 'openPositionsTrend', icon: Icons.work_outline, color: Colors.purple),
  ],
  charts: const [
    ChartDefinition(
      id: 'deptDistChart',
      title: 'Headcount by Department',
      chartType: ReportChartType.column,
      dataKey: 'departmentDistribution',
      xField: 'department',
      yFields: ['count'],
      tooltip: ChartTooltipConfig(enabled: true),
      dataLabels: ChartDataLabelConfig(visible: true),
    ),
    ChartDefinition(
      id: 'tenureChart',
      title: 'Tenure Distribution',
      chartType: ReportChartType.doughnut,
      dataKey: 'tenureDistribution',
      xField: 'range',
      yFields: ['count'],
      legend: ChartLegendConfig(visible: true, position: 'right'),
      tooltip: ChartTooltipConfig(enabled: true),
    ),
  ],
  grids: const [
    GridDefinition(
      id: 'employeeGrid',
      title: 'Employee Directory',
      dataKey: 'employees',
      allowFiltering: true,
      allowColumnResize: true,
      paging: GridPagingConfig(pageSize: 10),
      columns: [
        GridColumnDefinition(field: 'employeeId', title: 'ID'),
        GridColumnDefinition(field: 'name', title: 'Name'),
        GridColumnDefinition(field: 'department', title: 'Department'),
        GridColumnDefinition(field: 'position', title: 'Position'),
        GridColumnDefinition(field: 'salary', title: 'Salary', columnType: ColumnType.numeric, alignment: ColumnAlignment.right, formatString: '\$#,##0'),
        GridColumnDefinition(field: 'hireDate', title: 'Hire Date', columnType: ColumnType.date),
        GridColumnDefinition(field: 'status', title: 'Status'),
      ],
      sorting: GridSortConfig(field: 'name', ascending: true),
    ),
  ],
  sections: const [
    SectionDefinition(id: 'filter-section', type: SectionType.filters),
    SectionDefinition(id: 'cards', type: SectionType.cards, columns: 4, columnSpan: 2),
    SectionDefinition(id: 'dept-chart', type: SectionType.charts, childIds: ['deptDistChart']),
    SectionDefinition(id: 'tenure-chart', type: SectionType.charts, childIds: ['tenureChart']),
    SectionDefinition(id: 'employees', type: SectionType.grids, columnSpan: 2),
  ],
);
