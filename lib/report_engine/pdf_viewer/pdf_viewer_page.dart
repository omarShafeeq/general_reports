import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../core/constants/app_sizes.dart';
import '../../widgets/common/responsive_scaffold.dart';
import '../../routing/route_names.dart';
import '../blocs/pdf_viewer_cubit.dart';
import 'pdf_viewer_toolbar.dart';

class PdfViewerPage extends StatefulWidget {
  final String? filePath;
  final String? url;
  final Uint8List? bytes;
  final String title;

  const PdfViewerPage({
    super.key,
    this.filePath,
    this.url,
    this.bytes,
    this.title = 'PDF Viewer',
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late final PdfViewerCubit _cubit;
  late final PdfViewerController _pdfController;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = PdfViewerCubit();
    _pdfController = PdfViewerController();
  }

  @override
  void dispose() {
    _cubit.close();
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: ResponsiveScaffold(
        title: widget.title,
        currentRoute: RouteNames.pdfViewer,
        body: Column(
          children: [
            PdfViewerToolbar(
              pdfController: _pdfController,
              pdfViewerKey: _pdfViewerKey,
            ),
            Expanded(child: _buildViewer()),
          ],
        ),
      ),
    );
  }

  Widget _buildViewer() {
    if (widget.bytes != null) {
      return SfPdfViewer.memory(
        widget.bytes!,
        key: _pdfViewerKey,
        controller: _pdfController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        onDocumentLoaded: _onDocumentLoaded,
        onPageChanged: _onPageChanged,
      );
    }

    if (widget.url != null) {
      return SfPdfViewer.network(
        widget.url!,
        key: _pdfViewerKey,
        controller: _pdfController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        onDocumentLoaded: _onDocumentLoaded,
        onPageChanged: _onPageChanged,
      );
    }

    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Text('No PDF document provided'),
      ),
    );
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    _cubit.setTotalPages(details.document.pages.count);
  }

  void _onPageChanged(PdfPageChangedDetails details) {
    _cubit.setPage(details.newPageNumber);
  }
}
