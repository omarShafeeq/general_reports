import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/grid_view_settings_cubit.dart';
import '../data/report_repository.dart';
import '../models/enums.dart';
import '../models/grid_definition.dart';
import '../utils/grid_summary_utils.dart';
import '../renderers/nested_grid_renderer.dart';
import 'grid_options_toolbar.dart';
import 'grid_column_header.dart';
/// DevExpress-style master-detail table with expandable rows and nested grids.
class DocumentMasterDetailGrid extends StatefulWidget {
  final GridDefinition definition;
  final List<Map<String, dynamic>> data;
  final ReportRepository repository;
  final bool compact;

  const DocumentMasterDetailGrid({
    super.key,
    required this.definition,
    required this.data,
    required this.repository,
    this.compact = false,
  });

  static const headerColor = Color(0xFF00897B);
  static const headerTextColor = Colors.white;
  static const detailBackground = Color(0xFFF5F5F5);
  static const rowBorderColor = Color(0xFFE0E0E0);
  static const summaryBackground = Color(0xFFEEEEEE);

  @override
  State<DocumentMasterDetailGrid> createState() =>
      _DocumentMasterDetailGridState();
}

class _DocumentMasterDetailGridState extends State<DocumentMasterDetailGrid> {
  final Set<int> _expandedRows = {};

  @override
  Widget build(BuildContext context) {
    final def = widget.definition;

    return Padding(
      padding: widget.compact
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(48, 0, 48, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (def.title.isNotEmpty) ...[
            Text(
              def.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 8),
          ],
          GridOptionsToolbar(definition: def, data: widget.data),
          BlocBuilder<GridViewSettingsCubit, GridViewSettingsState>(
            buildWhen: (prev, curr) =>
                prev.forGrid(def.id) != curr.forGrid(def.id),
            builder: (context, state) {
              final cubit = context.read<GridViewSettingsCubit>();
              final runtime = state.forGrid(def.id);
              final columns = cubit.visibleColumnsFor(def, runtime);
              final summaries = cubit.summariesFor(def, runtime);
              final showInFooter =
                  cubit.showSummaryInFooter(def, runtime);
              final showInHeader =
                  cubit.showSummaryInHeader(def, runtime);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderRow(columns, summaries, showInHeader),
                  ...List.generate(widget.data.length, (index) {
                    return _buildDataRow(index, columns, def);
                  }),
                  if (summaries.isNotEmpty && showInFooter)
                    _buildSummaryRow(columns, summaries),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildHeaderRow(
    List<GridColumnDefinition> columns,
    List<GridSummaryConfig> summaries,
    bool showInHeader,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: DocumentMasterDetailGrid.headerColor,
        border: Border(
          bottom: BorderSide(color: DocumentMasterDetailGrid.rowBorderColor),
        ),
      ),
      child: Row(
        children: [
          if (widget.definition.hasNestedGrids) _expandHeaderCell(),
          ...columns.map((col) {
            final summary = showInHeader
                ? summaryForColumn(col, summaries)
                : null;
            return Expanded(
              flex: col.width != null ? 0 : 1,
              child: SizedBox(
                width: col.width,
                child: summary != null
                    ? GridColumnHeaderLabel(
                        column: col,
                        summary: summary,
                        data: widget.data,
                        documentMode: true,
                      )
                    : _headerCell(col.title, col.alignment),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _expandHeaderCell() {
    return const SizedBox(width: 36);
  }

  Widget _headerCell(String title, ColumnAlignment alignment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: alignment.toAlignment(),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: DocumentMasterDetailGrid.headerTextColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDataRow(
    int index,
    List<GridColumnDefinition> columns,
    GridDefinition def,
  ) {
    final row = widget.data[index];
    final isExpanded = _expandedRows.contains(index);
    final hasNested = def.hasNestedGrids;

    return Column(
      children: [
        InkWell(
          onTap: hasNested ? () => _toggleRow(index) : null,
          child: Container(
            decoration: BoxDecoration(
              color: index.isOdd ? const Color(0xFFFAFAFA) : Colors.white,
              border: const Border(
                bottom: BorderSide(color: DocumentMasterDetailGrid.rowBorderColor),
              ),
            ),
            child: Row(
              children: [
                if (hasNested) _expandCell(isExpanded),
                ...columns.map((col) {
                  final value = row[col.field];
                  final style = _cellStyle(col.field, value, row);
                  return Expanded(
                    flex: col.width != null ? 0 : 1,
                    child: SizedBox(
                      width: col.width,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                        alignment: col.alignment.toAlignment(),
                        child: Text(
                          _formatValue(value, col),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: style?.textColor != null
                                ? Color(style!.textColor!)
                                : const Color(0xFF424242),
                            fontWeight: style?.bold == true
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        if (isExpanded && hasNested)
          Container(
            color: DocumentMasterDetailGrid.detailBackground,
            padding: const EdgeInsets.fromLTRB(36, 8, 8, 12),
            child: NestedGridRenderer(
              nestedDefinitions: def.nestedGrids!,
              parentRow: row,
              repository: widget.repository,
              documentMode: true,
            ),
          ),
      ],
    );
  }

  Widget _expandCell(bool isExpanded) {
    return SizedBox(
      width: 36,
      child: Icon(
        isExpanded ? Icons.remove : Icons.add,
        size: 16,
        color: DocumentMasterDetailGrid.headerColor,
      ),
    );
  }

  Widget _buildSummaryRow(
    List<GridColumnDefinition> columns,
    List<GridSummaryConfig> summaries,
  ) {
    final summaryByField = {
      for (final s in summaries) s.field: s,
    };
    final rowLabel = GridSummaryUtils.labelForSummaryRow(summaries);
    final labelColumnIndex = columns.indexWhere(
      (c) => !summaryByField.containsKey(c.field),
    );

    return Container(
      decoration: const BoxDecoration(
        color: DocumentMasterDetailGrid.summaryBackground,
        border: Border(
          top: BorderSide(color: DocumentMasterDetailGrid.rowBorderColor, width: 2),
        ),
      ),
      child: Row(
        children: [
          if (widget.definition.hasNestedGrids) const SizedBox(width: 36),
          ...columns.asMap().entries.map((entry) {
            final col = entry.value;
            final summary = summaryByField[col.field];
            String text = '';

            if (entry.key == labelColumnIndex) {
              text = rowLabel;
            } else if (summary != null) {
              final value = GridSummaryUtils.compute(summary, widget.data);
              text = GridSummaryUtils.format(value, col, config: summary);
            }

            return Expanded(
              flex: col.width != null ? 0 : 1,
              child: SizedBox(
                width: col.width,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  alignment: col.alignment.toAlignment(),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _toggleRow(int index) {
    setState(() {
      if (_expandedRows.contains(index)) {
        _expandedRows.remove(index);
      } else {
        _expandedRows.add(index);
      }
    });
  }

  GridCellStyle? _cellStyle(String field, dynamic value, Map<String, dynamic> row) {
    final formats = widget.definition.conditionalFormats;
    if (formats == null) return null;
    for (final format in formats) {
      if (format.field != field) continue;
      if (_evaluateCondition(format, value)) return format.style;
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
      default:
        return false;
    }
  }

  String _formatValue(dynamic value, GridColumnDefinition colDef) {
    if (value == null) return '';
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
    if (colDef.columnType == ColumnType.date) {
      if (value is String) {
        try {
          return DateFormat('M/d/yyyy').format(DateTime.parse(value));
        } catch (_) {
          return value;
        }
      }
      if (value is DateTime) {
        return DateFormat('M/d/yyyy').format(value);
      }
    }
    return value.toString();
  }
}
