import 'package:equatable/equatable.dart';

import 'enums.dart';
import 'pivot_layout.dart';

class PivotReport extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final PivotLayout layout;
  final PivotChartType? chartType;
  final bool showChart;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final bool isShared;

  const PivotReport({
    this.id,
    required this.name,
    this.description,
    required this.layout,
    this.chartType,
    this.showChart = false,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.isShared = false,
  });

  PivotReport copyWith({
    String? id,
    String? name,
    String? description,
    PivotLayout? layout,
    PivotChartType? chartType,
    bool? showChart,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isShared,
  }) {
    return PivotReport(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      layout: layout ?? this.layout,
      chartType: chartType ?? this.chartType,
      showChart: showChart ?? this.showChart,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      isShared: isShared ?? this.isShared,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        if (description != null) 'description': description,
        'layout': layout.toJson(),
        'chartType': chartType?.name,
        'showChart': showChart,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'createdBy': createdBy,
        'isShared': isShared,
      };

  factory PivotReport.fromJson(Map<String, dynamic> json) => PivotReport(
        id: json['id'] as String?,
        name: json['name'] as String,
        description: json['description'] as String?,
        layout: PivotLayout.fromJson(json['layout'] as Map<String, dynamic>),
        chartType: json['chartType'] != null
            ? PivotChartType.values.byName(json['chartType'] as String)
            : null,
        showChart: json['showChart'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        createdBy: json['createdBy'] as String?,
        isShared: json['isShared'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        id, name, description, layout, chartType,
        showChart, createdAt, updatedAt, createdBy, isShared,
      ];
}
