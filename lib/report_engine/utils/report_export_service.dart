import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' show Offset, Rect, Size;

import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf_pdf;

import '../models/export_definition.dart';
import '../models/report_definition.dart';

abstract final class ReportExportService {
  static String buildBaseName(ReportDefinition report) {
    final configured = report.exportOptions.fileName?.trim();
    final base = (configured?.isNotEmpty == true ? configured! : report.id)
        .replaceAll(RegExp(r'[^\w\-]+'), '_');

    if (!report.exportOptions.includeTimestamp) return base;

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${base}_$timestamp';
  }

  static Future<String> savePdf(
    List<int> bytes, {
    required ReportDefinition report,
  }) {
    return FileSaver.instance.saveFile(
      name: buildBaseName(report),
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  static Future<String> saveExcel(
    List<int> bytes, {
    required ReportDefinition report,
  }) {
    return FileSaver.instance.saveFile(
      name: buildBaseName(report),
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }

  static Future<String> saveCsv(
    String content, {
    required ReportDefinition report,
  }) {
    return FileSaver.instance.saveFile(
      name: buildBaseName(report),
      bytes: Uint8List.fromList(utf8.encode(content)),
      fileExtension: 'csv',
      mimeType: MimeType.csv,
    );
  }

  static Future<String> saveImage(
    List<int> bytes, {
    required ReportDefinition report,
  }) {
    return FileSaver.instance.saveFile(
      name: buildBaseName(report),
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'png',
      mimeType: MimeType.png,
    );
  }

  static Future<void> printPdf(
    List<int> bytes, {
    required ReportDefinition report,
  }) {
    final title = report.exportOptions.title ?? report.title;
    return Printing.layoutPdf(
      onLayout: (_) async => Uint8List.fromList(bytes),
      name: title,
    );
  }

  static Future<void> printWithHeaderFooter({
    required List<int> contentBytes,
    required ReportDefinition report,
  }) async {
    final exportDef = report.exportOptions;
    final pageSize = mapPageSize(exportDef.pageSize);
    final isLandscape = exportDef.orientation == PageOrientation.landscape;

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

    final headerCfg = exportDef.header;
    final footerCfg = exportDef.footer;

    if (headerCfg != null) {
      section.template.top = buildHeaderTemplate(
        headerCfg,
        report,
        section.pageSettings,
      );
    }

    if (footerCfg != null) {
      section.template.bottom = buildFooterTemplate(
        footerCfg,
        section.pageSettings,
      );
    }

    final page = section.pages.add();
    final font = sf_pdf.PdfStandardFont(
      sf_pdf.PdfFontFamily.helvetica,
      10,
    );
    page.graphics.drawString(
      report.title,
      font,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 20),
    );

    final pdfBytes = Uint8List.fromList(await document.save());
    document.dispose();

    await Printing.layoutPdf(
      onLayout: (_) async => pdfBytes,
      name: report.exportOptions.title ?? report.title,
    );
  }

  static sf_pdf.PdfPageTemplateElement buildHeaderTemplate(
    ExportHeaderConfig config,
    ReportDefinition report,
    sf_pdf.PdfPageSettings pageSettings,
  ) {
    final width = pageSettings.size.width - pageSettings.margins.left - pageSettings.margins.right;
    const height = 50.0;
    final template = sf_pdf.PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, width, height),
    );

    final font = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 12);
    final smallFont = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 8);
    double x = 0;

    if (config.showCompanyName) {
      final companyName = config.companyName ?? 'Enterprise Reports';
      final boldFont = sf_pdf.PdfStandardFont(
        sf_pdf.PdfFontFamily.helvetica,
        14,
        style: sf_pdf.PdfFontStyle.bold,
      );
      template.graphics.drawString(
        companyName,
        boldFont,
        bounds: Rect.fromLTWH(x, 0, width, 20),
      );
    }

    if (config.showReportTitle) {
      template.graphics.drawString(
        report.title,
        font,
        bounds: Rect.fromLTWH(x, 20, width, 15),
      );
    }

    if (config.showDate) {
      final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
      template.graphics.drawString(
        dateStr,
        smallFont,
        bounds: Rect.fromLTWH(x, 36, width, 12),
        format: sf_pdf.PdfStringFormat(alignment: sf_pdf.PdfTextAlignment.right),
      );
    }

    template.graphics.drawLine(
      sf_pdf.PdfPen(sf_pdf.PdfColor(200, 200, 200)),
      Offset(0, height - 2),
      Offset(width, height - 2),
    );

    return template;
  }

  static sf_pdf.PdfPageTemplateElement buildFooterTemplate(
    ExportFooterConfig config,
    sf_pdf.PdfPageSettings pageSettings,
  ) {
    final width = pageSettings.size.width - pageSettings.margins.left - pageSettings.margins.right;
    const height = 30.0;
    final template = sf_pdf.PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, width, height),
    );

    final font = sf_pdf.PdfStandardFont(sf_pdf.PdfFontFamily.helvetica, 8);

    template.graphics.drawLine(
      sf_pdf.PdfPen(sf_pdf.PdfColor(200, 200, 200)),
      Offset(0, 2),
      Offset(width, 2),
    );

    if (config.customText != null) {
      template.graphics.drawString(
        config.customText!,
        font,
        bounds: Rect.fromLTWH(0, 8, width, 12),
      );
    }

    if (config.showDate) {
      final dateStr = DateFormat('MMM dd, yyyy').format(DateTime.now());
      template.graphics.drawString(
        dateStr,
        font,
        bounds: Rect.fromLTWH(0, 8, width / 2, 12),
      );
    }

    if (config.showPageNumber) {
      final pageField = sf_pdf.PdfCompositeField(
        font: font,
        text: config.showTotalPages
            ? 'Page {0} of {1}'
            : 'Page {0}',
        fields: <sf_pdf.PdfAutomaticField>[
          sf_pdf.PdfPageNumberField(font: font),
          if (config.showTotalPages) sf_pdf.PdfPageCountField(font: font),
        ],
      );
      pageField.draw(
        template.graphics,
        Offset(width - 80, 8),
      );
    }

    return template;
  }

  static Size mapPageSize(ExportPageSize size) {
    switch (size) {
      case ExportPageSize.a4:
        return sf_pdf.PdfPageSize.a4;
      case ExportPageSize.a3:
        return sf_pdf.PdfPageSize.a3;
      case ExportPageSize.letter:
        return sf_pdf.PdfPageSize.letter;
      case ExportPageSize.legal:
        return sf_pdf.PdfPageSize.legal;
      case ExportPageSize.tabloid:
        return sf_pdf.PdfPageSize.letter11x17;
    }
  }
}
