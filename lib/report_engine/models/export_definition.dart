import 'package:equatable/equatable.dart';

import 'enums.dart';

class ExportDefinition extends Equatable {
  final List<ExportFormat> formats;
  final String? fileName;
  final String? title;
  final bool includeFilters;
  final bool includeTimestamp;
  final PageOrientation orientation;
  final ExportPageSize pageSize;
  final ExportMargins margins;
  final ExportHeaderConfig? header;
  final ExportFooterConfig? footer;

  const ExportDefinition({
    this.formats = const [
      ExportFormat.pdf,
      ExportFormat.excel,
      ExportFormat.csv,
      ExportFormat.print,
      ExportFormat.image,
    ],
    this.fileName,
    this.title,
    this.includeFilters = true,
    this.includeTimestamp = true,
    this.orientation = PageOrientation.landscape,
    this.pageSize = ExportPageSize.a4,
    this.margins = const ExportMargins(),
    this.header,
    this.footer,
  });

  @override
  List<Object?> get props => [
        formats, fileName, title, includeFilters, includeTimestamp,
        orientation, pageSize, margins, header, footer,
      ];
}

enum PageOrientation { portrait, landscape }

enum ExportPageSize { a4, a3, letter, legal, tabloid }

class ExportMargins extends Equatable {
  final double top;
  final double right;
  final double bottom;
  final double left;

  const ExportMargins({
    this.top = 40,
    this.right = 40,
    this.bottom = 40,
    this.left = 40,
  });

  @override
  List<Object?> get props => [top, right, bottom, left];
}

class ExportHeaderConfig extends Equatable {
  final bool showCompanyName;
  final String? companyName;
  final bool showLogo;
  final String? logoPath;
  final bool showReportTitle;
  final bool showDate;

  const ExportHeaderConfig({
    this.showCompanyName = true,
    this.companyName,
    this.showLogo = false,
    this.logoPath,
    this.showReportTitle = true,
    this.showDate = true,
  });

  @override
  List<Object?> get props => [
        showCompanyName, companyName, showLogo, logoPath,
        showReportTitle, showDate,
      ];
}

class ExportFooterConfig extends Equatable {
  final bool showPageNumber;
  final bool showTotalPages;
  final bool showDate;
  final String? customText;

  const ExportFooterConfig({
    this.showPageNumber = true,
    this.showTotalPages = true,
    this.showDate = true,
    this.customText,
  });

  @override
  List<Object?> get props => [showPageNumber, showTotalPages, showDate, customText];
}
