import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/report_repository.dart';
import 'report_data_event.dart';
import 'report_data_state.dart';

class ReportDataBloc extends Bloc<ReportDataEvent, ReportDataState> {
  final ReportRepository _repository;

  ReportDataBloc({required ReportRepository repository})
      : _repository = repository,
        super(const ReportDataState()) {
    on<FetchReportData>(_onFetch);
  }

  Future<void> _onFetch(
    FetchReportData event,
    Emitter<ReportDataState> emit,
  ) async {
    emit(state.copyWith(status: ReportDataStatus.loading));

    try {
      final data = await _repository.fetchReportData(
        event.datasource,
        event.params,
      );

      emit(state.copyWith(
        status: ReportDataStatus.loaded,
        data: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReportDataStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
