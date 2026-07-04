import 'dart:typed_data';
import 'dart:ui' show Offset, Rect;

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf_pdf;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../models/chart_definition.dart';
import '../models/enums.dart';
import '../models/export_definition.dart';
import '../models/grid_definition.dart';
import '../models/report_definition.dart';
import 'grid_summary_utils.dart';
import 'report_export_service.dart';

/// Data-driven export for document-mode reports (no widget screenshot).
abstract final class DocumentReportExporter {
  static final _headerColor = sf_pdf.PdfColor(0, 137, 123);
  static const _rowHeight = 18.0;
  static const _tableHeaderHeight = 20.0;

  static Future<List<int>> buildPdf({
    required ReportDefinition report,
    required Map<String, dynamic> data,
    Map<String, dynamic> filterValues = const {},
    Uint8List? visualCaptureBytes,
  }) async {
    if (visualCaptureBytes != null &&
        report.charts.isNotEmpty &&
        report.grids.isEmpty) {
      return buildPdfFromVisualCapture(
        report: report,
        imageBytes: visualCaptureBytes,
      );
    }
    if (report.grids.isNotEmpty) {
      return _buildGridPdf(report: report, data: data, filterValues: filterValues);
    }
    if (report.charts.isNotEmpty) {
      return _buildChartPdf(report: report, data: data, filterValues: filterValues);
    }
    throw Exception('No exportable content defined for this report.');
  }

  /// Builds a paginated PDF from a screenshot of the document page (charts as visuals).
  static Future<List<int>> buildPdfFromVisualCapture({
    required ReportDefinition report,
    required Uint8List imageBytes,
  }) async {
    final exportDef = report.exportOptions;
    final pageSize = ReportExportService.mapPageSize(exportDef.pageSize);
    final isLandscape =
        exportDef.orientation == PageOrientation.landscape;
    final bitmap = sf_pdf.PdfBitmap(imageBytes);
    final imageWidth = bitmap.width.toDouble();
    final imageHeight = bitmap.height.toDouble();

    if (imageWidth <= 0 || imageHeight <= 0) {
      throw Exception('Failed to capture report visuals for PDF export.');
    }

    final document = sf_pdf.PdfDocument();
    final section = document.sections!.add();
    section.pageSettings.size = pageSize;
    section.pageSettings.orientation = isLandscape
        ? sf_pdf.PdfPageOrientation.landscape
        : sf_pdf.PdfPageOrientation.portrait;
    section.pageSettings.margins = sf_pdf.PdfMargins()
      ..top = exportDef.margins.top
      ..right = exportDef.margins.right
      ..bottom = exportDef.margins.bottom
      ..left = exportDef.margins.left;

    if (exportDef.footer != null) {
      section.template.bottom = ReportExportService.buildFooterTemplate(
        exportDef.footer!,
        section.pageSettings,
      );
    }

    final margins = exportDef.margins;
    const footerReserve = 36.0;
    final contentWidth =
        pageSize.width - margins.left - margins.right;
    final contentHeight =
        pageSize.height - margins.top - margins.bottom - footerReserve;

    final scale = contentWidth / imageWidth;
    final scaledTotalHeight = imageHeight * scale;

    if (scaledTotalHeight <= contentHeight) {
      final page = section.pages.add();
      page.graphics.drawImage(
        bitmap,
        Rect.fromLTWH(margins.left, margins.top, contentWidth, scaledTotalHeight),
      );
    } else {
      var srcY = 0.0;
      while (srcY < imageHeight - 0.5) {
        final page = section.pages.add();
        final remainingSrcHeight = imageHeight - srcY;
        final srcChunkHeight =
            (contentHeight / scale).clamp(1.0, remainingSrcHeight);
        final destHeight = srcChunkHeight * scale;

        page.graphics.setClip(
          bounds: Rect.fromLTWH(
            margins.left,
            margins.top,
            contentWidth,
            destHeight,
          ),
        );
        page.graphics.drawImage(
          bitmap,
          Rect.fromLTWH(
            margins.left,
            margins.top - srcY * scale,
            contentWidth,
            scaledTotalHeight,
          ),
        );

        srcY += srcChunkHeight;
      }
    }

    final bytes = await document.save();
    document.dispose();
    return bytes;
  }

  static Future<List<int>> _buildGridPdf({
    required ReportDefinition report,
    required Map<String, dynamic> data,
    Map<String, dynamic> filterValues = const {},
  }) async {
    final grid = report.grids.first;

    final rows = _gridRows(data, grid);
    if (rows.isEmpty) {
      throw Exception('No report data to export. Load the report first.');
    }

    final exportDef = report.exportOptions;
    final pageSize = ReportExportService.mapPageSize(exportDef.pageSize);
    final isLandscape =
        exportDef.orientation == PageOrientation.landscape;

    final document = sf_pdf.PdfDocument();
    final section = document.sections!.add();
    section.pageSettings.size = pageSize;
    section.pageSettings.orientation = isLandscape
        ? sf_pdf.PdfPageOrientation.landscape
        : sf_pdf.PdfPageOrientation.portrait;
    section.pageSettings.margins = sf_pdf.PdfMargins()
      ..top = exportDef.margins.top
      ..right = exportDef.margins.right
      ..bottom = exportDef.margins.bottom
      ..left = exportDef.margins.left;

    if (exportDef.footer != null) {
      section.template.bottom = ReportExportService.buildFooterTemplate(
        exportDef.footer!,
        section.pageSettings,
      );
    }

    final columns = grid.columns.where((c) => c.visible).toList();
    final colWidths = _columnWidths(columns, pageSize.width - exportDef.margins.left - exportDef.margins.right);

    var rowIndex = 0;
    sf_pdf.PdfPage page = section.pages.add();
    var clientSize = page.getClientSize();
    var clientWidth = clientSize.width;
    var clientHeight = clientSize.height;
    var y = _drawDocumentHeader(
      page.graphics,
      report,
      filterValues,
      clientWidth,
    );
    y += 12;
    y += _drawTableHeader(page.graphics, columns, colWidths, y, clientWidth);

    while (rowIndex < rows.length) {
      if (y + _rowHeight > clientHeight - 8) {
        page = section.pages.add();
        clientSize = page.getClientSize();
        clientWidth = clientSize.width;
        clientHeight = clientSize.height;
        y = _drawTableHeader(page.graphics, columns, colWidths, 0, clientWidth);
      }

      _drawDataRow(
        page.graphics,
        columns,
        colWidths,
        rows[rowIndex],
        y,
        rowIndex.isOdd,
      );
      y += _rowHeight;
      rowIndex++;
    }

    if (grid.summaries != null && grid.summaries!.isNotEmpty) {
      if (y + _rowHeight > clientHeight - 8) {
        page = section.pages.add();
        clientSize = page.getClientSize();
        clientWidth = clientSize.width;
        clientHeight = clientSize.height;
        y = _drawTableHeader(page.graphics, columns, colWidths, 0, clientWidth);
      }
      _drawSummaryRow(
        page.graphics,
        columns,
        colWidths,
        grid,
        rows,
        y,
        clientWidth,
      );
    }

    final bytes = await document.save();
    document.dispose();
    return bytes;
  }

  static Future<List<int>> _buildChartPdf({
    required ReportDefinition report,
    required Map<String, dynamic> data,
    Map<String, dynamic> filterValues = const {},
  }) async {
    _ensureChartData(report, data);

    final exportDef = report.exportOptions;
    final pageSize = ReportExportService.mapPageSize(exportDef.pageSize);
    final isLandscape =
        exportDef.orientation == PageOrientation.landscape;

    final document = sf_pdf.PdfDocument();
    final section = document.sections!.add();
    section.pageSettings.size = pageSize;
    section.pageSettings.orientation = isLandscape
        ? sf_pdf.PdfPageOrientation.landscape
        : sf_pdf.PdfPageOrientation.portrait;
    section.pageSettings.margins = sf_pdf.PdfMargins()
      ..top = exportDef.margins.top
      ..right = exportDef.margins.right
      ..bottom = exportDef.margins.bottom
      ..left = exportDef.margins.left;

    if (exportDef.footer != null) {
      section.template.bottom = ReportExportService.buildFooterTemplate(
        exportDef.footer!,
        section.pageSettings,
      );
    }

    sf_pdf.PdfPage page = section.pages.add();
    var clientSize = page.getClientSize();
    var clientWidth = clientSize.width;
    var clientHeight = clientSize.height;
    var y = _drawDocumentHeader(
      page.graphics,
      report,
      filterValues,
      clientWidth,
    );
    y += 16;

    for (final chart in report.charts) {
      final rows = _chartRows(data, chart);
      if (rows.isEmpty) continue;

      final columns = _chartColumns(chart, rows);
      final colWidths = _chartColumnWidths(columns, clientWidth);

      if (y + 40 > clientHeight - 8) {
        page = section.pages.add();
        clientSize = page.getClientSize();
        clientWidth = clientSize.width;
        clientHeight = clientSize.height;
        y = 0;
      }

      y += _drawChartSectionTitle(page.graphics, chart, y, clientWidth);
      y += 8;
      y += _drawChartTableHeader(
        page.graphics,
        columns,
        colWidths,
        y,
        clientWidth,
      );

      for (var i = 0; i < rows.length; i++) {
        if (y + _rowHeight > clientHeight - 8) {
          page = section.pages.add();
          clientSize = page.getClientSize();
          clientWidth = clientSize.width;
          clientHeight = clientSize.height;
          y = _drawChartSectionTitle(page.graphics, chart, 0, clientWidth);
          y += 8;
          y += _drawChartTableHeader(
            page.graphics,
            columns,
            colWidths,
            y,
            clientWidth,
          );
        }
        _drawChartDataRow(
          page.graphics,
          columns,
          colWidths,
          rows[i],
          y,
          i.isOdd,
        );
        y += _rowHeight;
      }
      y += 20;
    }

    final bytes = await document.save();
    document.dispose();
    return bytes;
  }

  static Future<List<int>> buildExcel({
    required ReportDefinition report,
    required Map<String, dynamic> data,
  }) async {
    if (report.grids.isNotEmpty) {
      return _buildGridExcel(report: report, data: data);
    }
    if (report.charts.isNotEmpty) {
      return _buildChartExcel(report: report, data: data);
    }
    throw Exception('No exportable content defined for this report.');
  }

  static Future<List<int>> _buildGridExcel({
    required ReportDefinition report,
    required Map<String, dynamic> data,
  }) async {
    final grid = report.grids.first;

    final rows = _gridRows(data, grid);
    if (rows.isEmpty) {
      throw Exception('No report data to export. Load the report first.');
    }

    final columns = grid.columns.where((c) => c.visible).toList();
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Report';

    sheet.getRangeByIndex(1, 1).setText(report.exportOptions.title ?? report.title);

    for (var c = 0; c < columns.length; c++) {
      sheet.getRangeByIndex(3, c + 1).setText(columns[c].title);
    }

    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < columns.length; c++) {
        final col = columns[c];
        final value = rows[r][col.field];
        sheet.getRangeByIndex(r + 4, c + 1).setText(_formatValue(value, col));
      }
    }

    if (grid.summaries != null && grid.summaries!.isNotEmpty) {
      final summaryRow = rows.length + 4;
      final summaryByField = {
        for (final s in grid.summaries!) s.field: s,
      };
      sheet
          .getRangeByIndex(summaryRow, 1)
          .setText(GridSummaryUtils.labelForSummaryRow(grid.summaries!));
      for (var c = 0; c < columns.length; c++) {
        final col = columns[c];
        final summary = summaryByField[col.field];
        if (summary != null) {
          final value = GridSummaryUtils.compute(summary, rows);
          sheet
              .getRangeByIndex(summaryRow, c + 1)
              .setText(GridSummaryUtils.format(value, col, config: summary));
        }
      }
    }

    final bytes = workbook.saveAsStream();
    workbook.dispose();
    return bytes;
  }

  static Future<List<int>> _buildChartExcel({
    required ReportDefinition report,
    required Map<String, dynamic> data,
  }) async {
    _ensureChartData(report, data);

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Report';
    sheet.getRangeByIndex(1, 1).setText(report.exportOptions.title ?? report.title);

    var rowOffset = 3;
    for (final chart in report.charts) {
      final rows = _chartRows(data, chart);
      if (rows.isEmpty) continue;

      final columns = _chartColumns(chart, rows);
      sheet.getRangeByIndex(rowOffset, 1).setText(chart.title);
      rowOffset++;
      if (chart.subtitle != null) {
        sheet.getRangeByIndex(rowOffset, 1).setText(chart.subtitle!);
        rowOffset++;
      }

      for (var c = 0; c < columns.length; c++) {
        sheet.getRangeByIndex(rowOffset, c + 1).setText(columns[c].title);
      }
      rowOffset++;

      for (final row in rows) {
        for (var c = 0; c < columns.length; c++) {
          final col = columns[c];
          sheet
              .getRangeByIndex(rowOffset, c + 1)
              .setText(_formatChartValue(row[col.field], col));
        }
        rowOffset++;
      }
      rowOffset += 2;
    }

    final bytes = workbook.saveAsStream();
    workbook.dispose();
    return bytes;
  }

  static String buildCsv({
    required ReportDefinition report,
    required Map<String, dynamic> data,
  }) {
    if (report.grids.isNotEmpty) {
      return _buildGridCsv(report: report, data: data);
    }
    if (report.charts.isNotEmpty) {
      return _buildChartCsv(report: report, data: data);
    }
    throw Exception('No exportable content defined for this report.');
  }

  static String _buildGridCsv({
    required ReportDefinition report,
    required Map<String, dynamic> data,
  }) {
    final grid = report.grids.first;

    final rows = _gridRows(data, grid);
    if (rows.isEmpty) {
      throw Exception('No report data to export. Load the report first.');
    }

    final columns = grid.columns.where((c) => c.visible).toList();
    final buffer = StringBuffer();

    buffer.writeln(_csvEscape(report.exportOptions.title ?? report.title));
    buffer.writeln();
    buffer.writeln(columns.map((c) => _csvEscape(c.title)).join(','));

    for (final row in rows) {
      buffer.writeln(
        columns.map((c) => _csvEscape(_formatValue(row[c.field], c))).join(','),
      );
    }

    if (grid.summaries != null && grid.summaries!.isNotEmpty) {
      final summaryByField = {
        for (final s in grid.summaries!) s.field: s,
      };
      final cells = List.filled(columns.length, '');
      cells[0] = GridSummaryUtils.labelForSummaryRow(grid.summaries!);
      for (var c = 0; c < columns.length; c++) {
        final col = columns[c];
        final summary = summaryByField[col.field];
        if (summary != null) {
          final value = GridSummaryUtils.compute(summary, rows);
          cells[c] = GridSummaryUtils.format(value, col, config: summary);
        }
      }
      buffer.writeln(cells.map(_csvEscape).join(','));
    }

    return buffer.toString();
  }

  static String _buildChartCsv({
    required ReportDefinition report,
    required Map<String, dynamic> data,
  }) {
    _ensureChartData(report, data);

    final buffer = StringBuffer();
    buffer.writeln(_csvEscape(report.exportOptions.title ?? report.title));
    buffer.writeln();

    for (final chart in report.charts) {
      final rows = _chartRows(data, chart);
      if (rows.isEmpty) continue;

      final columns = _chartColumns(chart, rows);
      buffer.writeln(_csvEscape(chart.title));
      if (chart.subtitle != null) {
        buffer.writeln(_csvEscape(chart.subtitle!));
      }
      buffer.writeln(columns.map((c) => _csvEscape(c.title)).join(','));
      for (final row in rows) {
        buffer.writeln(
          columns
              .map((c) => _csvEscape(_formatChartValue(row[c.field], c)))
              .join(','),
        );
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  static void _ensureChartData(ReportDefinition report, Map<String, dynamic> data) {
    final hasData = report.charts.any((chart) => _chartRows(data, chart).isNotEmpty);
    if (!hasData) {
      throw Exception('No report data to export. Load the report first.');
    }
  }

  static List<Map<String, dynamic>> _chartRows(
    Map<String, dynamic> data,
    ChartDefinition chart,
  ) {
    final raw = data[chart.dataKey];
    if (raw is List) {
      return raw.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static List<_ChartExportColumn> _chartColumns(
    ChartDefinition chart,
    List<Map<String, dynamic>> rows,
  ) {
    if (rows.isEmpty) return [];

    final fields = <String>{chart.xField, ...chart.yFields};
    for (final row in rows) {
      fields.addAll(row.keys);
    }

    final ordered = <String>[
      chart.xField,
      ...chart.yFields.where((f) => f != chart.xField),
      ...fields.where((f) => f != chart.xField && !chart.yFields.contains(f)),
    ];

    return ordered.map((field) {
      final title = field == chart.xField
          ? (chart.xAxis?.title ?? _titleCase(field))
          : chart.yFields.contains(field)
              ? _titleCase(field)
              : _titleCase(field);
      final isNumeric = rows.every((r) {
        final v = r[field];
        return v == null || v is num;
      });
      return _ChartExportColumn(
        field: field,
        title: title,
        isNumeric: isNumeric,
      );
    }).toList();
  }

  static String _titleCase(String field) {
    return field
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m[1]} ${m[2]}',
        )
        .split(RegExp(r'[_\s]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  static List<double> _chartColumnWidths(
    List<_ChartExportColumn> columns,
    double totalWidth,
  ) {
    final flexWidth = totalWidth / columns.length;
    return List.filled(columns.length, flexWidth);
  }

  static double _drawChartSectionTitle(
    sf_pdf.PdfGraphics graphics,
    ChartDefinition chart,
    double y,
    double width,
  ) {
    final titleFont = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica,
      11,
      style: sf_pdf.PdfFontStyle.bold,
    );
    graphics.drawString(
      chart.title,
      titleFont,
      bounds: Rect.fromLTWH(0, y, width, 16),
    );
    var offset = 16.0;
    if (chart.subtitle != null) {
      final subtitleFont = sf_pdf.PdfStandardFont(
        sf_pdf.PdfFontFamily.helvetica,
        8,
      );
      graphics.drawString(
        chart.subtitle!,
        subtitleFont,
        bounds: Rect.fromLTWH(0, y + offset, width, 12),
        brush: sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(117, 117, 117)),
      );
      offset += 12;
    }
    return offset;
  }

  static double _drawChartTableHeader(
    sf_pdf.PdfGraphics graphics,
    List<_ChartExportColumn> columns,
    List<double> colWidths,
    double y,
    double totalWidth,
  ) {
    graphics.drawRectangle(
      brush: sf_pdf.PdfSolidBrush(_headerColor),
      bounds: Rect.fromLTWH(0, y, totalWidth, _tableHeaderHeight),
    );
    final font = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica,
      9,
      style: sf_pdf.PdfFontStyle.bold,
    );
    var x = 0.0;
    for (var i = 0; i < columns.length; i++) {
      graphics.drawString(
        columns[i].title,
        font,
        bounds: Rect.fromLTWH(x + 4, y + 4, colWidths[i] - 8, _tableHeaderHeight - 4),
        brush: sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(255, 255, 255)),
        format: columns[i].isNumeric
            ? sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.right)
            : sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.left),
      );
      x += colWidths[i];
    }
    return _tableHeaderHeight;
  }

  static void _drawChartDataRow(
    sf_pdf.PdfGraphics graphics,
    List<_ChartExportColumn> columns,
    List<double> colWidths,
    Map<String, dynamic> rowData,
    double y,
    bool shaded,
  ) {
    if (shaded) {
      graphics.drawRectangle(
        brush: sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(250, 250, 250)),
        bounds: Rect.fromLTWH(0, y, colWidths.fold(0.0, (a, b) => a + b), _rowHeight),
      );
    }
    final font = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 8);
    var x = 0.0;
    for (var i = 0; i < columns.length; i++) {
      final col = columns[i];
      graphics.drawString(
        _formatChartValue(rowData[col.field], col),
        font,
        bounds: Rect.fromLTWH(x + 4, y + 3, colWidths[i] - 8, _rowHeight - 2),
        format: col.isNumeric
            ? sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.right)
            : sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.left),
      );
      x += colWidths[i];
    }
    graphics.drawLine(
      sf_pdf.PdfPen(sf_pdf.PdfColor(224, 224, 224)),
      Offset(0, y + _rowHeight),
      Offset(x, y + _rowHeight),
    );
  }

  static String _formatChartValue(dynamic value, _ChartExportColumn col) {
    if (value == null) return '';
    if (col.isNumeric && value is num) {
      return NumberFormat('#,##0.##').format(value);
    }
    return value.toString();
  }

  static List<Map<String, dynamic>> _gridRows(
    Map<String, dynamic> data,
    GridDefinition grid,
  ) {
    final raw = data[grid.dataKey];
    if (raw is List) {
      return raw.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static double _drawDocumentHeader(
    sf_pdf.PdfGraphics graphics,
    ReportDefinition report,
    Map<String, dynamic> filterValues,
    double width,
  ) {
    final meta = report.metadata;
    final header = report.exportOptions.header;
    final titleFont = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica,
      16,
      style: sf_pdf.PdfFontStyle.bold,
    );
    final bodyFont = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 9);
    final smallFont = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 8);
    final title = report.exportOptions.title ?? report.title;

    var y = 0.0;
    graphics.drawString(
      title,
      titleFont,
      bounds: Rect.fromLTWH(0, y, width, 22),
      format: sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.center),
    );
    y += 28;

    final companyName = header?.companyName ??
        meta['companyName'] as String? ??
        'IX Corporation';
    final leftLines = <String>[
      if (header?.showCompanyName != false) companyName,
      meta['address'] as String? ?? '',
      meta['city'] as String? ?? '',
      'Phone: ${meta['phone'] ?? ''}',
      'Email: ${meta['email'] ?? ''}',
      'Website: ${meta['website'] ?? ''}',
    ].where((s) => s.isNotEmpty).toList();

    final leftHeight = leftLines.length * 12.0;
    for (var i = 0; i < leftLines.length; i++) {
      graphics.drawString(
        leftLines[i],
        i == 0 ? sf_pdf.PdfStandardFont(
          sf_pdf.PdfFontFamily.helvetica,
          9,
          style: sf_pdf.PdfFontStyle.bold,
        ) : bodyFont,
        bounds: Rect.fromLTWH(0, y + i * 12, width * 0.55, 12),
      );
    }

    final dateRange = _formatDateRange(filterValues);
    final printedOn = DateFormat('M/d/yyyy h:mm:ss a').format(DateTime.now());
    final metaBoxWidth = 180.0;
    final metaX = width - metaBoxWidth;
    graphics.drawRectangle(
      pen: sf_pdf.PdfPen(sf_pdf.PdfColor(176, 190, 197)),
      bounds: Rect.fromLTWH(metaX, y, metaBoxWidth, 36),
    );
    graphics.drawString(
      'Date Range: $dateRange',
      smallFont,
      bounds: Rect.fromLTWH(metaX + 6, y + 4, metaBoxWidth - 12, 12),
    );
    graphics.drawString(
      'Printed on: $printedOn',
      smallFont,
      bounds: Rect.fromLTWH(metaX + 6, y + 18, metaBoxWidth - 12, 12),
    );

    y += leftHeight > 36 ? leftHeight : 36;
    y += 8;
    graphics.drawRectangle(
      brush: sf_pdf.PdfSolidBrush(_headerColor),
      bounds: Rect.fromLTWH(0, y, width, 3),
    );
    y += 8;
    return y;
  }

  static String _formatDateRange(Map<String, dynamic> filterValues) {
    for (final value in filterValues.values) {
      if (value is Map && value.containsKey('start') && value.containsKey('end')) {
        return '${_formatDate(value['start'])} - ${_formatDate(value['end'])}';
      }
    }
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return '${DateFormat('M/d/yyyy').format(start)} - ${DateFormat('M/d/yyyy').format(now)}';
  }

  static String _formatDate(dynamic value) {
    if (value is DateTime) return DateFormat('M/d/yyyy').format(value);
    if (value is String) {
      try {
        return DateFormat('M/d/yyyy').format(DateTime.parse(value));
      } catch (_) {
        return value;
      }
    }
    return value?.toString() ?? '';
  }

  static List<double> _columnWidths(
    List<GridColumnDefinition> columns,
    double totalWidth,
  ) {
    final fixed = columns.where((c) => c.width != null).fold<double>(
      0,
      (sum, c) => sum + c.width!,
    );
    final flexCount = columns.where((c) => c.width == null).length;
    final flexWidth = flexCount > 0 ? (totalWidth - fixed) / flexCount : 0.0;
    return columns
        .map((c) => c.width ?? flexWidth)
        .toList();
  }

  static double _drawTableHeader(
    sf_pdf.PdfGraphics graphics,
    List<GridColumnDefinition> columns,
    List<double> colWidths,
    double y,
    double totalWidth,
  ) {
    graphics.drawRectangle(
      brush: sf_pdf.PdfSolidBrush(_headerColor),
      bounds: Rect.fromLTWH(0, y, totalWidth, _tableHeaderHeight),
    );
    final font = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica,
      9,
      style: sf_pdf.PdfFontStyle.bold,
    );
    var x = 0.0;
    for (var i = 0; i < columns.length; i++) {
      graphics.drawString(
        columns[i].title,
        font,
        bounds: Rect.fromLTWH(x + 4, y + 4, colWidths[i] - 8, _tableHeaderHeight - 4),
        brush: sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(255, 255, 255)),
        format: _pdfAlignment(columns[i].alignment),
      );
      x += colWidths[i];
    }
    return _tableHeaderHeight;
  }

  static void _drawDataRow(
    sf_pdf.PdfGraphics graphics,
    List<GridColumnDefinition> columns,
    List<double> colWidths,
    Map<String, dynamic> rowData,
    double y,
    bool shaded,
  ) {
    if (shaded) {
      graphics.drawRectangle(
        brush: sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(250, 250, 250)),
        bounds: Rect.fromLTWH(0, y, colWidths.fold(0.0, (a, b) => a + b), _rowHeight),
      );
    }
    final font = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 8);
    var x = 0.0;
    for (var i = 0; i < columns.length; i++) {
      final col = columns[i];
      graphics.drawString(
        _formatValue(rowData[col.field], col),
        font,
        bounds: Rect.fromLTWH(x + 4, y + 3, colWidths[i] - 8, _rowHeight - 2),
        format: _pdfAlignment(col.alignment),
      );
      x += colWidths[i];
    }
    graphics.drawLine(
      sf_pdf.PdfPen(sf_pdf.PdfColor(224, 224, 224)),
      Offset(0, y + _rowHeight),
      Offset(x, y + _rowHeight),
    );
  }

  static void _drawSummaryRow(
    sf_pdf.PdfGraphics graphics,
    List<GridColumnDefinition> columns,
    List<double> colWidths,
    GridDefinition grid,
    List<Map<String, dynamic>> rows,
    double y,
    double totalWidth,
  ) {
    graphics.drawRectangle(
      brush: sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(238, 238, 238)),
      bounds: Rect.fromLTWH(0, y, totalWidth, _rowHeight + 2),
    );
    final font = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica,
      8,
      style: sf_pdf.PdfFontStyle.bold,
    );
    final summaryByField = {
      for (final s in grid.summaries!) s.field: s,
    };
    final rowLabel = GridSummaryUtils.labelForSummaryRow(grid.summaries!);

    var x = 0.0;
    for (var i = 0; i < columns.length; i++) {
      final col = columns[i];
      String text = '';
      if (i == 0) {
        text = rowLabel;
      } else {
        final summary = summaryByField[col.field];
        if (summary != null) {
          final value = GridSummaryUtils.compute(summary, rows);
          text = GridSummaryUtils.format(value, col, config: summary);
        }
      }
      graphics.drawString(
        text,
        font,
        bounds: Rect.fromLTWH(x + 4, y + 3, colWidths[i] - 8, _rowHeight),
        format: _pdfAlignment(col.alignment),
      );
      x += colWidths[i];
    }
  }

  static sf_pdf.PdfStringFormat _pdfAlignment(ColumnAlignment alignment) {
    return sf_pdf.PdfStringFormat(
      alignment: switch (alignment) {
        ColumnAlignment.left => sf_pdf.PdfTextAlignment.left,
        ColumnAlignment.center => sf_pdf.PdfTextAlignment.center,
        ColumnAlignment.right => sf_pdf.PdfTextAlignment.right,
      },
    );
  }

  static String _formatValue(dynamic value, GridColumnDefinition colDef) {
    if (value == null) return '';
    if (colDef.formatString != null && value is num) {
      try {
        return NumberFormat(colDef.formatString).format(value);
      } catch (_) {
        return value.toString();
      }
    }
    if (colDef.columnType == ColumnType.numeric && value is num) {
      return NumberFormat('#,##0.##').format(value);
    }
    if (colDef.columnType == ColumnType.date) {
      if (value is String) {
        try {
          return DateFormat('M/d/yyyy').format(DateTime.parse(value));
        } catch (_) {
          return value;
        }
      }
      if (value is DateTime) {
        return DateFormat('M/d/yyyy').format(value);
      }
    }
    return value.toString();
  }

  static String _csvEscape(String text) {
    if (text.contains(',') || text.contains('"') || text.contains('\n')) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }
}

class _ChartExportColumn {
  final String field;
  final String title;
  final bool isNumeric;

  const _ChartExportColumn({
    required this.field,
    required this.title,
    required this.isNumeric,
  });
}
