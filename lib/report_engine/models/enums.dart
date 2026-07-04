import 'package:flutter/material.dart';

enum ReportChartType {
  line,
  bar,
  column,
  pie,
  doughnut,
  scatter,
  area,
  spline,
  splineArea,
  stepLine,
  stepArea,
  stackedColumn,
  stackedBar,
  stackedArea,
  stackedColumn100,
  stackedBar100,
  rangeColumn,
  rangeArea,
  bubble,
  waterfall,
  funnel,
  pyramid,
  radialBar,
  candle,
  hilo,
  hiloOpenClose,
  histogram,
  boxWhisker,
  pareto,
  errorBar,
}

enum ReportFilterType {
  date,
  dateRange,
  month,
  quarter,
  year,
  company,
  branch,
  department,
  customer,
  employee,
  product,
  category,
  status,
  boolean,
  multiSelect,
  singleSelect,
  searchableDropdown,
  treeSelection,
}

enum SectionType {
  header,
  filters,
  cards,
  charts,
  grids,
  footer,
  custom,
}

enum ColumnType {
  text,
  numeric,
  date,
  dateTime,
  checkbox,
  image,
  custom,
}

enum ColumnAlignment {
  left,
  center,
  right,
}

enum ExportFormat {
  pdf,
  excel,
  csv,
  print,
  image,
}

enum ChartAxisType {
  category,
  numeric,
  dateTime,
  dateTimeCategory,
  logarithmic,
}

enum GridSelectionMode {
  none,
  single,
  multiple,
  singleDeselect,
}

/// Where selected column summaries are rendered in the grid.
enum GridSummaryPlacement {
  footer,
  header,
  both,
}

enum GridConditionType {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  greaterThanOrEqual,
  lessThanOrEqual,
  between,
  contains,
  beginsWith,
  endsWith,
}

enum FitMode {
  none,
  fitWidth,
  fitPage,
}

enum ReportViewMode {
  dashboard,
  document,
}

extension ColumnAlignmentX on ColumnAlignment {
  Alignment toAlignment() {
    switch (this) {
      case ColumnAlignment.left:
        return Alignment.centerLeft;
      case ColumnAlignment.center:
        return Alignment.center;
      case ColumnAlignment.right:
        return Alignment.centerRight;
    }
  }
}
