import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/grid_view_settings_cubit.dart';
import '../models/enums.dart';
import '../models/grid_definition.dart';
import '../utils/grid_summary_utils.dart';
import '../widgets/grid_column_header.dart';
import '../widgets/grid_options_toolbar.dart';

class DynamicGridRenderer extends StatefulWidget {
  final GridDefinition definition;
  final List<Map<String, dynamic>> data;
  final void Function(Map<String, dynamic> row)? onRowTap;
  final GlobalKey<SfDataGridState>? gridKey;
  final Widget Function(Map<String, dynamic> row)? expandedRowBuilder;

  const DynamicGridRenderer({
    super.key,
    required this.definition,
    required this.data,
    this.onRowTap,
    this.gridKey,
    this.expandedRowBuilder,
  });

  @override
  State<DynamicGridRenderer> createState() => _DynamicGridRendererState();
}

class _DynamicGridRendererState extends State<DynamicGridRenderer> {
  final Set<int> _expandedRows = {};

  @override
  Widget build(BuildContext context) {
    final def = widget.definition;

    return Card(
      margin: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md, AppSizes.md, AppSizes.md, 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  def.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (def.subtitle != null)
                  Text(
                    def.subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          GridOptionsToolbar(definition: def, data: widget.data),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: BlocBuilder<GridViewSettingsCubit, GridViewSettingsState>(
                buildWhen: (prev, curr) =>
                    prev.forGrid(def.id) != curr.forGrid(def.id),
                builder: (context, state) {
                  final cubit = context.read<GridViewSettingsCubit>();
                  final runtime = state.forGrid(def.id);
                  final visibleColumns =
                      cubit.visibleColumnsFor(def, runtime);
                  final summaries = cubit.summariesFor(def, runtime);
                  final showInFooter =
                      cubit.showSummaryInFooter(def, runtime);
                  final showInHeader =
                      cubit.showSummaryInHeader(def, runtime);

                  return _GridBody(
                    key: ValueKey(
                      '${def.id}_${visibleColumns.map((c) => c.field).join(',')}_'
                      '${summaries.map((s) => s.field).join(',')}_'
                      '${showInFooter}_$showInHeader',
                    ),
                    definition: def,
                    data: widget.data,
                    visibleColumns: visibleColumns,
                    summaries: summaries,
                    showSummaryInFooter: showInFooter,
                    showSummaryInHeader: showInHeader,
                    gridKey: widget.gridKey,
                    onRowTap: widget.onRowTap,
                    expandedRowBuilder: widget.expandedRowBuilder,
                    expandedRows: _expandedRows,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridBody extends StatefulWidget {
  final GridDefinition definition;
  final List<Map<String, dynamic>> data;
  final List<GridColumnDefinition> visibleColumns;
  final List<GridSummaryConfig> summaries;
  final bool showSummaryInFooter;
  final bool showSummaryInHeader;
  final GlobalKey<SfDataGridState>? gridKey;
  final void Function(Map<String, dynamic> row)? onRowTap;
  final Widget Function(Map<String, dynamic> row)? expandedRowBuilder;
  final Set<int> expandedRows;

  const _GridBody({
    super.key,
    required this.definition,
    required this.data,
    required this.visibleColumns,
    required this.summaries,
    this.showSummaryInFooter = true,
    this.showSummaryInHeader = false,
    this.gridKey,
    this.onRowTap,
    this.expandedRowBuilder,
    required this.expandedRows,
  });

  @override
  State<_GridBody> createState() => _GridBodyState();
}

class _GridBodyState extends State<_GridBody> {
  late ReportDataGridSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _createSource();
  }

  @override
  void didUpdateWidget(covariant _GridBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.visibleColumns != widget.visibleColumns ||
        oldWidget.summaries != widget.summaries ||
        oldWidget.showSummaryInFooter != widget.showSummaryInFooter ||
        oldWidget.showSummaryInHeader != widget.showSummaryInHeader) {
      _dataSource = _createSource();
    }
  }

  ReportDataGridSource _createSource() {
    return ReportDataGridSource(
      data: widget.data,
      columns: widget.visibleColumns,
      conditionalFormats: widget.definition.conditionalFormats,
      paging: widget.definition.paging,
      summaries: widget.summaries.isEmpty ? null : widget.summaries,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGrid(widget.definition);
  }

  Widget _buildGrid(GridDefinition def) {
    final selectionMode = _mapSelectionMode(def.selectionMode);

    final summaryKey =
        '${widget.visibleColumns.map((c) => c.field).join('-')}_'
        '${widget.summaries.map((s) => s.field).join('-')}_'
        '${widget.showSummaryInFooter}_${widget.showSummaryInHeader}';
    final hasHeaderSums =
        widget.showSummaryInHeader && widget.summaries.isNotEmpty;
    final grid = SfDataGrid(
      key: def.displayOptions?.hasOptions == true
          ? ValueKey('grid_$summaryKey')
          : widget.gridKey,
      source: _dataSource,
      columns: _buildColumns(def),
      allowSorting: def.sorting != null || def.columns.any((c) => c.sortable),
      allowMultiColumnSorting: def.sorting?.allowMultiSort ?? false,
      allowFiltering: def.allowFiltering,
      allowColumnsResizing: def.allowColumnResize,
      allowColumnsDragging: def.allowColumnReorder,
      columnWidthMode: ColumnWidthMode.fill,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      rowHeight: AppSizes.gridRowHeight,
      headerRowHeight:
          hasHeaderSums ? AppSizes.gridHeaderHeight + 20 : AppSizes.gridHeaderHeight,
      frozenColumnsCount: def.frozenColumns,
      frozenRowsCount: def.frozenRows,
      showCheckboxColumn: def.showCheckboxColumn,
      selectionMode: selectionMode,
      navigationMode: GridNavigationMode.cell,
      onCellTap: widget.onRowTap != null
          ? (details) {
              if (details.rowColumnIndex.rowIndex > 0) {
                final rowIndex = details.rowColumnIndex.rowIndex - 1;
                if (rowIndex < widget.data.length) {
                  widget.onRowTap!(widget.data[rowIndex]);
                }
              }
            }
          : null,
      tableSummaryRows: _buildTableSummaryRows(def),
    );

    if (def.paging != null && !def.paging!.infiniteScroll) {
      final pageCount = widget.data.isEmpty
          ? 1.0
          : (widget.data.length / def.paging!.pageSize).ceil().toDouble();
      return Column(
        children: [
          Expanded(child: grid),
          SfDataPager(
            delegate: _dataSource,
            pageCount: pageCount,
            availableRowsPerPage: def.paging!.pageSizeOptions,
          ),
        ],
      );
    }

    return grid;
  }

  List<GridColumn> _buildColumns(GridDefinition def) {
    final cols = <GridColumn>[];

    if (def.hasNestedGrids && widget.expandedRowBuilder != null) {
      cols.add(GridColumn(
        columnName: '__expand__',
        label: const SizedBox.shrink(),
        width: 48,
        allowSorting: false,
        allowFiltering: false,
      ));
    }

    for (final col in widget.visibleColumns) {
      final summary = widget.showSummaryInHeader
          ? summaryForColumn(col, widget.summaries)
          : null;

      cols.add(GridColumn(
        columnName: col.field,
        label: GridColumnHeaderLabel(
          column: col,
          summary: summary,
          data: widget.data,
        ),
        width: col.width ?? double.nan,
        minimumWidth: col.minWidth ?? 0,
        maximumWidth: col.maxWidth ?? double.infinity,
        allowSorting: col.sortable,
        allowFiltering: col.filterable,
        allowEditing: col.allowEditing,
      ));
    }

    return cols;
  }

  SelectionMode _mapSelectionMode(GridSelectionMode mode) {
    switch (mode) {
      case GridSelectionMode.none:
        return SelectionMode.none;
      case GridSelectionMode.single:
        return widget.onRowTap != null
            ? SelectionMode.single
            : SelectionMode.none;
      case GridSelectionMode.multiple:
        return SelectionMode.multiple;
      case GridSelectionMode.singleDeselect:
        return SelectionMode.singleDeselect;
    }
  }

  List<GridTableSummaryRow> _buildTableSummaryRows(GridDefinition def) {
    final rows = <GridTableSummaryRow>[];
    final summaries = widget.summaries;

    if (summaries.isNotEmpty && widget.showSummaryInFooter) {
      final firstVisibleColumn = widget.visibleColumns.firstOrNull;
      rows.add(GridTableSummaryRow(
        showSummaryInRow: false,
        position: GridTableSummaryRowPosition.bottom,
        title: GridSummaryUtils.labelForSummaryRow(summaries),
        titleColumnSpan: firstVisibleColumn != null ? 1 : 0,
        color: const Color(0xFFEEEEEE),
        columns: summaries.map(_mapSummaryColumn).toList(),
      ));
    }

    return rows;
  }

  GridSummaryColumn _mapSummaryColumn(GridSummaryConfig s) {
    return GridSummaryColumn(
      name: '${s.field}_${s.type}',
      columnName: s.field,
      summaryType: _mapSummaryType(s.type),
    );
  }

  GridSummaryType _mapSummaryType(String type) {
    switch (type) {
      case 'sum':
        return GridSummaryType.sum;
      case 'avg':
        return GridSummaryType.average;
      case 'count':
        return GridSummaryType.count;
      case 'min':
        return GridSummaryType.minimum;
      case 'max':
        return GridSummaryType.maximum;
      default:
        return GridSummaryType.sum;
    }
  }
}

class ReportDataGridSource extends DataGridSource {
  final List<Map<String, dynamic>> data;
  final List<GridColumnDefinition> columns;
  final List<GridConditionalFormat>? conditionalFormats;
  final GridPagingConfig? paging;
  final List<GridSummaryConfig>? summaries;

  late List<DataGridRow> _allRows;
  List<DataGridRow> _pagedRows = [];

  ReportDataGridSource({
    required this.data,
    required this.columns,
    this.conditionalFormats,
    this.paging,
    this.summaries,
  }) {
    _allRows = data.map((row) {
      return DataGridRow(
        cells: columns.map((col) {
          return DataGridCell<dynamic>(
            columnName: col.field,
            value: row[col.field],
          );
        }).toList(),
      );
    }).toList();

    if (paging != null && !paging!.infiniteScroll) {
      _pagedRows = _allRows.take(paging!.pageSize).toList();
    } else {
      _pagedRows = _allRows;
    }
  }

  @override
  List<DataGridRow> get rows =>
      (paging != null && !paging!.infiniteScroll) ? _pagedRows : _allRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (paging == null) return false;
    final startIndex = newPageIndex * paging!.pageSize;
    final endIndex = (startIndex + paging!.pageSize).clamp(0, _allRows.length);

    if (startIndex < _allRows.length) {
      _pagedRows = _allRows.sublist(startIndex, endIndex);
    } else {
      _pagedRows = [];
    }
    notifyListeners();
    return true;
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    if (summaryColumn == null) return null;

    final summaryConfig = summaries
        ?.where((s) => s.field == summaryColumn.columnName)
        .firstOrNull;
    final colDef =
        columns.where((c) => c.field == summaryColumn.columnName).firstOrNull;

    final computed = summaryConfig != null
        ? GridSummaryUtils.compute(summaryConfig, data)
        : num.tryParse(summaryValue);

    final text = GridSummaryUtils.format(computed, colDef, config: summaryConfig);

    return Container(
      alignment: colDef?.alignment.toAlignment() ?? Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      color: const Color(0xFFEEEEEE),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final rowIndex = _allRows.indexOf(row);
    final rowData = rowIndex >= 0 && rowIndex < data.length
        ? data[rowIndex]
        : <String, dynamic>{};

    return DataGridRowAdapter(
      color: _getRowBackgroundColor(rowIndex),
      cells: row.getCells().map((cell) {
        final colDef = columns
            .where((c) => c.field == cell.columnName)
            .firstOrNull;

        final cellStyle = _getCellStyle(cell.columnName, cell.value, rowData);

        return Container(
          alignment: colDef?.alignment.toAlignment() ?? Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
          color: cellStyle?.backgroundColor != null
              ? Color(cellStyle!.backgroundColor!)
              : null,
          child: Text(
            _formatCellValue(cell.value, colDef),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: cellStyle?.textColor != null
                  ? Color(cellStyle!.textColor!)
                  : null,
              fontWeight:
                  cellStyle?.bold == true ? FontWeight.bold : null,
              fontStyle:
                  cellStyle?.italic == true ? FontStyle.italic : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Color? _getRowBackgroundColor(int rowIndex) {
    if (rowIndex.isOdd) return null;
    return null;
  }

  GridCellStyle? _getCellStyle(
    String columnName,
    dynamic value,
    Map<String, dynamic> rowData,
  ) {
    if (conditionalFormats == null || conditionalFormats!.isEmpty) return null;

    for (final format in conditionalFormats!) {
      if (format.field != columnName) continue;
      if (_evaluateCondition(format, value)) {
        return format.style;
      }
    }
    return null;
  }

  bool _evaluateCondition(GridConditionalFormat format, dynamic value) {
    if (value == null) return false;

    switch (format.conditionType) {
      case GridConditionType.equals:
        return value == format.value;
      case GridConditionType.notEquals:
        return value != format.value;
      case GridConditionType.greaterThan:
        return value is num && format.value is num && value > format.value;
      case GridConditionType.lessThan:
        return value is num && format.value is num && value < format.value;
      case GridConditionType.greaterThanOrEqual:
        return value is num && format.value is num && value >= format.value;
      case GridConditionType.lessThanOrEqual:
        return value is num && format.value is num && value <= format.value;
      case GridConditionType.between:
        return value is num &&
            format.value is num &&
            format.value2 is num &&
            value >= format.value &&
            value <= format.value2;
      case GridConditionType.contains:
        return value.toString().contains(format.value.toString());
      case GridConditionType.beginsWith:
        return value.toString().startsWith(format.value.toString());
      case GridConditionType.endsWith:
        return value.toString().endsWith(format.value.toString());
    }
  }

  String _formatCellValue(dynamic value, GridColumnDefinition? colDef) {
    if (value == null) return '';
    if (colDef == null) return value.toString();

    if (colDef.formatString != null && value is num) {
      try {
        return NumberFormat(colDef.formatString).format(value);
      } catch (_) {
        return value.toString();
      }
    }

    if (colDef.columnType == ColumnType.numeric && value is num) {
      return NumberFormat('#,##0.##').format(value);
    }

    if (colDef.columnType == ColumnType.date && value is String) {
      try {
        final date = DateTime.parse(value);
        return DateFormat('MMM dd, yyyy').format(date);
      } catch (_) {
        return value;
      }
    }

    if (colDef.columnType == ColumnType.dateTime && value is String) {
      try {
        final date = DateTime.parse(value);
        return DateFormat('MMM dd, yyyy HH:mm').format(date);
      } catch (_) {
        return value;
      }
    }

    return value.toString();
  }
}
