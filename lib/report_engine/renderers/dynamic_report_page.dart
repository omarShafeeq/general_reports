import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/data/report_data_bloc.dart';
import '../blocs/data/report_data_state.dart';
import '../blocs/drill_down_cubit.dart';
import '../blocs/report_viewer_settings_cubit.dart';
import '../data/report_repository.dart';
import '../layout/responsive_report_layout.dart';
import '../models/drill_down_definition.dart';
import '../models/enums.dart';
import '../models/report_definition.dart';
import '../widgets/drill_down_breadcrumb.dart';
import '../widgets/report_document_header.dart';
import '../widgets/report_document_viewer.dart';
import '../widgets/report_toolbar.dart';
import 'dynamic_section_renderer.dart';

class DynamicReportPage extends StatefulWidget {
  final ReportDefinition report;
  final ReportRepository repository;

  const DynamicReportPage({
    super.key,
    required this.report,
    required this.repository,
  });

  @override
  State<DynamicReportPage> createState() => _DynamicReportPageState();
}

class _DynamicReportPageState extends State<DynamicReportPage> {
  final _repaintKey = GlobalKey();
  final _documentCaptureKey = GlobalKey();
  final _gridKeys = <String, GlobalKey<SfDataGridState>>{};

  @override
  void initState() {
    super.initState();
    for (final grid in widget.report.grids) {
      _gridKeys[grid.id] = GlobalKey<SfDataGridState>();
    }

    if (widget.report.isDocumentView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final cubit = context.read<ReportViewerSettingsCubit>();
        cubit.fitPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDocument = widget.report.isDocumentView;

    return BlocBuilder<ReportViewerSettingsCubit, ReportViewerSettingsState>(
      builder: (context, settings) {
        return RepaintBoundary(
          key: _repaintKey,
          child: BlocBuilder<ReportDataBloc, ReportDataState>(
            builder: (context, dataState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isDocument) const DrillDownBreadcrumb(),
                  ReportToolbar(
                    report: widget.report,
                    repaintKey: _repaintKey,
                    documentCaptureKey: _documentCaptureKey,
                    gridKeys: _gridKeys,
                  ),
                  if (settings.isSearchVisible)
                    _buildSearchBar(context, settings),
                  Expanded(
                    child: isDocument
                        ? _buildDocumentBody(dataState)
                        : _buildDashboardBody(dataState, settings),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    ReportViewerSettingsState settings,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in report...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSizes.xs,
                  horizontal: AppSizes.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
              onChanged: (value) {
                context
                    .read<ReportViewerSettingsCubit>()
                    .setSearchQuery(value);
              },
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              context.read<ReportViewerSettingsCubit>().toggleSearch();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentBody(ReportDataState dataState) {
    if (dataState.status == ReportDataStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dataState.status == ReportDataStatus.error) {
      return Center(
        child: Text(
          dataState.errorMessage ?? 'Failed to load report data',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    return ReportDocumentViewer(
      documentCaptureKey: _documentCaptureKey,
      child: _buildDocumentContent(dataState),
    );
  }

  Widget _buildDocumentContent(ReportDataState dataState) {
    if (dataState.status == ReportDataStatus.initial) {
      return const SizedBox(
        height: ReportDocumentViewer.pageHeight,
        child: Center(
          child: Text('Apply filters to load report data'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ReportDocumentHeader(report: widget.report),
        ...widget.report.sections.map((section) {
          return DynamicSectionRenderer(
            section: section,
            report: widget.report,
            data: dataState.data,
            gridKeys: _gridKeys,
            onDrillDown: _handleDrillDown,
            documentMode: true,
            repository: widget.repository,
          );
        }),
      ],
    );
  }

  Widget _buildDashboardBody(
    ReportDataState dataState,
    ReportViewerSettingsState settings,
  ) {
    final body = _buildDashboardContent(dataState);

    if (settings.fitMode != FitMode.none || settings.zoomLevel != 1.0) {
      return LayoutBuilder(
        builder: (context, constraints) {
          double scale = settings.zoomLevel;
          if (settings.fitMode == FitMode.fitWidth) {
            scale = 1.0;
          } else if (settings.fitMode == FitMode.fitPage) {
            scale = 1.0;
          }

          return InteractiveViewer(
            minScale: 0.25,
            maxScale: 4.0,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: body,
            ),
          );
        },
      );
    }

    return body;
  }

  Widget _buildDashboardContent(ReportDataState dataState) {
    if (dataState.status == ReportDataStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dataState.status == ReportDataStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              dataState.errorMessage ?? 'Failed to load report data',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
      );
    }

    if (dataState.status == ReportDataStatus.initial) {
      return const Center(
        child: Text('Apply filters to load report data'),
      );
    }

    final sectionWidgets = widget.report.sections.map((section) {
      return DynamicSectionRenderer(
        section: section,
        report: widget.report,
        data: dataState.data,
        gridKeys: _gridKeys,
        onDrillDown: _handleDrillDown,
        repository: widget.repository,
      );
    }).toList();

    if (widget.report.layout != null) {
      return ResponsiveReportLayout(
        layout: widget.report.layout!,
        children: sectionWidgets,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.sm),
      itemCount: sectionWidgets.length,
      itemBuilder: (context, index) => sectionWidgets[index],
    );
  }

  void _handleDrillDown(Map<String, dynamic> pointData, String componentId) {
    DrillDownDefinition? drillDef;

    drillDef ??= widget.report.charts
        .where((c) => c.id == componentId)
        .firstOrNull
        ?.drillDown;
    drillDef ??= widget.report.grids
        .where((g) => g.id == componentId)
        .firstOrNull
        ?.drillDown;
    drillDef ??= widget.report.cards
        .where((c) => c.id == componentId)
        .firstOrNull
        ?.drillDown;

    if (drillDef == null) return;

    final paramValue = pointData[drillDef.paramField];
    final label = drillDef.label?.replaceAll('{value}', paramValue.toString())
        ?? '$paramValue';

    context.read<DrillDownCubit>().push(
      DrillDownLevel(
        reportId: drillDef.targetReportId,
        paramKey: drillDef.paramKey,
        paramValue: paramValue,
        breadcrumbLabel: label,
      ),
    );
  }
}
