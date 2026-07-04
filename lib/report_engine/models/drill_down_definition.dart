import 'package:equatable/equatable.dart';

class DrillDownDefinition extends Equatable {
  final String targetReportId;
  final String paramField;
  final String paramKey;
  final String? label;

  const DrillDownDefinition({
    required this.targetReportId,
    required this.paramField,
    required this.paramKey,
    this.label,
  });

  @override
  List<Object?> get props => [targetReportId, paramField, paramKey, label];
}

class DrillDownLevel extends Equatable {
  final String reportId;
  final String paramKey;
  final dynamic paramValue;
  final String breadcrumbLabel;

  const DrillDownLevel({
    required this.reportId,
    required this.paramKey,
    required this.paramValue,
    required this.breadcrumbLabel,
  });

  @override
  List<Object?> get props => [reportId, paramKey, paramValue, breadcrumbLabel];
}
