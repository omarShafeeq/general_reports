import 'package:equatable/equatable.dart';

import 'enums.dart';

class PivotValue extends Equatable {
  final String field;
  final PivotAggregation aggregation;
  final String? customLabel;
  final String? format;

  const PivotValue({
    required this.field,
    this.aggregation = PivotAggregation.sum,
    this.customLabel,
    this.format,
  });

  String get displayLabel => customLabel ?? '${aggregation.label} of $field';

  PivotValue copyWith({
    String? field,
    PivotAggregation? aggregation,
    String? customLabel,
    String? format,
  }) {
    return PivotValue(
      field: field ?? this.field,
      aggregation: aggregation ?? this.aggregation,
      customLabel: customLabel ?? this.customLabel,
      format: format ?? this.format,
    );
  }

  Map<String, dynamic> toJson() => {
        'field': field,
        'aggregation': aggregation.name,
        if (customLabel != null) 'customLabel': customLabel,
        if (format != null) 'format': format,
      };

  factory PivotValue.fromJson(Map<String, dynamic> json) => PivotValue(
        field: json['field'] as String,
        aggregation: PivotAggregation.values.byName(json['aggregation'] as String? ?? 'sum'),
        customLabel: json['customLabel'] as String?,
        format: json['format'] as String?,
      );

  @override
  List<Object?> get props => [field, aggregation, customLabel, format];
}
