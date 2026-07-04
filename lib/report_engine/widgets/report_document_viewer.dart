import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/report_viewer_settings_cubit.dart';
import '../models/enums.dart';

/// DevExpress-style document canvas: gray background, centered white page, zoom/fit.
class ReportDocumentViewer extends StatefulWidget {
  final Widget child;
  final GlobalKey? documentCaptureKey;

  const ReportDocumentViewer({
    super.key,
    required this.child,
    this.documentCaptureKey,
  });

  /// A4 page dimensions at 96 DPI (logical pixels).
  static const pageWidth = 794.0;
  static const pageHeight = 1123.0;
  static const canvasColor = Color(0xFFE8E8E8);
  static const pageBorderColor = Color(0xFF1565C0);

  @override
  State<ReportDocumentViewer> createState() => _ReportDocumentViewerState();
}

class _ReportDocumentViewerState extends State<ReportDocumentViewer> {
  final _scrollController = ScrollController();
  final _contentKey = GlobalKey();
  double _contentHeight = ReportDocumentViewer.pageHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePageMetrics());
  }

  @override
  void didUpdateWidget(covariant ReportDocumentViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePageMetrics());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updatePageMetrics() {
    final context = _contentKey.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final height = box.size.height;
    if ((height - _contentHeight).abs() < 1) return;

    setState(() => _contentHeight = height);

    final totalPages = _computeTotalPages(height);
    final cubit = this.context.read<ReportViewerSettingsCubit>();
    if (cubit.state.totalPages != totalPages) {
      cubit.setTotalPages(totalPages);
    }
  }

  int _computeTotalPages(double contentHeight) {
    return (contentHeight / ReportDocumentViewer.pageHeight).ceil().clamp(1, 999);
  }

  void _scrollToPage(int page, double scale) {
    final pageHeight = ReportDocumentViewer.pageHeight * scale;
    final offset = (page - 1) * pageHeight;
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportViewerSettingsCubit, ReportViewerSettingsState>(
      listenWhen: (prev, curr) => prev.currentPage != curr.currentPage,
      listener: (context, state) {
        final scale = _resolveScale(context, state);
        _scrollToPage(state.currentPage, scale);
      },
      child: BlocBuilder<ReportViewerSettingsCubit, ReportViewerSettingsState>(
        builder: (context, settings) {
          final scale = _resolveScale(context, settings);

          return Container(
            color: ReportDocumentViewer.canvasColor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Center(
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: ReportDocumentViewer.pageWidth,
                        constraints: const BoxConstraints(
                          minHeight: ReportDocumentViewer.pageHeight,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ReportDocumentViewer.pageBorderColor,
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              offset: Offset(2, 4),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Color(0x20000000),
                              offset: Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: RepaintBoundary(
                          key: widget.documentCaptureKey,
                          child: KeyedSubtree(
                            key: _contentKey,
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  double _resolveScale(BuildContext context, ReportViewerSettingsState settings) {
    if (settings.fitMode == FitMode.fitPage) {
      return settings.zoomLevel.clamp(0.5, 1.0);
    }
    if (settings.fitMode == FitMode.fitWidth) {
      return settings.zoomLevel;
    }
    return settings.zoomLevel;
  }
}
