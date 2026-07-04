import 'package:flutter_bloc/flutter_bloc.dart';

import '../report_registry_cubit.dart';
import 'report_viewer_event.dart';
import 'report_viewer_state.dart';

class ReportViewerBloc extends Bloc<ReportViewerEvent, ReportViewerState> {
  final ReportRegistryCubit _registry;

  ReportViewerBloc({required ReportRegistryCubit registry})
      : _registry = registry,
        super(const ReportViewerState()) {
    on<LoadReport>(_onLoadReport);
    on<RefreshReport>(_onRefresh);
  }

  void _onLoadReport(LoadReport event, Emitter<ReportViewerState> emit) {
    emit(state.copyWith(status: ReportViewerStatus.loading));

    final report = _registry.getReport(event.reportId);
    if (report == null) {
      emit(state.copyWith(
        status: ReportViewerStatus.error,
        errorMessage: 'Report "${event.reportId}" not found in registry.',
      ));
      return;
    }

    emit(state.copyWith(
      status: ReportViewerStatus.loaded,
      report: report,
    ));
  }

  void _onRefresh(RefreshReport event, Emitter<ReportViewerState> emit) {
    final report = state.report;
    if (report != null) {
      emit(state.copyWith(status: ReportViewerStatus.loading));
      emit(state.copyWith(status: ReportViewerStatus.loaded, report: report));
    }
  }
}
