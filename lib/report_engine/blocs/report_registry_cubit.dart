import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/report_definition.dart';

class ReportRegistryCubit extends Cubit<Map<String, ReportDefinition>> {
  ReportRegistryCubit() : super(const {});

  void registerAll(List<ReportDefinition> reports) {
    final map = {for (final r in reports) r.id: r};
    emit({...state, ...map});
  }

  void register(ReportDefinition report) {
    emit({...state, report.id: report});
  }

  void unregister(String reportId) {
    final copy = Map<String, ReportDefinition>.from(state);
    copy.remove(reportId);
    emit(copy);
  }

  ReportDefinition? getReport(String id) => state[id];

  List<ReportDefinition> get allReports => state.values.toList();

  List<String> get categories =>
      state.values.map((r) => r.category).toSet().toList()..sort();

  List<ReportDefinition> byCategory(String category) =>
      state.values.where((r) => r.category == category).toList();
}
