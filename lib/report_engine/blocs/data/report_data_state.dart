import 'package:equatable/equatable.dart';

enum ReportDataStatus { initial, loading, loaded, error }

class ReportDataState extends Equatable {
  final ReportDataStatus status;
  final Map<String, dynamic> data;
  final String? errorMessage;

  const ReportDataState({
    this.status = ReportDataStatus.initial,
    this.data = const {},
    this.errorMessage,
  });

  ReportDataState copyWith({
    ReportDataStatus? status,
    Map<String, dynamic>? data,
    String? errorMessage,
  }) {
    return ReportDataState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<Map<String, dynamic>> getList(String key) {
    final value = data[key];
    if (value is List) {
      return value.cast<Map<String, dynamic>>();
    }
    return [];
  }

  dynamic getValue(String key) => data[key];

  @override
  List<Object?> get props => [status, data, errorMessage];
}
