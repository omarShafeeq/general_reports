import 'package:equatable/equatable.dart';

import 'enums.dart';
import 'pivot_field.dart';
import 'pivot_filter.dart';
import 'pivot_value.dart';

class PivotLayout extends Equatable {
  final String dataSourceId;
  final List<PivotField> rows;
  final List<PivotField> columns;
  final List<PivotValue> values;
  final List<PivotFilter> filters;
  final List<PivotSortConfig> sorting;
  final PivotGroupInterval groupInterval;

  const PivotLayout({
    required this.dataSourceId,
    this.rows = const [],
    this.columns = const [],
    this.values = const [],
    this.filters = const [],
    this.sorting = const [],
    this.groupInterval = PivotGroupInterval.none,
  });

  bool get isValid => rows.isNotEmpty && values.isNotEmpty;

  PivotLayout copyWith({
    String? dataSourceId,
    List<PivotField>? rows,
    List<PivotField>? columns,
    List<PivotValue>? values,
    List<PivotFilter>? filters,
    List<PivotSortConfig>? sorting,
    PivotGroupInterval? groupInterval,
  }) {
    return PivotLayout(
      dataSourceId: dataSourceId ?? this.dataSourceId,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      values: values ?? this.values,
      filters: filters ?? this.filters,
      sorting: sorting ?? this.sorting,
      groupInterval: groupInterval ?? this.groupInterval,
    );
  }

  Map<String, dynamic> toRequestJson() => {
        'dataSource': dataSourceId,
        'rows': rows.map((f) => f.name).toList(),
        'columns': columns.map((f) => f.name).toList(),
        'values': values.map((v) => v.toJson()).toList(),
        'filters': {
          for (final f in filters) f.fieldName: f.value,
        },
        'sorting': sorting.map((s) => s.toJson()).toList(),
        'grouping': groupInterval != PivotGroupInterval.none
            ? [groupInterval.name]
            : [],
      };

  Map<String, dynamic> toJson() => {
        'dataSourceId': dataSourceId,
        'rows': rows.map((f) => f.toJson()).toList(),
        'columns': columns.map((f) => f.toJson()).toList(),
        'values': values.map((v) => v.toJson()).toList(),
        'filters': filters.map((f) => f.toJson()).toList(),
        'sorting': sorting.map((s) => s.toJson()).toList(),
        'groupInterval': groupInterval.name,
      };

  factory PivotLayout.fromJson(Map<String, dynamic> json) => PivotLayout(
        dataSourceId: json['dataSourceId'] as String,
        rows: (json['rows'] as List?)
                ?.map((e) => PivotField.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        columns: (json['columns'] as List?)
                ?.map((e) => PivotField.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        values: (json['values'] as List?)
                ?.map((e) => PivotValue.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        filters: (json['filters'] as List?)
                ?.map((e) => PivotFilter.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        sorting: (json['sorting'] as List?)
                ?.map((e) => PivotSortConfig.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        groupInterval: PivotGroupInterval.values
            .byName(json['groupInterval'] as String? ?? 'none'),
      );

  @override
  List<Object?> get props => [
        dataSourceId, rows, columns, values,
        filters, sorting, groupInterval,
      ];
}

class PivotSortConfig extends Equatable {
  final String field;
  final PivotSortDirection direction;

  const PivotSortConfig({
    required this.field,
    this.direction = PivotSortDirection.ascending,
  });

  Map<String, dynamic> toJson() => {
        'field': field,
        'direction': direction.name,
      };

  factory PivotSortConfig.fromJson(Map<String, dynamic> json) => PivotSortConfig(
        field: json['field'] as String,
        direction: PivotSortDirection.values
            .byName(json['direction'] as String? ?? 'ascending'),
      );

  @override
  List<Object?> get props => [field, direction];
}
