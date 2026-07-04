import 'package:equatable/equatable.dart';

import '../config/inline_report_configs.dart';

/// Result of a successful report detection.
class ReportMatch extends Equatable {
  final String reportId;
  final String functionName;
  final Map<String, dynamic> params;

  const ReportMatch({
    required this.reportId,
    required this.functionName,
    this.params = const {},
  });

  @override
  List<Object?> get props => [reportId, functionName, params];
}

/// Maps user queries to report configs and function registry calls.
///
/// Uses keyword matching for the mock provider path. Real AI providers would
/// use native function/tool calling instead.
class ReportDetector {
  static const _patterns = <String, _ReportPattern>{
    'sales-overview': _ReportPattern(
      keywords: ['sales', 'revenue', 'orders', 'monthly sales', 'sales overview'],
      functionName: 'getSales',
    ),
    'finance-summary': _ReportPattern(
      keywords: ['finance', 'profit', 'expense', 'p&l', 'financial', 'margin', 'cash flow'],
      functionName: 'getFinanceSummary',
    ),
    'inventory-status': _ReportPattern(
      keywords: ['inventory', 'stock', 'warehouse', 'reorder', 'low stock'],
      functionName: 'getInventory',
    ),
    'sales-by-customer': _ReportPattern(
      keywords: ['customer', 'top customer', 'client', 'customer sales'],
      functionName: 'getCustomers',
    ),
  };

  /// Returns a [ReportMatch] if the user query matches a known report pattern,
  /// or `null` if no report should be rendered.
  ReportMatch? detect(String userQuery) {
    final lower = userQuery.toLowerCase();

    // Skip generic/help queries.
    if (lower.contains('help') || lower.contains('what can')) return null;

    for (final entry in _patterns.entries) {
      final reportId = entry.key;
      final pattern = entry.value;

      for (final keyword in pattern.keywords) {
        if (lower.contains(keyword)) {
          // Verify we have an inline config for this report.
          if (!InlineReportConfigs.all.containsKey(reportId)) continue;

          return ReportMatch(
            reportId: reportId,
            functionName: pattern.functionName,
          );
        }
      }
    }

    return null;
  }
}

class _ReportPattern {
  final List<String> keywords;
  final String functionName;

  const _ReportPattern({
    required this.keywords,
    required this.functionName,
  });
}
