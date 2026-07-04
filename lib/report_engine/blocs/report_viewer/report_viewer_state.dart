import 'package:equatable/equatable.dart';

import '../../models/report_definition.dart';

enum ReportViewerStatus { initial, loading, loaded, error }

class ReportViewerState extends Equatable {
  final ReportViewerStatus status;
  final ReportDefinition? report;
  final String? errorMessage;

  const ReportViewerState({
    this.status = ReportViewerStatus.initial,
    this.report,
    this.errorMessage,
  });

  ReportViewerState copyWith({
    ReportViewerStatus? status,
    ReportDefinition? report,
    String? errorMessage,
  }) {
    return ReportViewerState(
      status: status ?? this.status,
      report: report ?? this.report,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, report, errorMessage];
}
