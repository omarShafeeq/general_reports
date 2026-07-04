import 'package:equatable/equatable.dart';

import '../models/models.dart';

class PivotReportState extends Equatable {
  final PivotReportStatus status;
  final List<PivotDataSource> dataSources;
  final PivotDataSource? selectedDataSource;
  final List<PivotField> availableFields;
  final List<PivotField> rowFields;
  final List<PivotField> columnFields;
  final List<PivotValue> valueFields;
  final List<PivotFilter> filters;
  final PivotResult? result;
  final PivotChartType chartType;
  final bool showChart;
  final List<PivotReport> savedReports;
  final PivotReport? currentReport;
  final String? errorMessage;
  final Set<String> expandedRowKeys;

  const PivotReportState({
    this.status = PivotReportStatus.initial,
    this.dataSources = const [],
    this.selectedDataSource,
    this.availableFields = const [],
    this.rowFields = const [],
    this.columnFields = const [],
    this.valueFields = const [],
    this.filters = const [],
    this.result,
    this.chartType = PivotChartType.bar,
    this.showChart = false,
    this.savedReports = const [],
    this.currentReport,
    this.errorMessage,
    this.expandedRowKeys = const {},
  });

  bool get isLoading =>
      status == PivotReportStatus.executing ||
      status == PivotReportStatus.loadingFields ||
      status == PivotReportStatus.loadingDataSources;

  bool get hasResult => result != null && !result!.isEmpty;

  bool get canExecute => rowFields.isNotEmpty && valueFields.isNotEmpty;

  PivotLayout get currentLayout => PivotLayout(
        dataSourceId: selectedDataSource?.id ?? '',
        rows: rowFields,
        columns: columnFields,
        values: valueFields,
        filters: filters,
      );

  PivotReportState copyWith({
    PivotReportStatus? status,
    List<PivotDataSource>? dataSources,
    PivotDataSource? selectedDataSource,
    List<PivotField>? availableFields,
    List<PivotField>? rowFields,
    List<PivotField>? columnFields,
    List<PivotValue>? valueFields,
    List<PivotFilter>? filters,
    PivotResult? result,
    PivotChartType? chartType,
    bool? showChart,
    List<PivotReport>? savedReports,
    PivotReport? currentReport,
    String? errorMessage,
    Set<String>? expandedRowKeys,
    bool clearResult = false,
    bool clearCurrentReport = false,
    bool clearError = false,
    bool clearDataSource = false,
  }) {
    return PivotReportState(
      status: status ?? this.status,
      dataSources: dataSources ?? this.dataSources,
      selectedDataSource: clearDataSource ? null : (selectedDataSource ?? this.selectedDataSource),
      availableFields: availableFields ?? this.availableFields,
      rowFields: rowFields ?? this.rowFields,
      columnFields: columnFields ?? this.columnFields,
      valueFields: valueFields ?? this.valueFields,
      filters: filters ?? this.filters,
      result: clearResult ? null : (result ?? this.result),
      chartType: chartType ?? this.chartType,
      showChart: showChart ?? this.showChart,
      savedReports: savedReports ?? this.savedReports,
      currentReport: clearCurrentReport ? null : (currentReport ?? this.currentReport),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      expandedRowKeys: expandedRowKeys ?? this.expandedRowKeys,
    );
  }

  @override
  List<Object?> get props => [
        status, dataSources, selectedDataSource, availableFields,
        rowFields, columnFields, valueFields, filters, result,
        chartType, showChart, savedReports, currentReport,
        errorMessage, expandedRowKeys,
      ];
}
