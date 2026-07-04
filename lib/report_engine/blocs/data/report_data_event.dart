import 'package:equatable/equatable.dart';

abstract class ReportDataEvent extends Equatable {
  const ReportDataEvent();

  @override
  List<Object?> get props => [];
}

class FetchReportData extends ReportDataEvent {
  final String datasource;
  final Map<String, dynamic> params;

  const FetchReportData({
    required this.datasource,
    this.params = const {},
  });

  @override
  List<Object?> get props => [datasource, params];
}
