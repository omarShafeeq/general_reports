import 'package:equatable/equatable.dart';

import '../../models/filter_definition.dart';

abstract class ReportFilterEvent extends Equatable {
  const ReportFilterEvent();

  @override
  List<Object?> get props => [];
}

class InitializeFilters extends ReportFilterEvent {
  final List<FilterDefinition> definitions;

  const InitializeFilters(this.definitions);

  @override
  List<Object?> get props => [definitions];
}

class FilterValueChanged extends ReportFilterEvent {
  final String filterId;
  final dynamic value;

  const FilterValueChanged({required this.filterId, required this.value});

  @override
  List<Object?> get props => [filterId, value];
}

class FilterOptionsLoaded extends ReportFilterEvent {
  final String filterId;
  final List<FilterOption> options;

  const FilterOptionsLoaded({required this.filterId, required this.options});

  @override
  List<Object?> get props => [filterId, options];
}

class ResetFilters extends ReportFilterEvent {
  const ResetFilters();
}
