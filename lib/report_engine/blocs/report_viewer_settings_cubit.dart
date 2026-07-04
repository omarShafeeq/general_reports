import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/enums.dart';

class ReportViewerSettingsState extends Equatable {
  final double zoomLevel;
  final FitMode fitMode;
  final int currentPage;
  final int totalPages;
  final String searchQuery;
  final bool isFullscreen;
  final bool isSearchVisible;

  const ReportViewerSettingsState({
    this.zoomLevel = 1.0,
    this.fitMode = FitMode.none,
    this.currentPage = 1,
    this.totalPages = 1,
    this.searchQuery = '',
    this.isFullscreen = false,
    this.isSearchVisible = false,
  });

  bool get canZoomIn => zoomLevel < 4.0;
  bool get canZoomOut => zoomLevel > 0.25;
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
  String get zoomPercentage => '${(zoomLevel * 100).round()}%';

  ReportViewerSettingsState copyWith({
    double? zoomLevel,
    FitMode? fitMode,
    int? currentPage,
    int? totalPages,
    String? searchQuery,
    bool? isFullscreen,
    bool? isSearchVisible,
  }) {
    return ReportViewerSettingsState(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      fitMode: fitMode ?? this.fitMode,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      searchQuery: searchQuery ?? this.searchQuery,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
    );
  }

  @override
  List<Object?> get props => [
        zoomLevel, fitMode, currentPage, totalPages,
        searchQuery, isFullscreen, isSearchVisible,
      ];
}

class ReportViewerSettingsCubit extends Cubit<ReportViewerSettingsState> {
  final double minZoom;
  final double maxZoom;
  final double zoomStep;

  ReportViewerSettingsCubit({
    this.minZoom = 0.25,
    this.maxZoom = 4.0,
    this.zoomStep = 0.25,
    double defaultZoom = 1.0,
  }) : super(ReportViewerSettingsState(zoomLevel: defaultZoom));

  void zoomIn() {
    final newZoom = (state.zoomLevel + zoomStep).clamp(minZoom, maxZoom);
    emit(state.copyWith(zoomLevel: newZoom, fitMode: FitMode.none));
  }

  void zoomOut() {
    final newZoom = (state.zoomLevel - zoomStep).clamp(minZoom, maxZoom);
    emit(state.copyWith(zoomLevel: newZoom, fitMode: FitMode.none));
  }

  void setZoom(double zoom) {
    emit(state.copyWith(
      zoomLevel: zoom.clamp(minZoom, maxZoom),
      fitMode: FitMode.none,
    ));
  }

  void fitWidth() {
    emit(state.copyWith(fitMode: FitMode.fitWidth));
  }

  void fitPage() {
    emit(state.copyWith(fitMode: FitMode.fitPage));
  }

  void setPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  void nextPage() => setPage(state.currentPage + 1);
  void previousPage() => setPage(state.currentPage - 1);
  void firstPage() => setPage(1);
  void lastPage() => setPage(state.totalPages);

  void setTotalPages(int total) {
    emit(state.copyWith(totalPages: total));
  }

  void toggleFullscreen() {
    emit(state.copyWith(isFullscreen: !state.isFullscreen));
  }

  void toggleSearch() {
    emit(state.copyWith(
      isSearchVisible: !state.isSearchVisible,
      searchQuery: state.isSearchVisible ? '' : state.searchQuery,
    ));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
