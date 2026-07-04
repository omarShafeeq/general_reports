import 'package:flutter/material.dart';

import '../../models/models.dart';

final hrReport = ReportDefinition(
  id: 'hr-report',
  title: 'HR Detail Report',
  description: 'Department, employee, and attendance drill-down',
  category: 'HR',
  icon: Icons.badge,
  datasource: 'hr-overview',
  filters: const [
    FilterDefinition(
      id: 'department',
      label: 'Department',
      type: ReportFilterType.singleSelect,
      apiEndpoint: '/api/departments',
    ),
  ],
  charts: const [
    ChartDefinition(
      id: 'deptHeadcountChart',
      title: 'Headcount by Department',
      chartType: ReportChartType.column,
      dataKey: 'departmentDistribution',
      xField: 'department',
      yFields: ['count'],
      tooltip: ChartTooltipConfig(enabled: true),
      dataLabels: ChartDataLabelConfig(visible: true),
      drillDown: DrillDownDefinition(
        targetReportId: 'hr-dept-detail',
        paramField: 'department',
        paramKey: 'department',
        label: '{value} Department',
      ),
    ),
  ],
  grids: const [
    GridDefinition(
      id: 'employeeGrid',
      title: 'Employee Directory',
      dataKey: 'employees',
      allowFiltering: true,
      allowColumnResize: true,
      paging: GridPagingConfig(pageSize: 15),
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
      conditionalFormats: [
        GridConditionalFormat(
          field: 'status',
          conditionType: GridConditionType.equals,
          value: 'On Leave',
          style: GridCellStyle(textColor: 0xFFFF9800, bold: true),
        ),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(id: 'filter-section', type: SectionType.filters),
    SectionDefinition(id: 'chart-section', type: SectionType.charts),
    SectionDefinition(id: 'grid-section', type: SectionType.grids),
  ],
);

final hrDeptDetailReport = ReportDefinition(
  id: 'hr-dept-detail',
  title: 'Department Detail',
  description: 'Employees in selected department',
  category: 'HR',
  icon: Icons.groups,
  datasource: 'hr-overview',
  grids: const [
    GridDefinition(
      id: 'deptEmployeeGrid',
      title: 'Department Employees',
      dataKey: 'employees',
      allowFiltering: true,
      paging: GridPagingConfig(pageSize: 20),
      columns: [
        GridColumnDefinition(field: 'employeeId', title: 'ID'),
        GridColumnDefinition(field: 'name', title: 'Name'),
        GridColumnDefinition(field: 'position', title: 'Position'),
        GridColumnDefinition(field: 'salary', title: 'Salary', columnType: ColumnType.numeric, alignment: ColumnAlignment.right, formatString: '\$#,##0'),
        GridColumnDefinition(field: 'hireDate', title: 'Hire Date', columnType: ColumnType.date),
        GridColumnDefinition(field: 'status', title: 'Status'),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(id: 'grid-section', type: SectionType.grids),
  ],
);
