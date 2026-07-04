import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf_pdf;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../models/models.dart';

abstract final class PivotExportService {
  static final _numFmt = NumberFormat('#,##0.##');

  static String _baseName(String? reportName) {
    final name = (reportName ?? 'Pivot_Report')
        .replaceAll(RegExp(r'[^\w\-]+'), '_');
    final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${name}_$ts';
  }

  static Future<String> exportExcel(PivotResult result, {String? reportName}) async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Pivot Report';

    final allColumns = [...result.rowHeaders, ...result.columnHeaders];
    final rowHeaderCount = result.rowHeaders.length;

    for (var c = 0; c < allColumns.length; c++) {
      final cell = sheet.getRangeByIndex(1, c + 1);
      cell.setText(allColumns[c]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#4472C4';
      cell.cellStyle.fontColor = '#FFFFFF';
    }

    var rowIndex = 2;
    for (final row in result.rows) {
      rowIndex = _writeRow(sheet, row, allColumns, rowHeaderCount, rowIndex, 0);
    }

    for (var c = 0; c < allColumns.length; c++) {
      final cell = sheet.getRangeByIndex(rowIndex, c + 1);
      if (c < rowHeaderCount) {
        cell.setText(c == 0 ? 'Grand Total' : '');
        cell.cellStyle.bold = true;
      } else {
        final value = result.grandTotals[allColumns[c]];
        if (value != null) {
          cell.setNumber(value);
          cell.cellStyle.bold = true;
          cell.numberFormat = '#,##0.00';
        }
      }
    }

    for (var c = 1; c <= allColumns.length; c++) {
      sheet.autoFitColumn(c);
    }

    final bytes = workbook.saveAsStream();
    workbook.dispose();

    return FileSaver.instance.saveFile(
      name: _baseName(reportName),
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }

  static int _writeRow(
    xlsio.Worksheet sheet,
    PivotResultRow row,
    List<String> allColumns,
    int rowHeaderCount,
    int rowIndex,
    int depth,
  ) {
    for (var c = 0; c < allColumns.length; c++) {
      final cell = sheet.getRangeByIndex(rowIndex, c + 1);
      if (c < rowHeaderCount) {
        final key = row.keys[allColumns[c]] ?? (c == 0 ? row.displayKey : '');
        cell.setText('${'  ' * depth}$key');
      } else {
        final value = row.values[allColumns[c]];
        if (value != null) {
          cell.setNumber(value);
          cell.numberFormat = '#,##0.00';
        }
      }
    }
    rowIndex++;

    if (row.children != null) {
      for (final child in row.children!) {
        rowIndex = _writeRow(sheet, child, allColumns, rowHeaderCount, rowIndex, depth + 1);
      }
    }

    return rowIndex;
  }

  static Future<String> exportCsv(PivotResult result, {String? reportName}) async {
    final buffer = StringBuffer();
    final allColumns = [...result.rowHeaders, ...result.columnHeaders];
    final rowHeaderCount = result.rowHeaders.length;

    buffer.writeln(allColumns.map(_escapeCsv).join(','));

    for (final row in result.rows) {
      _writeCsvRow(buffer, row, allColumns, rowHeaderCount, 0);
    }

    final grandTotals = <String>[];
    for (var c = 0; c < allColumns.length; c++) {
      if (c < rowHeaderCount) {
        grandTotals.add(c == 0 ? 'Grand Total' : '');
      } else {
        final value = result.grandTotals[allColumns[c]];
        grandTotals.add(value != null ? _numFmt.format(value) : '');
      }
    }
    buffer.writeln(grandTotals.map(_escapeCsv).join(','));

    return FileSaver.instance.saveFile(
      name: _baseName(reportName),
      bytes: Uint8List.fromList(utf8.encode(buffer.toString())),
      fileExtension: 'csv',
      mimeType: MimeType.csv,
    );
  }

  static void _writeCsvRow(
    StringBuffer buffer,
    PivotResultRow row,
    List<String> allColumns,
    int rowHeaderCount,
    int depth,
  ) {
    final cells = <String>[];
    for (var c = 0; c < allColumns.length; c++) {
      if (c < rowHeaderCount) {
        final key = row.keys[allColumns[c]] ?? (c == 0 ? row.displayKey : '');
        cells.add('${'  ' * depth}$key');
      } else {
        final value = row.values[allColumns[c]];
        cells.add(value != null ? _numFmt.format(value) : '');
      }
    }
    buffer.writeln(cells.map(_escapeCsv).join(','));

    if (row.children != null) {
      for (final child in row.children!) {
        _writeCsvRow(buffer, child, allColumns, rowHeaderCount, depth + 1);
      }
    }
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static Future<void> exportPdf(PivotResult result, {String? reportName}) async {
    final document = sf_pdf.PdfDocument();
    final page = document.pages.add();
    final graphics = page.graphics;

    final titleFont = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica, 16, style: sf_pdf.PdfFontStyle.bold,
    );
    final headerFont = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica, 9, style: sf_pdf.PdfFontStyle.bold,
    );
    final cellFont = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 8);

    graphics.drawString(
      reportName ?? 'Pivot Report',
      titleFont,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 30),
    );

    final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
    final dateFont = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 8);
    graphics.drawString(
      dateStr,
      dateFont,
      bounds: Rect.fromLTWH(0, 20, page.getClientSize().width, 15),
      format: sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.right),
    );

    final allColumns = [...result.rowHeaders, ...result.columnHeaders];
    final colCount = allColumns.length;
    final colWidth = (page.getClientSize().width) / colCount;
    var y = 50.0;
    const rowHeight = 18.0;

    final headerBrush = sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(68, 114, 196));
    final headerTextBrush = sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(255, 255, 255));
    final totalBrush = sf_pdf.PdfSolidBrush(sf_pdf.PdfColor(220, 230, 241));

    for (var c = 0; c < colCount; c++) {
      graphics.drawRectangle(
        brush: headerBrush,
        bounds: Rect.fromLTWH(c * colWidth, y, colWidth, rowHeight),
      );
      graphics.drawString(
        allColumns[c],
        headerFont,
        brush: headerTextBrush,
        bounds: Rect.fromLTWH(c * colWidth + 4, y + 3, colWidth - 8, rowHeight),
      );
    }
    y += rowHeight;

    for (final row in result.rows) {
      y = _drawPdfRow(graphics, row, allColumns, result.rowHeaders.length,
          colWidth, y, rowHeight, cellFont, 0);
    }

    for (var c = 0; c < colCount; c++) {
      graphics.drawRectangle(
        brush: totalBrush,
        bounds: Rect.fromLTWH(c * colWidth, y, colWidth, rowHeight),
      );
      final text = c < result.rowHeaders.length
          ? (c == 0 ? 'Grand Total' : '')
          : (result.grandTotals[allColumns[c]] != null
              ? _numFmt.format(result.grandTotals[allColumns[c]]!)
              : '');
      graphics.drawString(
        text,
        headerFont,
        bounds: Rect.fromLTWH(c * colWidth + 4, y + 3, colWidth - 8, rowHeight),
        format: c >= result.rowHeaders.length
            ? sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.right)
            : null,
      );
    }

    final bytes = Uint8List.fromList(await document.save());
    document.dispose();

    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: reportName ?? 'Pivot Report',
    );
  }

  static double _drawPdfRow(
    sf_pdf.PdfGraphics graphics,
    PivotResultRow row,
    List<String> allColumns,
    int rowHeaderCount,
    double colWidth,
    double y,
    double rowHeight,
    sf_pdf.PdfFont font,
    int depth,
  ) {
    final pen = sf_pdf.PdfPen(sf_pdf.PdfColor(220, 220, 220));

    for (var c = 0; c < allColumns.length; c++) {
      graphics.drawRectangle(
        pen: pen,
        bounds: Rect.fromLTWH(c * colWidth, y, colWidth, rowHeight),
      );

      String text;
      sf_pdf.PdfStringFormat? format;

      if (c < rowHeaderCount) {
        final key = row.keys[allColumns[c]] ?? (c == 0 ? row.displayKey : '');
        text = '${'  ' * depth}$key';
      } else {
        final value = row.values[allColumns[c]];
        text = value != null ? _numFmt.format(value) : '-';
        format = sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.right);
      }

      graphics.drawString(
        text,
        font,
        bounds: Rect.fromLTWH(c * colWidth + 4, y + 3, colWidth - 8, rowHeight),
        format: format,
      );
    }
    y += rowHeight;

    if (row.children != null) {
      for (final child in row.children!) {
        y = _drawPdfRow(graphics, child, allColumns, rowHeaderCount,
            colWidth, y, rowHeight, font, depth + 1);
      }
    }

    return y;
  }

  static Future<void> printReport(PivotResult result, {String? reportName}) async {
    await exportPdf(result, reportName: reportName);
  }
}
