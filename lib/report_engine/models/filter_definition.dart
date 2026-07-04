import 'package:equatable/equatable.dart';

import 'enums.dart';

class FilterDefinition extends Equatable {
  final String id;
  final String label;
  final ReportFilterType type;
  final String? apiEndpoint;
  final dynamic defaultValue;
  final bool required;
  final List<String> dependsOn;
  final Map<String, dynamic>? validation;
  final List<FilterOption>? staticOptions;

  const FilterDefinition({
    required this.id,
    required this.label,
    required this.type,
    this.apiEndpoint,
    this.defaultValue,
    this.required = false,
    this.dependsOn = const [],
    this.validation,
    this.staticOptions,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        type,
        apiEndpoint,
        defaultValue,
        required,
        dependsOn,
        validation,
        staticOptions,
      ];
}

class FilterOption extends Equatable {
  final String value;
  final String label;
  final List<FilterOption>? children;

  const FilterOption({
    required this.value,
    required this.label,
    this.children,
  });

  @override
  List<Object?> get props => [value, label, children];
}
