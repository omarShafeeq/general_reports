import 'package:equatable/equatable.dart';

class PivotResult extends Equatable {
  final List<String> rowHeaders;
  final List<String> columnHeaders;
  final List<PivotResultRow> rows;
  final Map<String, double> grandTotals;
  final int totalRecords;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PivotResult({
    this.rowHeaders = const [],
    this.columnHeaders = const [],
    this.rows = const [],
    this.grandTotals = const {},
    this.totalRecords = 0,
    this.page = 1,
    this.pageSize = 50,
    this.hasMore = false,
  });

  bool get isEmpty => rows.isEmpty;

  factory PivotResult.fromJson(Map<String, dynamic> json) {
    return PivotResult(
      rowHeaders: List<String>.from(json['rowHeaders'] ?? []),
      columnHeaders: List<String>.from(json['columnHeaders'] ?? []),
      rows: (json['rows'] as List?)
              ?.map((e) => PivotResultRow.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      grandTotals: Map<String, double>.from(json['grandTotals'] ?? {}),
      totalRecords: json['totalRecords'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 50,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'rowHeaders': rowHeaders,
        'columnHeaders': columnHeaders,
        'rows': rows.map((r) => r.toJson()).toList(),
        'grandTotals': grandTotals,
        'totalRecords': totalRecords,
        'page': page,
        'pageSize': pageSize,
        'hasMore': hasMore,
      };

  @override
  List<Object?> get props => [
        rowHeaders, columnHeaders, rows, grandTotals,
        totalRecords, page, pageSize, hasMore,
      ];
}

class PivotResultRow extends Equatable {
  final Map<String, dynamic> keys;
  final Map<String, double> values;
  final List<PivotResultRow>? children;
  final Map<String, double>? subTotals;
  final bool isExpanded;

  const PivotResultRow({
    required this.keys,
    required this.values,
    this.children,
    this.subTotals,
    this.isExpanded = true,
  });

  String get displayKey => keys.values.join(' > ');

  PivotResultRow copyWith({
    Map<String, dynamic>? keys,
    Map<String, double>? values,
    List<PivotResultRow>? children,
    Map<String, double>? subTotals,
    bool? isExpanded,
  }) {
    return PivotResultRow(
      keys: keys ?? this.keys,
      values: values ?? this.values,
      children: children ?? this.children,
      subTotals: subTotals ?? this.subTotals,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  factory PivotResultRow.fromJson(Map<String, dynamic> json) {
    return PivotResultRow(
      keys: Map<String, dynamic>.from(json['keys'] ?? {}),
      values: Map<String, double>.from(
        (json['values'] as Map?)?.map(
              (k, v) => MapEntry(k as String, (v as num).toDouble()),
            ) ??
            {},
      ),
      children: (json['children'] as List?)
          ?.map((e) => PivotResultRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      subTotals: json['subTotals'] != null
          ? Map<String, double>.from(
              (json['subTotals'] as Map).map(
                (k, v) => MapEntry(k as String, (v as num).toDouble()),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'keys': keys,
        'values': values,
        if (children != null) 'children': children!.map((c) => c.toJson()).toList(),
        if (subTotals != null) 'subTotals': subTotals,
      };

  @override
  List<Object?> get props => [keys, values, children, subTotals, isExpanded];
}
