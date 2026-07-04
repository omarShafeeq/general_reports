import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/pivot_repository.dart';
import '../models/models.dart';
import 'pivot_report_state.dart';

class PivotReportCubit extends Cubit<PivotReportState> {
  final PivotRepository _repository;

  PivotReportCubit({required PivotRepository repository})
      : _repository = repository,
        super(const PivotReportState());

  Future<void> loadDataSources() async {
    emit(state.copyWith(status: PivotReportStatus.loadingDataSources));
    try {
      final sources = await _repository.fetchDataSources();
      emit(state.copyWith(
        status: PivotReportStatus.initial,
        dataSources: sources,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PivotReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> selectDataSource(PivotDataSource source) async {
    emit(state.copyWith(
      status: PivotReportStatus.loadingFields,
      selectedDataSource: source,
      rowFields: [],
      columnFields: [],
      valueFields: [],
      filters: [],
      clearResult: true,
      clearCurrentReport: true,
    ));
    try {
      final fields = await _repository.fetchFields(source.id);
      emit(state.copyWith(
        status: PivotReportStatus.initial,
        availableFields: fields,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PivotReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void addFieldToRows(PivotField field) {
    if (state.rowFields.any((f) => f.name == field.name)) return;
    final updated = field.copyWith(role: PivotFieldRole.row);
    emit(state.copyWith(
      rowFields: [...state.rowFields, updated],
      clearResult: true,
    ));
  }

  void addFieldToColumns(PivotField field) {
    if (state.columnFields.any((f) => f.name == field.name)) return;
    final updated = field.copyWith(role: PivotFieldRole.column);
    emit(state.copyWith(
      columnFields: [...state.columnFields, updated],
      clearResult: true,
    ));
  }

  void addFieldToValues(PivotField field) {
    final aggregation = field.fieldType.isNumeric
        ? PivotAggregation.sum
        : PivotAggregation.count;
    final value = PivotValue(field: field.name, aggregation: aggregation);
    if (state.valueFields.any((v) => v.field == field.name)) return;
    emit(state.copyWith(
      valueFields: [...state.valueFields, value],
      clearResult: true,
    ));
  }

  void addFieldToFilters(PivotField field) {
    if (state.filters.any((f) => f.fieldName == field.name)) return;
    final filter = PivotFilter(fieldName: field.name);
    emit(state.copyWith(
      filters: [...state.filters, filter],
    ));
  }

  void removeFieldFromRows(PivotField field) {
    emit(state.copyWith(
      rowFields: state.rowFields.where((f) => f.name != field.name).toList(),
      clearResult: true,
    ));
  }

  void removeFieldFromColumns(PivotField field) {
    emit(state.copyWith(
      columnFields: state.columnFields.where((f) => f.name != field.name).toList(),
      clearResult: true,
    ));
  }

  void removeValueField(PivotValue value) {
    emit(state.copyWith(
      valueFields: state.valueFields.where((v) => v.field != value.field).toList(),
      clearResult: true,
    ));
  }

  void removeFilter(PivotFilter filter) {
    emit(state.copyWith(
      filters: state.filters.where((f) => f.fieldName != filter.fieldName).toList(),
    ));
  }

  void updateValueAggregation(String fieldName, PivotAggregation aggregation) {
    final updated = state.valueFields.map((v) {
      if (v.field == fieldName) return v.copyWith(aggregation: aggregation);
      return v;
    }).toList();
    emit(state.copyWith(valueFields: updated, clearResult: true));
  }

  void updateFilter(PivotFilter filter) {
    final updated = state.filters.map((f) {
      if (f.fieldName == filter.fieldName) return filter;
      return f;
    }).toList();
    emit(state.copyWith(filters: updated));
  }

  void reorderRowFields(int oldIndex, int newIndex) {
    final rows = List<PivotField>.from(state.rowFields);
    final item = rows.removeAt(oldIndex);
    rows.insert(newIndex.clamp(0, rows.length), item);
    emit(state.copyWith(rowFields: rows, clearResult: true));
  }

  void reorderColumnFields(int oldIndex, int newIndex) {
    final cols = List<PivotField>.from(state.columnFields);
    final item = cols.removeAt(oldIndex);
    cols.insert(newIndex.clamp(0, cols.length), item);
    emit(state.copyWith(columnFields: cols, clearResult: true));
  }

  void reorderValueFields(int oldIndex, int newIndex) {
    final vals = List<PivotValue>.from(state.valueFields);
    final item = vals.removeAt(oldIndex);
    vals.insert(newIndex.clamp(0, vals.length), item);
    emit(state.copyWith(valueFields: vals, clearResult: true));
  }

  void toggleRowExpansion(String rowKey) {
    final expanded = Set<String>.from(state.expandedRowKeys);
    if (expanded.contains(rowKey)) {
      expanded.remove(rowKey);
    } else {
      expanded.add(rowKey);
    }
    emit(state.copyWith(expandedRowKeys: expanded));
  }

  void setChartType(PivotChartType type) {
    emit(state.copyWith(chartType: type));
  }

  void toggleChart() {
    emit(state.copyWith(showChart: !state.showChart));
  }

  Future<void> executeReport() async {
    if (!state.canExecute) return;

    emit(state.copyWith(
      status: PivotReportStatus.executing,
      clearError: true,
    ));
    try {
      final result = await _repository.executeReport(state.currentLayout);
      final allExpanded = <String>{};
      for (final row in result.rows) {
        if (row.children != null && row.children!.isNotEmpty) {
          allExpanded.add(row.displayKey);
        }
      }
      emit(state.copyWith(
        status: PivotReportStatus.loaded,
        result: result,
        expandedRowKeys: allExpanded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PivotReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> saveCurrentReport(String name, {String? description}) async {
    emit(state.copyWith(status: PivotReportStatus.saving));
    try {
      final report = PivotReport(
        id: state.currentReport?.id,
        name: name,
        description: description,
        layout: state.currentLayout,
        chartType: state.chartType,
        showChart: state.showChart,
      );
      final saved = await _repository.saveReport(report);
      emit(state.copyWith(
        status: PivotReportStatus.loaded,
        currentReport: saved,
      ));
      await _refreshSavedReports();
    } catch (e) {
      emit(state.copyWith(
        status: PivotReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadSavedReports() async {
    try {
      final reports = await _repository.fetchSavedReports();
      emit(state.copyWith(savedReports: reports));
    } catch (_) {}
  }

  Future<void> loadSavedReport(PivotReport report) async {
    emit(state.copyWith(status: PivotReportStatus.loadingFields));
    try {
      final source = state.dataSources.firstWhere(
        (s) => s.id == report.layout.dataSourceId,
      );
      final fields = await _repository.fetchFields(source.id);
      emit(state.copyWith(
        status: PivotReportStatus.initial,
        selectedDataSource: source,
        availableFields: fields,
        rowFields: report.layout.rows,
        columnFields: report.layout.columns,
        valueFields: report.layout.values,
        filters: report.layout.filters,
        chartType: report.chartType ?? PivotChartType.bar,
        showChart: report.showChart,
        currentReport: report,
        clearResult: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PivotReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      await _repository.deleteReport(reportId);
      if (state.currentReport?.id == reportId) {
        emit(state.copyWith(clearCurrentReport: true));
      }
      await _refreshSavedReports();
    } catch (e) {
      emit(state.copyWith(
        status: PivotReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> duplicateReport(String reportId, String newName) async {
    try {
      await _repository.duplicateReport(reportId, newName);
      await _refreshSavedReports();
    } catch (e) {
      emit(state.copyWith(
        status: PivotReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearLayout() {
    emit(state.copyWith(
      rowFields: [],
      columnFields: [],
      valueFields: [],
      filters: [],
      clearResult: true,
      clearCurrentReport: true,
    ));
  }

  Future<void> _refreshSavedReports() async {
    try {
      final reports = await _repository.fetchSavedReports();
      emit(state.copyWith(savedReports: reports));
    } catch (_) {}
  }
}
