import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/enums.dart';

enum ExportStatus { idle, exporting, success, error }

class ExportState extends Equatable {
  final ExportStatus status;
  final ExportFormat? format;
  final String? errorMessage;
  final String? filePath;

  const ExportState({
    this.status = ExportStatus.idle,
    this.format,
    this.errorMessage,
    this.filePath,
  });

  ExportState copyWith({
    ExportStatus? status,
    ExportFormat? format,
    String? errorMessage,
    String? filePath,
  }) {
    return ExportState(
      status: status ?? this.status,
      format: format ?? this.format,
      errorMessage: errorMessage,
      filePath: filePath,
    );
  }

  @override
  List<Object?> get props => [status, format, errorMessage, filePath];
}

class ExportCubit extends Cubit<ExportState> {
  ExportCubit() : super(const ExportState());

  void startExport(ExportFormat format) {
    emit(ExportState(status: ExportStatus.exporting, format: format));
  }

  void exportSuccess({String? filePath}) {
    emit(state.copyWith(
      status: ExportStatus.success,
      filePath: filePath,
    ));
  }

  void exportError(String message) {
    emit(state.copyWith(
      status: ExportStatus.error,
      errorMessage: message,
    ));
  }

  void reset() {
    emit(const ExportState());
  }
}
