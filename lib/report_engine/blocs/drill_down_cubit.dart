import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/drill_down_definition.dart';

class DrillDownCubit extends Cubit<List<DrillDownLevel>> {
  DrillDownCubit() : super(const []);

  void push(DrillDownLevel level) {
    emit([...state, level]);
  }

  void popTo(int index) {
    if (index < 0 || index >= state.length) return;
    emit(state.sublist(0, index + 1));
  }

  void popLast() {
    if (state.isEmpty) return;
    emit(state.sublist(0, state.length - 1));
  }

  void reset() {
    emit(const []);
  }

  DrillDownLevel? get current => state.isEmpty ? null : state.last;

  String? get currentReportId => current?.reportId;
}
