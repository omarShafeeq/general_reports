import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/grid_definition.dart';
import '../utils/grid_summary_utils.dart';

/// Column header with optional summary value shown beneath the title.
class GridColumnHeaderLabel extends StatelessWidget {
  final GridColumnDefinition column;
  final GridSummaryConfig? summary;
  final List<Map<String, dynamic>>? data;
  final bool documentMode;

  const GridColumnHeaderLabel({
    super.key,
    required this.column,
    this.summary,
    this.data,
    this.documentMode = false,
  });

  String? get _summaryText {
    if (summary == null || data == null) return null;
    final value = GridSummaryUtils.compute(summary!, data!);
    return GridSummaryUtils.format(value, column, config: summary);
  }

  @override
  Widget build(BuildContext context) {
    final summaryText = _summaryText;
    final titleStyle = documentMode
        ? const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          )
        : const TextStyle(fontWeight: FontWeight.w600);

    final summaryStyle = documentMode
        ? const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE0F2F1),
          )
        : TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          );

    return Container(
      alignment: column.alignment.toAlignment(),
      padding: EdgeInsets.symmetric(
        horizontal: documentMode ? 10 : 8,
        vertical: documentMode ? 8 : 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: _crossAxisAlignment(column.alignment),
        children: [
          Text(
            column.title,
            style: titleStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (summaryText != null) ...[
            const SizedBox(height: 2),
            Text(
              summaryText,
              style: summaryStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ],
      ),
    );
  }

  CrossAxisAlignment _crossAxisAlignment(ColumnAlignment alignment) {
    switch (alignment) {
      case ColumnAlignment.left:
        return CrossAxisAlignment.start;
      case ColumnAlignment.center:
        return CrossAxisAlignment.center;
      case ColumnAlignment.right:
        return CrossAxisAlignment.end;
    }
  }
}

/// Resolves summary config for a column field, if any.
GridSummaryConfig? summaryForColumn(
  GridColumnDefinition column,
  List<GridSummaryConfig> summaries,
) {
  return summaries.where((s) => s.field == column.field).firstOrNull;
}
