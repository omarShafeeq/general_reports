import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
  @override
  List<Object?> get props => [];
}

class FilterDateRangeChanged extends FilterEvent {
  final DateTime startDate;
  final DateTime endDate;
  const FilterDateRangeChanged({required this.startDate, required this.endDate});
  @override
  List<Object?> get props => [startDate, endDate];
}

class FilterRegionChanged extends FilterEvent {
  final String region;
  const FilterRegionChanged(this.region);
  @override
  List<Object?> get props => [region];
}

class FilterDepartmentChanged extends FilterEvent {
  final String department;
  const FilterDepartmentChanged(this.department);
  @override
  List<Object?> get props => [department];
}

class FilterCategoryChanged extends FilterEvent {
  final String category;
  const FilterCategoryChanged(this.category);
  @override
  List<Object?> get props => [category];
}

class FilterStatusChanged extends FilterEvent {
  final String status;
  const FilterStatusChanged(this.status);
  @override
  List<Object?> get props => [status];
}

class FilterReset extends FilterEvent {
  const FilterReset();
}
