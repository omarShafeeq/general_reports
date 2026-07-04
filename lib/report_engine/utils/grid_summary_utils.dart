import 'package:intl/intl.dart';

import '../models/enums.dart';
import '../models/grid_definition.dart';

/// Computes and formats grid summary values from row data.
abstract final class GridSummaryUtils {
  static dynamic compute(
    GridSummaryConfig config,
    List<Map<String, dynamic>> rows,
  ) {
    final values = rows
        .map((r) => r[config.field])
        .where((v) => v != null)
        .toList();

    if (values.isEmpty) return null;

    switch (config.type) {
      case 'sum':
        return values.whereType<num>().fold<num>(0, (a, b) => a + b);
      case 'avg':
        final nums = values.whereType<num>().toList();
        if (nums.isEmpty) return null;
        return nums.fold<num>(0, (a, b) => a + b) / nums.length;
      case 'count':
        return values.length;
      case 'min':
        final nums = values.whereType<num>().toList();
        return nums.isEmpty ? null : nums.reduce((a, b) => a < b ? a : b);
      case 'max':
        final nums = values.whereType<num>().toList();
        return nums.isEmpty ? null : nums.reduce((a, b) => a > b ? a : b);
      default:
        return values.whereType<num>().fold<num>(0, (a, b) => a + b);
    }
  }

  static String format(
    dynamic value,
    GridColumnDefinition? column, {
    GridSummaryConfig? config,
  }) {
    if (value == null) return '';
    if (column != null) {
      if (column.formatString != null && value is num) {
        try {
          return NumberFormat(column.formatString).format(value);
        } catch (_) {
          return value.toString();
        }
      }
      if (column.columnType == ColumnType.numeric && value is num) {
        return NumberFormat('#,##0.##').format(value);
      }
    }
    if (value is num) {
      return NumberFormat('#,##0.##').format(value);
    }
    return value.toString();
  }

  static String labelForSummaryRow(List<GridSummaryConfig> summaries) {
    final titled = summaries.where((s) => s.title != null && s.title!.isNotEmpty);
    if (titled.isNotEmpty) return titled.first.title!;
    return 'Total';
  }
}
