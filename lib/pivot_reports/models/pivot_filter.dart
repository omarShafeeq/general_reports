import 'package:equatable/equatable.dart';

class PivotFilter extends Equatable {
  final String fieldName;
  final String operator;
  final dynamic value;
  final List<dynamic>? values;

  const PivotFilter({
    required this.fieldName,
    this.operator = 'equals',
    this.value,
    this.values,
  });

  PivotFilter copyWith({
    String? fieldName,
    String? operator,
    dynamic value,
    List<dynamic>? values,
  }) {
    return PivotFilter(
      fieldName: fieldName ?? this.fieldName,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toJson() => {
        'fieldName': fieldName,
        'operator': operator,
        'value': value,
        if (values != null) 'values': values,
      };

  factory PivotFilter.fromJson(Map<String, dynamic> json) => PivotFilter(
        fieldName: json['fieldName'] as String,
        operator: json['operator'] as String? ?? 'equals',
        value: json['value'],
        values: json['values'] as List<dynamic>?,
      );

  @override
  List<Object?> get props => [fieldName, operator, value, values];
}
