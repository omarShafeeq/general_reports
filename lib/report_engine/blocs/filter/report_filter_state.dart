import 'package:equatable/equatable.dart';

import '../../models/filter_definition.dart';

class ReportFilterState extends Equatable {
  final List<FilterDefinition> definitions;
  final Map<String, dynamic> values;
  final Map<String, List<FilterOption>> options;
  final Set<String> loadingOptions;

  const ReportFilterState({
    this.definitions = const [],
    this.values = const {},
    this.options = const {},
    this.loadingOptions = const {},
  });

  ReportFilterState copyWith({
    List<FilterDefinition>? definitions,
    Map<String, dynamic>? values,
    Map<String, List<FilterOption>>? options,
    Set<String>? loadingOptions,
  }) {
    return ReportFilterState(
      definitions: definitions ?? this.definitions,
      values: values ?? this.values,
      options: options ?? this.options,
      loadingOptions: loadingOptions ?? this.loadingOptions,
    );
  }

  dynamic getValue(String filterId) => values[filterId];

  List<FilterOption> getOptions(String filterId) => options[filterId] ?? [];

  bool isLoading(String filterId) => loadingOptions.contains(filterId);

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    for (final entry in values.entries) {
      if (entry.value != null) {
        params[entry.key] = entry.value;
      }
    }
    return params;
  }

  @override
  List<Object?> get props => [definitions, values, options, loadingOptions];
}
