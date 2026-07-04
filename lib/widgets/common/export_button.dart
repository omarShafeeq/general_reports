import 'package:flutter/material.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
import 'package:general_reports/l10n/app_localizations.dart';

enum ExportType { pdf, excel, image, print }

class ExportButton extends StatelessWidget {
  final void Function(ExportType type) onExport;
  final List<ExportType> supportedTypes;

  const ExportButton({
    super.key,
    required this.onExport,
    this.supportedTypes = const [ExportType.pdf, ExportType.excel, ExportType.image],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<ExportType>(
      icon: const Icon(Icons.file_download_outlined),
      tooltip: l10n.export,
      onSelected: onExport,
      itemBuilder: (context) {
        return supportedTypes.map((type) {
          return PopupMenuItem(
            value: type,
            child: Row(
              children: [
                Icon(_iconFor(type), size: 20),
                const SizedBox(width: 12),
                Text(_labelFor(type, l10n)),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  IconData _iconFor(ExportType type) => switch (type) {
        ExportType.pdf => Icons.picture_as_pdf,
        ExportType.excel => Icons.table_chart,
        ExportType.image => Icons.image,
        ExportType.print => Icons.print,
      };

  String _labelFor(ExportType type, AppLocalizations l10n) => switch (type) {
        ExportType.pdf => l10n.exportPdf,
        ExportType.excel => l10n.exportExcel,
        ExportType.image => l10n.saveAsImage,
        ExportType.print => l10n.printLabel,
      };
}
