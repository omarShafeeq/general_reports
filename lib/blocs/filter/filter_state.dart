import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String region;
  final String department;
  final String category;
  final String status;

  FilterState({
    DateTime? startDate,
    DateTime? endDate,
    this.region = 'All',
    this.department = 'All',
    this.category = 'All',
    this.status = 'All',
  })  : startDate = startDate ?? DateTime.now().subtract(const Duration(days: 365)),
        endDate = endDate ?? DateTime.now();

  FilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? region,
    String? department,
    String? category,
    String? status,
  }) {
    return FilterState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      region: region ?? this.region,
      department: department ?? this.department,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [startDate, endDate, region, department, category, status];
}
