import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/report_repository.dart';
import '../../models/filter_definition.dart';
import 'report_filter_event.dart';
import 'report_filter_state.dart';

class ReportFilterBloc extends Bloc<ReportFilterEvent, ReportFilterState> {
  final ReportRepository _repository;

  ReportFilterBloc({required ReportRepository repository})
      : _repository = repository,
        super(const ReportFilterState()) {
    on<InitializeFilters>(_onInitialize);
    on<FilterValueChanged>(_onValueChanged);
    on<FilterOptionsLoaded>(_onOptionsLoaded);
    on<ResetFilters>(_onReset);
  }

  void _onInitialize(
    InitializeFilters event,
    Emitter<ReportFilterState> emit,
  ) async {
    final defaults = <String, dynamic>{};
    final options = <String, List<FilterOption>>{};

    for (final def in event.definitions) {
      if (def.defaultValue != null) {
        defaults[def.id] = def.defaultValue;
      }
      if (def.staticOptions != null) {
        options[def.id] = def.staticOptions!;
      }
    }

    emit(state.copyWith(
      definitions: event.definitions,
      values: defaults,
      options: options,
    ));

    for (final def in event.definitions) {
      if (def.staticOptions == null &&
          def.apiEndpoint != null &&
          def.dependsOn.isEmpty) {
        await _loadOptions(def, emit);
      }
    }
  }

  void _onValueChanged(
    FilterValueChanged event,
    Emitter<ReportFilterState> emit,
  ) async {
    final newValues = Map<String, dynamic>.from(state.values);
    newValues[event.filterId] = event.value;

    final childIds = _findDependents(event.filterId);
    for (final childId in childIds) {
      newValues.remove(childId);
    }

    emit(state.copyWith(
      values: newValues,
      loadingOptions: {...state.loadingOptions, ...childIds},
    ));

    for (final childId in childIds) {
      final def = state.definitions.where((d) => d.id == childId).firstOrNull;
      if (def != null && def.apiEndpoint != null) {
        await _loadOptions(def, emit, parentValues: newValues);
      }
    }
  }

  void _onOptionsLoaded(
    FilterOptionsLoaded event,
    Emitter<ReportFilterState> emit,
  ) {
    final newOptions = Map<String, List<FilterOption>>.from(state.options);
    newOptions[event.filterId] = event.options;
    final loading = Set<String>.from(state.loadingOptions);
    loading.remove(event.filterId);
    emit(state.copyWith(options: newOptions, loadingOptions: loading));
  }

  void _onReset(ResetFilters event, Emitter<ReportFilterState> emit) {
    if (state.definitions.isNotEmpty) {
      add(InitializeFilters(state.definitions));
    }
  }

  Set<String> _findDependents(String filterId) {
    final result = <String>{};
    for (final def in state.definitions) {
      if (def.dependsOn.contains(filterId)) {
        result.add(def.id);
        result.addAll(_findDependents(def.id));
      }
    }
    return result;
  }

  Future<void> _loadOptions(
    FilterDefinition def,
    Emitter<ReportFilterState> emit, {
    Map<String, dynamic>? parentValues,
  }) async {
    try {
      final params = <String, dynamic>{};
      final vals = parentValues ?? state.values;
      for (final parentId in def.dependsOn) {
        final parentVal = vals[parentId];
        if (parentVal != null) {
          params[parentId] = parentVal;
        }
      }

      final options = await _repository.fetchFilterOptions(
        def.apiEndpoint!,
        params,
      );

      add(FilterOptionsLoaded(filterId: def.id, options: options));
    } catch (_) {
      add(FilterOptionsLoaded(filterId: def.id, options: []));
    }
  }
}
