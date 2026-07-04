import 'package:equatable/equatable.dart';

class ToolbarDefinition extends Equatable {
  final bool showPrint;
  final bool showExportPdf;
  final bool showExportExcel;
  final bool showExportCsv;
  final bool showExportImage;
  final bool showDownload;
  final bool showRefresh;
  final bool showSearch;
  final bool showZoom;
  final bool showFitWidth;
  final bool showFitPage;
  final bool showPageNavigation;
  final bool showSettings;
  final bool showFullscreen;
  final double defaultZoom;
  final double minZoom;
  final double maxZoom;
  final double zoomStep;

  const ToolbarDefinition({
    this.showPrint = true,
    this.showExportPdf = true,
    this.showExportExcel = true,
    this.showExportCsv = true,
    this.showExportImage = true,
    this.showDownload = true,
    this.showRefresh = true,
    this.showSearch = true,
    this.showZoom = true,
    this.showFitWidth = true,
    this.showFitPage = true,
    this.showPageNavigation = true,
    this.showSettings = false,
    this.showFullscreen = true,
    this.defaultZoom = 1.0,
    this.minZoom = 0.25,
    this.maxZoom = 4.0,
    this.zoomStep = 0.25,
  });

  @override
  List<Object?> get props => [
        showPrint, showExportPdf, showExportExcel, showExportCsv,
        showExportImage, showDownload, showRefresh, showSearch,
        showZoom, showFitWidth, showFitPage, showPageNavigation,
        showSettings, showFullscreen, defaultZoom, minZoom, maxZoom, zoomStep,
      ];
}
