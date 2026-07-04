import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_reports/blocs/filter/filter_event.dart';
import 'package:general_reports/blocs/filter/filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState()) {
    on<FilterDateRangeChanged>(_onDateRangeChanged);
    on<FilterRegionChanged>(_onRegionChanged);
    on<FilterDepartmentChanged>(_onDepartmentChanged);
    on<FilterCategoryChanged>(_onCategoryChanged);
    on<FilterStatusChanged>(_onStatusChanged);
    on<FilterReset>(_onReset);
  }

  void _onDateRangeChanged(FilterDateRangeChanged event, Emitter<FilterState> emit) {
    emit(state.copyWith(startDate: event.startDate, endDate: event.endDate));
  }

  void _onRegionChanged(FilterRegionChanged event, Emitter<FilterState> emit) {
    emit(state.copyWith(region: event.region));
  }

  void _onDepartmentChanged(FilterDepartmentChanged event, Emitter<FilterState> emit) {
    emit(state.copyWith(department: event.department));
  }

  void _onCategoryChanged(FilterCategoryChanged event, Emitter<FilterState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _onStatusChanged(FilterStatusChanged event, Emitter<FilterState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onReset(FilterReset event, Emitter<FilterState> emit) {
    emit(FilterState());
  }
}
