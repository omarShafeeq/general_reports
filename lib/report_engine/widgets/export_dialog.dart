import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../blocs/data/report_data_bloc.dart';
import '../blocs/export_cubit.dart';
import '../blocs/filter/report_filter_bloc.dart';
import '../models/enums.dart';
import '../models/report_definition.dart';
import '../utils/document_report_exporter.dart';
import '../utils/report_export_service.dart';

class ExportDialog extends StatefulWidget {
  final ReportDefinition report;
  final GlobalKey repaintKey;
  final GlobalKey? documentCaptureKey;
  final Map<String, GlobalKey<SfDataGridState>> gridKeys;
  final ScaffoldMessengerState scaffoldMessenger;

  const ExportDialog({
    super.key,
    required this.report,
    required this.repaintKey,
    this.documentCaptureKey,
    required this.gridKeys,
    required this.scaffoldMessenger,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportFormat? _activeFormat;

  ReportDefinition get report => widget.report;

  @override
  Widget build(BuildContext context) {
    final formats = report.exportOptions.formats;

    return AlertDialog(
      title: const Text('Export Report'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_activeFormat != null) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 12),
              Text('Exporting ${_labelForFormat(_activeFormat!)}...'),
              const SizedBox(height: 12),
            ],
            ...formats.map((format) {
              final isBusy = _activeFormat != null;
              return ListTile(
                enabled: !isBusy,
                leading: Icon(_iconForFormat(format)),
                title: Text(_labelForFormat(format)),
                trailing: _activeFormat == format
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                onTap: isBusy ? null : () => _export(context, format),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _activeFormat != null ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, ExportFormat format) async {
    setState(() => _activeFormat = format);

    final navigator = Navigator.of(context);
    final messenger = widget.scaffoldMessenger;
    final exportCubit = context.read<ExportCubit>();
    final data = context.read<ReportDataBloc>().state.data;
    final filterValues = context.read<ReportFilterBloc>().state.values;

    exportCubit.startExport(format);
    navigator.pop();

    messenger.showSnackBar(
      SnackBar(
        content: Text('Exporting ${_labelForFormat(format)}...'),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      final savedPath = switch (format) {
        ExportFormat.pdf => await _exportPdf(data, filterValues),
        ExportFormat.excel => await _exportExcel(data),
        ExportFormat.csv => await _exportCsv(data),
        ExportFormat.image => await _exportImage(),
        ExportFormat.print => await _printReport(data, filterValues),
      };

      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            savedPath != null && savedPath != 'Print dialog opened'
                ? 'Saved: $savedPath'
                : savedPath ?? 'Export completed successfully',
          ),
        ),
      );
      exportCubit.exportSuccess(filePath: savedPath);
    } catch (e) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
      exportCubit.exportError(e.toString());
    }
  }

  Future<String> _exportPdf(
    Map<String, dynamic> data,
    Map<String, dynamic> filterValues,
  ) async {
    final bytes = await _buildPdfBytes(data, filterValues);
    return ReportExportService.savePdf(bytes, report: report);
  }

  Future<String> _exportExcel(Map<String, dynamic> data) async {
    final bytes = await _buildExcelBytes(data);
    return ReportExportService.saveExcel(bytes, report: report);
  }

  Future<String> _exportCsv(Map<String, dynamic> data) async {
    final content = await _buildCsvContent(data);
    return ReportExportService.saveCsv(content, report: report);
  }

  Future<String> _exportImage() async {
    final bytes = await _captureWidget();
    if (bytes == null) {
      throw Exception('Failed to capture report image. Run the report first.');
    }
    return ReportExportService.saveImage(bytes, report: report);
  }

  Future<String?> _printReport(
    Map<String, dynamic> data,
    Map<String, dynamic> filterValues,
  ) async {
    final bytes = await _buildPdfBytes(data, filterValues);
    await ReportExportService.printPdf(bytes, report: report);
    return 'Print dialog opened';
  }

  Future<List<int>> _buildPdfBytes(
    Map<String, dynamic> data,
    Map<String, dynamic> filterValues,
  ) async {
    if (report.isDocumentView) {
      Uint8List? visualCapture;
      if (report.charts.isNotEmpty && report.grids.isEmpty) {
        visualCapture = await _captureDocumentPageForPdf();
      }
      return DocumentReportExporter.buildPdf(
        report: report,
        data: data,
        filterValues: filterValues,
        visualCaptureBytes: visualCapture,
      );
    }

    final gridState = _firstGridState();
    if (gridState != null) {
      final document = gridState.exportToPdfDocument(
        fitAllColumnsInOnePage: true,
      );
      final bytes = await document.save();
      document.dispose();
      return bytes;
    }

    final imageBytes = await _captureWidget();
    if (imageBytes == null) {
      throw Exception(
        'No report content to export. Click Run to load the report first.',
      );
    }

    final document = PdfDocument();
    final page = document.pages.add();
    final image = PdfBitmap(imageBytes);
    final pageSize = page.getClientSize();
    page.graphics.drawImage(
      image,
      Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
    );
    final bytes = await document.save();
    document.dispose();
    return bytes;
  }

  Future<List<int>> _buildExcelBytes(Map<String, dynamic> data) async {
    if (report.isDocumentView) {
      return DocumentReportExporter.buildExcel(
        report: report,
        data: data,
      );
    }

    final gridState = _firstGridState();
    if (gridState != null) {
      final workbook = gridState.exportToExcelWorkbook();
      final bytes = workbook.saveAsStream();
      workbook.dispose();
      return bytes;
    }

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText(report.title);
    sheet.getRangeByName('A2').setText(
      'Run the report first to export grid data.',
    );
    final bytes = workbook.saveAsStream();
    workbook.dispose();
    return bytes;
  }

  Future<String> _buildCsvContent(Map<String, dynamic> data) async {
    if (report.isDocumentView) {
      return DocumentReportExporter.buildCsv(
        report: report,
        data: data,
      );
    }

    final gridState = _firstGridState();
    if (gridState == null) {
      throw Exception(
        'No grid data available. Click Run to load the report first.',
      );
    }

    final workbook = gridState.exportToExcelWorkbook();
    final sheet = workbook.worksheets[0];
    final buffer = StringBuffer();

    for (var row = 1; row <= sheet.getLastRow(); row++) {
      final cells = <String>[];
      for (var col = 1; col <= sheet.getLastColumn(); col++) {
        final cell = sheet.getRangeByIndex(row, col);
        var text = cell.text ?? cell.value?.toString() ?? '';
        if (text.contains(',') || text.contains('"') || text.contains('\n')) {
          text = '"${text.replaceAll('"', '""')}"';
        }
        cells.add(text);
      }
      buffer.writeln(cells.join(','));
    }
    workbook.dispose();
    return buffer.toString();
  }

  SfDataGridState? _firstGridState() {
    for (final key in widget.gridKeys.values) {
      if (key.currentState != null) return key.currentState;
    }
    return null;
  }

  Future<Uint8List?> _captureDocumentPageForPdf() async {
    await SchedulerBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _captureWidget(pixelRatio: 2.0);
  }

  Future<Uint8List?> _captureWidget({double? pixelRatio}) async {
    try {
      await SchedulerBinding.instance.endOfFrame;
      final captureKey = report.isDocumentView
          ? widget.documentCaptureKey
          : widget.repaintKey;
      if (captureKey?.currentContext == null) return null;

      final boundary = captureKey!.currentContext!.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ratio = pixelRatio ?? (report.isDocumentView ? 1.5 : 3.0);
      final image = await boundary.toImage(pixelRatio: ratio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  IconData _iconForFormat(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
      case ExportFormat.excel:
        return Icons.table_chart;
      case ExportFormat.csv:
        return Icons.description;
      case ExportFormat.print:
        return Icons.print;
      case ExportFormat.image:
        return Icons.image;
    }
  }

  String _labelForFormat(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return 'Export as PDF';
      case ExportFormat.excel:
        return 'Export as Excel';
      case ExportFormat.csv:
        return 'Export as CSV';
      case ExportFormat.print:
        return 'Print';
      case ExportFormat.image:
        return 'Export as Image';
    }
  }
}
