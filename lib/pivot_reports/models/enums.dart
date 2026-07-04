enum PivotAggregation {
  sum,
  count,
  average,
  min,
  max,
}

enum PivotFieldType {
  text,
  numeric,
  date,
  dateTime,
  boolean,
}

enum PivotFieldRole {
  available,
  row,
  column,
  value,
  filter,
}

enum PivotChartType {
  bar,
  pie,
  line,
  area,
  doughnut,
}

enum PivotGroupInterval {
  none,
  date,
  month,
  quarter,
  year,
  category,
  custom,
}

enum PivotSortDirection {
  ascending,
  descending,
  none,
}

enum PivotReportStatus {
  initial,
  loadingDataSources,
  loadingFields,
  executing,
  loaded,
  saving,
  error,
}

extension PivotAggregationX on PivotAggregation {
  String get label {
    switch (this) {
      case PivotAggregation.sum:
        return 'Sum';
      case PivotAggregation.count:
        return 'Count';
      case PivotAggregation.average:
        return 'Average';
      case PivotAggregation.min:
        return 'Min';
      case PivotAggregation.max:
        return 'Max';
    }
  }
}

extension PivotFieldTypeX on PivotFieldType {
  bool get isNumeric => this == PivotFieldType.numeric;
  bool get isDate =>
      this == PivotFieldType.date || this == PivotFieldType.dateTime;
}

extension PivotGroupIntervalX on PivotGroupInterval {
  String get label {
    switch (this) {
      case PivotGroupInterval.none:
        return 'None';
      case PivotGroupInterval.date:
        return 'Date';
      case PivotGroupInterval.month:
        return 'Month';
      case PivotGroupInterval.quarter:
        return 'Quarter';
      case PivotGroupInterval.year:
        return 'Year';
      case PivotGroupInterval.category:
        return 'Category';
      case PivotGroupInterval.custom:
        return 'Custom';
    }
  }
}
