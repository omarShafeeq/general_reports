import 'package:equatable/equatable.dart';

abstract class ReportViewerEvent extends Equatable {
  const ReportViewerEvent();

  @override
  List<Object?> get props => [];
}

class LoadReport extends ReportViewerEvent {
  final String reportId;
  final Map<String, dynamic> initialParams;

  const LoadReport({
    required this.reportId,
    this.initialParams = const {},
  });

  @override
  List<Object?> get props => [reportId, initialParams];
}

class RefreshReport extends ReportViewerEvent {
  const RefreshReport();
}
