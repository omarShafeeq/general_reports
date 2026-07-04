import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/data/report_data_bloc.dart';
import '../blocs/data/report_data_event.dart';
import '../blocs/export_cubit.dart';
import '../blocs/filter/report_filter_bloc.dart';
import '../blocs/report_viewer_settings_cubit.dart';
import '../models/enums.dart';
import '../models/report_definition.dart';
import '../models/toolbar_definition.dart';
import 'export_dialog.dart';

class ReportToolbar extends StatelessWidget {
  final ReportDefinition report;
  final GlobalKey repaintKey;
  final GlobalKey? documentCaptureKey;
  final Map<String, GlobalKey<SfDataGridState>> gridKeys;

  const ReportToolbar({
    super.key,
    required this.report,
    required this.repaintKey,
    this.documentCaptureKey,
    required this.gridKeys,
  });

  ToolbarDefinition get _toolbar => report.toolbar;

  @override
  Widget build(BuildContext context) {
    if (report.isDocumentView) {
      return _DocumentToolbar(
        report: report,
        repaintKey: repaintKey,
        documentCaptureKey: documentCaptureKey,
        gridKeys: gridKeys,
        toolbar: _toolbar,
      );
    }

    return _DashboardToolbar(
      report: report,
      repaintKey: repaintKey,
      documentCaptureKey: documentCaptureKey,
      gridKeys: gridKeys,
      toolbar: _toolbar,
    );
  }
}

void showReportExportDialog(
  BuildContext context, {
  required ReportDefinition report,
  required GlobalKey repaintKey,
  GlobalKey? documentCaptureKey,
  required Map<String, GlobalKey<SfDataGridState>> gridKeys,
}) {
  final exportCubit = context.read<ExportCubit>();
  final dataBloc = context.read<ReportDataBloc>();
  final filterBloc = context.read<ReportFilterBloc>();
  final messenger = ScaffoldMessenger.of(context);

  showDialog(
    context: context,
    builder: (dialogContext) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: exportCubit),
        BlocProvider.value(value: dataBloc),
        BlocProvider.value(value: filterBloc),
      ],
      child: ExportDialog(
        report: report,
        repaintKey: repaintKey,
        documentCaptureKey: documentCaptureKey,
        gridKeys: gridKeys,
        scaffoldMessenger: messenger,
      ),
    ),
  );
}

/// DevExpress-style compact floating toolbar for document reports.
class _DocumentToolbar extends StatelessWidget {
  final ReportDefinition report;
  final GlobalKey repaintKey;
  final GlobalKey? documentCaptureKey;
  final Map<String, GlobalKey<SfDataGridState>> gridKeys;
  final ToolbarDefinition toolbar;

  const _DocumentToolbar({
    required this.report,
    required this.repaintKey,
    this.documentCaptureKey,
    required this.gridKeys,
    required this.toolbar,
  });

  static const _barColor = Color(0xFFF5F5F5);
  static const _borderColor = Color(0xFFD0D0D0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportViewerSettingsCubit, ReportViewerSettingsState>(
      builder: (context, settings) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const BoxDecoration(
            color: _barColor,
            border: Border(
              bottom: BorderSide(color: _borderColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (toolbar.showPageNavigation) ...[
                _DocIconButton(
                  icon: Icons.first_page,
                  tooltip: 'First Page',
                  onPressed: settings.hasPreviousPage
                      ? () => context.read<ReportViewerSettingsCubit>().firstPage()
                      : null,
                ),
                _DocIconButton(
                  icon: Icons.chevron_left,
                  tooltip: 'Previous Page',
                  onPressed: settings.hasPreviousPage
                      ? () => context.read<ReportViewerSettingsCubit>().previousPage()
                      : null,
                ),
                _PageSelector(
                  currentPage: settings.currentPage,
                  totalPages: settings.totalPages,
                ),
                _DocIconButton(
                  icon: Icons.chevron_right,
                  tooltip: 'Next Page',
                  onPressed: settings.hasNextPage
                      ? () => context.read<ReportViewerSettingsCubit>().nextPage()
                      : null,
                ),
                _DocIconButton(
                  icon: Icons.last_page,
                  tooltip: 'Last Page',
                  onPressed: settings.hasNextPage
                      ? () => context.read<ReportViewerSettingsCubit>().lastPage()
                      : null,
                ),
                const _ToolbarSep(),
              ],
              if (toolbar.showSearch)
                _DocIconButton(
                  icon: settings.isSearchVisible ? Icons.search_off : Icons.search,
                  tooltip: 'Search',
                  isActive: settings.isSearchVisible,
                  onPressed: () =>
                      context.read<ReportViewerSettingsCubit>().toggleSearch(),
                ),
              if (toolbar.showZoom) ...[
                _DocIconButton(
                  icon: Icons.remove,
                  tooltip: 'Zoom Out',
                  onPressed: settings.canZoomOut
                      ? () => context.read<ReportViewerSettingsCubit>().zoomOut()
                      : null,
                ),
                _ZoomModeDropdown(fitMode: settings.fitMode),
                _DocIconButton(
                  icon: Icons.add,
                  tooltip: 'Zoom In',
                  onPressed: settings.canZoomIn
                      ? () => context.read<ReportViewerSettingsCubit>().zoomIn()
                      : null,
                ),
                const _ToolbarSep(),
              ],
              if (toolbar.showPrint)
                _DocIconButton(
                  icon: Icons.print_outlined,
                  tooltip: 'Print',
                  onPressed: () => _showExportDialog(context),
                ),
              if (toolbar.showExportPdf ||
                  toolbar.showExportExcel ||
                  toolbar.showExportCsv ||
                  toolbar.showExportImage)
                _DocIconButton(
                  icon: Icons.save_alt_outlined,
                  tooltip: 'Export',
                  onPressed: () => _showExportDialog(context),
                ),
              if (toolbar.showRefresh)
                _DocIconButton(
                  icon: Icons.refresh,
                  tooltip: 'Refresh',
                  onPressed: () => _runReport(context),
                ),
            ],
          ),
        );
      },
    );
  }

  void _runReport(BuildContext context) {
    final filterState = context.read<ReportFilterBloc>().state;
    context.read<ReportDataBloc>().add(
      FetchReportData(
        datasource: report.datasource,
        params: filterState.toQueryParams(),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showReportExportDialog(
      context,
      report: report,
      repaintKey: repaintKey,
      documentCaptureKey: documentCaptureKey,
      gridKeys: gridKeys,
    );
  }
}

class _DashboardToolbar extends StatelessWidget {
  final ReportDefinition report;
  final GlobalKey repaintKey;
  final GlobalKey? documentCaptureKey;
  final Map<String, GlobalKey<SfDataGridState>> gridKeys;
  final ToolbarDefinition toolbar;

  const _DashboardToolbar({
    required this.report,
    required this.repaintKey,
    this.documentCaptureKey,
    required this.gridKeys,
    required this.toolbar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: BlocBuilder<ReportViewerSettingsCubit,
          ReportViewerSettingsState>(
        builder: (context, settings) {
          return Row(
            children: [
              _buildTitleSection(context),
              const Spacer(),
              ..._buildToolbarActions(context, settings),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    final theme = Theme.of(context);
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            report.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (report.description.isNotEmpty)
            Text(
              report.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildToolbarActions(
    BuildContext context,
    ReportViewerSettingsState settings,
  ) {
    final actions = <Widget>[];

    actions.add(FilledButton.tonalIcon(
      icon: const Icon(Icons.play_arrow, size: 18),
      label: const Text('Run'),
      onPressed: () => _runReport(context),
    ));
    actions.add(const SizedBox(width: 4));

    if (toolbar.showRefresh) {
      actions.add(_ToolbarIconButton(
        icon: Icons.refresh,
        tooltip: 'Refresh',
        onPressed: () => _runReport(context),
      ));
    }

    actions.add(const _ToolbarSep());

    if (toolbar.showSearch) {
      actions.add(_ToolbarIconButton(
        icon: settings.isSearchVisible ? Icons.search_off : Icons.search,
        tooltip: 'Search',
        isActive: settings.isSearchVisible,
        onPressed: () =>
            context.read<ReportViewerSettingsCubit>().toggleSearch(),
      ));
    }

    if (toolbar.showZoom) {
      actions.add(_ToolbarIconButton(
        icon: Icons.zoom_out,
        tooltip: 'Zoom Out',
        onPressed: settings.canZoomOut
            ? () => context.read<ReportViewerSettingsCubit>().zoomOut()
            : null,
      ));
      actions.add(
        SizedBox(
          width: 52,
          child: Center(
            child: Text(
              settings.zoomPercentage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      );
      actions.add(_ToolbarIconButton(
        icon: Icons.zoom_in,
        tooltip: 'Zoom In',
        onPressed: settings.canZoomIn
            ? () => context.read<ReportViewerSettingsCubit>().zoomIn()
            : null,
      ));
    }

    if (toolbar.showFitWidth || toolbar.showFitPage) {
      actions.add(const _ToolbarSep());
    }

    if (toolbar.showFitWidth) {
      actions.add(_ToolbarIconButton(
        icon: Icons.fit_screen,
        tooltip: 'Fit Width',
        onPressed: () =>
            context.read<ReportViewerSettingsCubit>().fitWidth(),
      ));
    }

    if (toolbar.showFitPage) {
      actions.add(_ToolbarIconButton(
        icon: Icons.fullscreen,
        tooltip: 'Fit Page',
        onPressed: () =>
            context.read<ReportViewerSettingsCubit>().fitPage(),
      ));
    }

    if (toolbar.showPageNavigation) {
      actions.add(const _ToolbarSep());
      actions.add(_ToolbarIconButton(
        icon: Icons.first_page,
        tooltip: 'First Page',
        onPressed: settings.hasPreviousPage
            ? () => context.read<ReportViewerSettingsCubit>().firstPage()
            : null,
      ));
      actions.add(_ToolbarIconButton(
        icon: Icons.chevron_left,
        tooltip: 'Previous Page',
        onPressed: settings.hasPreviousPage
            ? () => context.read<ReportViewerSettingsCubit>().previousPage()
            : null,
      ));
      actions.add(
        SizedBox(
          width: 64,
          child: Center(
            child: Text(
              '${settings.currentPage} / ${settings.totalPages}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      );
      actions.add(_ToolbarIconButton(
        icon: Icons.chevron_right,
        tooltip: 'Next Page',
        onPressed: settings.hasNextPage
            ? () => context.read<ReportViewerSettingsCubit>().nextPage()
            : null,
      ));
      actions.add(_ToolbarIconButton(
        icon: Icons.last_page,
        tooltip: 'Last Page',
        onPressed: settings.hasNextPage
            ? () => context.read<ReportViewerSettingsCubit>().lastPage()
            : null,
      ));
    }

    actions.add(const _ToolbarSep());

    if (toolbar.showPrint) {
      actions.add(_ToolbarIconButton(
        icon: Icons.print,
        tooltip: 'Print',
        onPressed: () => _showExportDialog(context),
      ));
    }

    if (toolbar.showExportPdf || toolbar.showExportExcel ||
        toolbar.showExportCsv || toolbar.showExportImage) {
      actions.add(_ToolbarIconButton(
        icon: Icons.file_download,
        tooltip: 'Export',
        onPressed: () => _showExportDialog(context),
      ));
    }

    if (toolbar.showFullscreen) {
      actions.add(_ToolbarIconButton(
        icon: settings.isFullscreen
            ? Icons.fullscreen_exit
            : Icons.fullscreen,
        tooltip: settings.isFullscreen ? 'Exit Fullscreen' : 'Fullscreen',
        onPressed: () =>
            context.read<ReportViewerSettingsCubit>().toggleFullscreen(),
      ));
    }

    return actions;
  }

  void _runReport(BuildContext context) {
    final filterState = context.read<ReportFilterBloc>().state;
    context.read<ReportDataBloc>().add(
      FetchReportData(
        datasource: report.datasource,
        params: filterState.toQueryParams(),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showReportExportDialog(
      context,
      report: report,
      repaintKey: repaintKey,
      documentCaptureKey: documentCaptureKey,
      gridKeys: gridKeys,
    );
  }
}

class _PageSelector extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageSelector({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD0D0D0)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: currentPage.clamp(1, totalPages),
          isDense: true,
          style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
          items: List.generate(totalPages, (i) {
            final page = i + 1;
            return DropdownMenuItem(
              value: page,
              child: Text('$page of $totalPages'),
            );
          }),
          onChanged: (page) {
            if (page != null) {
              context.read<ReportViewerSettingsCubit>().setPage(page);
            }
          },
        ),
      ),
    );
  }
}

class _ZoomModeDropdown extends StatelessWidget {
  final FitMode fitMode;

  const _ZoomModeDropdown({required this.fitMode});

  String get _label {
    switch (fitMode) {
      case FitMode.fitPage:
        return 'Whole Page';
      case FitMode.fitWidth:
        return 'Page Width';
      case FitMode.none:
        return 'Actual Size';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD0D0D0)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FitMode>(
          value: fitMode,
          isDense: true,
          style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
          items: const [
            DropdownMenuItem(value: FitMode.fitPage, child: Text('Whole Page')),
            DropdownMenuItem(value: FitMode.fitWidth, child: Text('Page Width')),
            DropdownMenuItem(value: FitMode.none, child: Text('Actual Size')),
          ],
          onChanged: (mode) {
            if (mode == null) return;
            final cubit = context.read<ReportViewerSettingsCubit>();
            switch (mode) {
              case FitMode.fitPage:
                cubit.fitPage();
              case FitMode.fitWidth:
                cubit.fitWidth();
              case FitMode.none:
                cubit.setZoom(1.0);
            }
          },
          selectedItemBuilder: (context) => List.generate(
            3,
            (_) => Center(
              child: Text(
                _label,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  const _DocIconButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 28,
      child: IconButton(
        icon: Icon(icon, size: 18),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: isActive ? const Color(0xFFE0E0E0) : null,
          foregroundColor: onPressed == null
              ? const Color(0xFFBDBDBD)
              : const Color(0xFF616161),
        ),
      ),
    );
  }
}

class _ToolbarSep extends StatelessWidget {
  const _ToolbarSep();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 22,
        child: VerticalDivider(width: 1, thickness: 1, color: Color(0xFFD0D0D0)),
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  const _ToolbarIconButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        icon: Icon(icon, size: 18),
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isActive
              ? theme.colorScheme.secondaryContainer
              : null,
          foregroundColor: isActive
              ? theme.colorScheme.onSecondaryContainer
              : null,
        ),
      ),
    );
  }
}
