import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';

class PivotGrid extends StatelessWidget {
  final PivotResult result;
  final Set<String> expandedRowKeys;
  final ValueChanged<String> onToggleExpand;

  const PivotGrid({
    super.key,
    required this.result,
    this.expandedRowKeys = const {},
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return _buildEmptyState(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return _PivotGridTable(
          result: result,
          expandedRowKeys: expandedRowKeys,
          onToggleExpand: onToggleExpand,
          viewportWidth: constraints.maxWidth,
          viewportHeight: constraints.maxHeight,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pivot_table_chart,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'No results to display',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Configure your pivot layout and click Execute',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PivotGridTable extends StatelessWidget {
  final PivotResult result;
  final Set<String> expandedRowKeys;
  final ValueChanged<String> onToggleExpand;
  final double viewportWidth;
  final double viewportHeight;

  const _PivotGridTable({
    required this.result,
    required this.expandedRowKeys,
    required this.onToggleExpand,
    required this.viewportWidth,
    required this.viewportHeight,
  });

  static final _numberFormat = NumberFormat('#,##0.##');

  List<String> get _allColumns => [
        ...result.rowHeaders,
        ...result.columnHeaders,
      ];

  int get _rowHeaderCount => result.rowHeaders.length;

  double _columnWidth(int index, int totalColumns) {
    if (totalColumns <= 3) return 200;
    if (totalColumns <= 6) return 160;
    return 140;
  }

  double get _tableWidth {
    final columns = _allColumns;
    var width = 0.0;
    for (var i = 0; i < columns.length; i++) {
      width += _columnWidth(i, columns.length);
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final columns = _allColumns;
    final tableWidth = _tableWidth.isFinite && _tableWidth > 0
        ? _tableWidth
        : viewportWidth;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Scrollbar(
              thumbVisibility: true,
              notificationPredicate: (notification) =>
                  notification.depth == 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderRow(theme, columns),
                      ..._buildBodyRows(context, theme, columns),
                      _buildGrandTotalRow(theme, columns),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBodyRows(
    BuildContext context,
    ThemeData theme,
    List<String> columns,
  ) {
    final widgets = <Widget>[];
    for (final row in result.rows) {
      widgets.addAll(
        _buildDataRows(context, theme, row, columns, 0),
      );
    }
    return widgets;
  }

  Widget _buildHeaderRow(ThemeData theme, List<String> columns) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant, width: 2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: columns.asMap().entries.map((entry) {
          return _buildCell(
            theme,
            text: entry.value,
            isHeader: true,
            width: _columnWidth(entry.key, columns.length),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildDataRows(
    BuildContext context,
    ThemeData theme,
    PivotResultRow row,
    List<String> columns,
    int depth,
  ) {
    final isExpanded = expandedRowKeys.contains(row.displayKey);
    final hasChildren = row.children != null && row.children!.isNotEmpty;
    final widgets = <Widget>[
      _buildRowWidget(
        theme,
        row,
        columns,
        depth,
        hasChildren,
        isExpanded,
      ),
    ];

    if (hasChildren && isExpanded) {
      for (final child in row.children!) {
        widgets.addAll(
          _buildDataRows(context, theme, child, columns, depth + 1),
        );
      }
      if (row.subTotals != null) {
        widgets.add(_buildSubTotalRow(theme, row, columns, depth));
      }
    }

    return widgets;
  }

  Widget _buildRowWidget(
    ThemeData theme,
    PivotResultRow row,
    List<String> columns,
    int depth,
    bool hasChildren,
    bool isExpanded,
  ) {
    return InkWell(
      onTap: hasChildren ? () => onToggleExpand(row.displayKey) : null,
      child: Container(
        decoration: BoxDecoration(
          color: depth > 0
              ? theme.colorScheme.surfaceContainerLowest
              : null,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withAlpha(100),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: columns.asMap().entries.map((entry) {
            final colIndex = entry.key;
            final colName = entry.value;

            if (colIndex < _rowHeaderCount) {
              final keyValue = row.keys[result.rowHeaders[colIndex]] ??
                  (colIndex == 0 ? row.displayKey : '');
              return _buildCell(
                theme,
                text: keyValue.toString(),
                width: _columnWidth(colIndex, columns.length),
                depth: colIndex == 0 ? depth : 0,
                hasChildren: colIndex == 0 && hasChildren,
                isExpanded: isExpanded,
              );
            }

            final value = row.values[colName];
            return _buildCell(
              theme,
              text: value != null ? _numberFormat.format(value) : '-',
              isNumeric: true,
              width: _columnWidth(colIndex, columns.length),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSubTotalRow(
    ThemeData theme,
    PivotResultRow parentRow,
    List<String> columns,
    int depth,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withAlpha(60),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: columns.asMap().entries.map((entry) {
          final colIndex = entry.key;
          final colName = entry.value;

          if (colIndex < _rowHeaderCount) {
            return _buildCell(
              theme,
              text: colIndex == 0 ? 'Subtotal' : '',
              isBold: true,
              width: _columnWidth(colIndex, columns.length),
              depth: depth,
            );
          }

          final value = parentRow.subTotals?[colName];
          return _buildCell(
            theme,
            text: value != null ? _numberFormat.format(value) : '-',
            isNumeric: true,
            isBold: true,
            width: _columnWidth(colIndex, columns.length),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGrandTotalRow(ThemeData theme, List<String> columns) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(80),
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: columns.asMap().entries.map((entry) {
          final colIndex = entry.key;
          final colName = entry.value;

          if (colIndex < _rowHeaderCount) {
            return _buildCell(
              theme,
              text: colIndex == 0 ? 'Grand Total' : '',
              isBold: true,
              isHeader: true,
              width: _columnWidth(colIndex, columns.length),
            );
          }

          final value = result.grandTotals[colName];
          return _buildCell(
            theme,
            text: value != null ? _numberFormat.format(value) : '-',
            isNumeric: true,
            isBold: true,
            isHeader: true,
            width: _columnWidth(colIndex, columns.length),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCell(
    ThemeData theme, {
    required String text,
    bool isHeader = false,
    bool isNumeric = false,
    bool isBold = false,
    required double width,
    int depth = 0,
    bool hasChildren = false,
    bool isExpanded = false,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSizes.sm + (depth * 20),
          right: AppSizes.sm,
          top: AppSizes.sm,
          bottom: AppSizes.sm,
        ),
        child: Row(
          children: [
            if (hasChildren)
              Padding(
                padding: const EdgeInsets.only(right: AppSizes.xs),
                child: Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            Expanded(
              child: Text(
                text,
                textAlign: isNumeric ? TextAlign.right : TextAlign.left,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: (isHeader || isBold) ? FontWeight.w600 : null,
                  color: isHeader ? theme.colorScheme.onPrimaryContainer : null,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
