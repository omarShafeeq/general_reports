import 'package:equatable/equatable.dart';

import 'drill_down_definition.dart';
import 'enums.dart';
import 'nested_grid_definition.dart';

class GridDefinition extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String dataKey;
  final List<GridColumnDefinition> columns;
  final GridSortConfig? sorting;
  final bool allowFiltering;
  final bool allowGrouping;
  final List<String>? groupByColumns;
  final List<GridSummaryConfig>? summaries;
  final List<GridSummaryConfig>? groupSummaries;
  final List<GridSummaryConfig>? captionSummaries;
  final bool allowEditing;
  final GridPagingConfig? paging;
  final bool allowColumnResize;
  final bool allowColumnReorder;
  final int frozenColumns;
  final int frozenRows;
  final bool showCheckboxColumn;
  final GridSelectionMode selectionMode;
  final bool allowContextMenu;
  final List<GridConditionalFormat>? conditionalFormats;
  final List<NestedGridDefinition>? nestedGrids;
  final DrillDownDefinition? drillDown;
  final GridDisplayOptions? displayOptions;
  final Map<String, dynamic>? options;

  const GridDefinition({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dataKey,
    required this.columns,
    this.sorting,
    this.allowFiltering = false,
    this.allowGrouping = false,
    this.groupByColumns,
    this.summaries,
    this.groupSummaries,
    this.captionSummaries,
    this.allowEditing = false,
    this.paging,
    this.allowColumnResize = true,
    this.allowColumnReorder = false,
    this.frozenColumns = 0,
    this.frozenRows = 0,
    this.showCheckboxColumn = false,
    this.selectionMode = GridSelectionMode.single,
    this.allowContextMenu = false,
    this.conditionalFormats,
    this.nestedGrids,
    this.drillDown,
    this.displayOptions,
    this.options,
  });

  bool get hasNestedGrids => nestedGrids != null && nestedGrids!.isNotEmpty;

  @override
  List<Object?> get props => [
        id, title, subtitle, dataKey, columns, sorting,
        allowFiltering, allowGrouping, groupByColumns,
        summaries, groupSummaries, captionSummaries,
        allowEditing, paging, allowColumnResize, allowColumnReorder,
        frozenColumns, frozenRows, showCheckboxColumn, selectionMode,
        allowContextMenu, conditionalFormats, nestedGrids, drillDown,
        displayOptions, options,
      ];
}

/// Runtime grid UI options: column picker and summary column selection.
class GridDisplayOptions extends Equatable {
  final bool showColumnPicker;
  final bool showSummaryPicker;
  final bool allowSummaryInHeader;
  final GridSummaryPlacement defaultSummaryPlacement;
  final List<String>? summarizableFields;
  final String summaryRowLabel;

  const GridDisplayOptions({
    this.showColumnPicker = true,
    this.showSummaryPicker = true,
    this.allowSummaryInHeader = true,
    this.defaultSummaryPlacement = GridSummaryPlacement.footer,
    this.summarizableFields,
    this.summaryRowLabel = 'Total',
  });

  bool get hasOptions =>
      showColumnPicker || showSummaryPicker || allowSummaryInHeader;

  @override
  List<Object?> get props => [
        showColumnPicker,
        showSummaryPicker,
        allowSummaryInHeader,
        defaultSummaryPlacement,
        summarizableFields,
        summaryRowLabel,
      ];
}

class GridColumnDefinition extends Equatable {
  final String field;
  final String title;
  final double? width;
  final double? minWidth;
  final double? maxWidth;
  final bool visible;
  final bool sortable;
  final bool filterable;
  final ColumnAlignment alignment;
  final String? formatString;
  final String? aggregate;
  final ColumnType columnType;
  final bool allowEditing;
  final bool frozen;

  const GridColumnDefinition({
    required this.field,
    required this.title,
    this.width,
    this.minWidth,
    this.maxWidth,
    this.visible = true,
    this.sortable = true,
    this.filterable = false,
    this.alignment = ColumnAlignment.left,
    this.formatString,
    this.aggregate,
    this.columnType = ColumnType.text,
    this.allowEditing = false,
    this.frozen = false,
  });

  @override
  List<Object?> get props => [
        field, title, width, minWidth, maxWidth, visible, sortable, filterable,
        alignment, formatString, aggregate, columnType, allowEditing, frozen,
      ];
}

class GridSortConfig extends Equatable {
  final String field;
  final bool ascending;
  final bool allowMultiSort;

  const GridSortConfig({
    required this.field,
    this.ascending = true,
    this.allowMultiSort = false,
  });

  @override
  List<Object?> get props => [field, ascending, allowMultiSort];
}

class GridSummaryConfig extends Equatable {
  final String field;
  final String type; // sum, avg, count, min, max
  final String? title;

  const GridSummaryConfig({
    required this.field,
    required this.type,
    this.title,
  });

  @override
  List<Object?> get props => [field, type, title];
}

class GridPagingConfig extends Equatable {
  final int pageSize;
  final List<int> pageSizeOptions;
  final bool infiniteScroll;
  final bool lazyLoading;

  const GridPagingConfig({
    this.pageSize = 20,
    this.pageSizeOptions = const [10, 20, 50, 100],
    this.infiniteScroll = false,
    this.lazyLoading = false,
  });

  @override
  List<Object?> get props => [pageSize, pageSizeOptions, infiniteScroll, lazyLoading];
}

class GridConditionalFormat extends Equatable {
  final String field;
  final GridConditionType conditionType;
  final dynamic value;
  final dynamic value2;
  final GridCellStyle style;

  const GridConditionalFormat({
    required this.field,
    required this.conditionType,
    required this.value,
    this.value2,
    required this.style,
  });

  @override
  List<Object?> get props => [field, conditionType, value, value2, style];
}

class GridCellStyle extends Equatable {
  final int? backgroundColor;
  final int? textColor;
  final bool bold;
  final bool italic;
  final String? icon;

  const GridCellStyle({
    this.backgroundColor,
    this.textColor,
    this.bold = false,
    this.italic = false,
    this.icon,
  });

  @override
  List<Object?> get props => [backgroundColor, textColor, bold, italic, icon];
}
