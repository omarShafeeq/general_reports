import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdfViewerState extends Equatable {
  final double zoomLevel;
  final int currentPage;
  final int totalPages;
  final String searchQuery;
  final bool isSearchVisible;

  const PdfViewerState({
    this.zoomLevel = 1.0,
    this.currentPage = 1,
    this.totalPages = 1,
    this.searchQuery = '',
    this.isSearchVisible = false,
  });

  PdfViewerState copyWith({
    double? zoomLevel,
    int? currentPage,
    int? totalPages,
    String? searchQuery,
    bool? isSearchVisible,
  }) {
    return PdfViewerState(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
    );
  }

  @override
  List<Object?> get props => [
        zoomLevel, currentPage, totalPages, searchQuery, isSearchVisible,
      ];
}

class PdfViewerCubit extends Cubit<PdfViewerState> {
  PdfViewerCubit() : super(const PdfViewerState());

  void setPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  void setTotalPages(int total) {
    emit(state.copyWith(totalPages: total));
  }

  void setZoom(double zoom) {
    emit(state.copyWith(zoomLevel: zoom.clamp(0.5, 5.0)));
  }

  void zoomIn() => setZoom(state.zoomLevel + 0.25);
  void zoomOut() => setZoom(state.zoomLevel - 0.25);

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
