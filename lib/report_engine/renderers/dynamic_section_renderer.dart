import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/constants/app_sizes.dart';
import '../data/report_repository.dart';
import '../models/card_definition.dart';
import '../models/chart_definition.dart';
import '../models/enums.dart';
import '../models/grid_definition.dart';
import '../models/report_definition.dart';
import '../models/section_definition.dart';
import '../widgets/document_master_detail_grid.dart';
import 'dynamic_card_renderer.dart';
import 'dynamic_chart_renderer.dart';
import 'dynamic_filter_bar.dart';
import 'dynamic_grid_renderer.dart';

class DynamicSectionRenderer extends StatelessWidget {
  final SectionDefinition section;
  final ReportDefinition report;
  final Map<String, dynamic> data;
  final void Function(Map<String, dynamic> point, String componentId)? onDrillDown;
  final Map<String, GlobalKey<SfDataGridState>>? gridKeys;
  final bool documentMode;
  final ReportRepository? repository;

  const DynamicSectionRenderer({
    super.key,
    required this.section,
    required this.report,
    required this.data,
    this.onDrillDown,
    this.gridKeys,
    this.documentMode = false,
    this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);
    if (content == null) return const SizedBox.shrink();

    if (section.collapsible && section.title != null) {
      return _CollapsibleSection(
        title: section.title!,
        padding: section.padding ?? const EdgeInsets.symmetric(vertical: AppSizes.xs),
        child: content,
      );
    }

    return Padding(
      padding: section.padding ?? const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: content,
    );
  }

  Widget? _buildContent(BuildContext context) {
    switch (section.type) {
      case SectionType.filters:
        if (documentMode) return null;
        return const DynamicFilterBar();

      case SectionType.cards:
        if (documentMode) return null;
        return _buildCards(context);

      case SectionType.charts:
        return _buildCharts(context);

      case SectionType.grids:
        return _buildGrids(context);

      case SectionType.header:
        if (documentMode) return null;
        return _buildHeader(context);

      case SectionType.footer:
        return _buildFooter(context);

      case SectionType.custom:
        return null;
    }
  }

  Widget _buildCards(BuildContext context) {
    final cards = _resolveCards();
    if (cards.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _responsiveColumns(constraints.maxWidth);
        return Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: cards.map((card) {
            final width = (constraints.maxWidth - (cols - 1) * AppSizes.sm) / cols;
            return SizedBox(
              width: width,
              child: DynamicCardRenderer(
                definition: card,
                data: data,
                onTap: card.drillDown != null
                    ? () => onDrillDown?.call(data, card.id)
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCharts(BuildContext context) {
    final charts = _resolveCharts();
    if (charts.isEmpty) return const SizedBox.shrink();

    if (documentMode) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: charts.map((chart) {
          final chartData = data[chart.dataKey];
          final items = chartData is List
              ? chartData.cast<Map<String, dynamic>>()
              : <Map<String, dynamic>>[];
          return DynamicChartRenderer(
            definition: chart,
            data: items,
            documentMode: true,
            onPointTap: chart.drillDown != null
                ? (point) => onDrillDown?.call(point, chart.id)
                : null,
          );
        }).toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _responsiveColumns(constraints.maxWidth);
        return Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: charts.map((chart) {
            final width = (constraints.maxWidth - (cols - 1) * AppSizes.sm) / cols;
            final chartData = data[chart.dataKey];
            final items = chartData is List
                ? chartData.cast<Map<String, dynamic>>()
                : <Map<String, dynamic>>[];
            return SizedBox(
              width: width,
              height: AppSizes.chartMaxHeight,
              child: DynamicChartRenderer(
                definition: chart,
                data: items,
                onPointTap: chart.drillDown != null
                    ? (point) => onDrillDown?.call(point, chart.id)
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildGrids(BuildContext context) {
    final grids = _resolveGrids();
    if (grids.isEmpty) return const SizedBox.shrink();

    if (documentMode && repository != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: grids.map((grid) {
          final gridData = data[grid.dataKey];
          final items = gridData is List
              ? gridData.cast<Map<String, dynamic>>()
              : <Map<String, dynamic>>[];
          return DocumentMasterDetailGrid(
            definition: grid,
            data: items,
            repository: repository!,
          );
        }).toList(),
      );
    }

    return Column(
      children: grids.map((grid) {
        final gridData = data[grid.dataKey];
        final items = gridData is List
            ? gridData.cast<Map<String, dynamic>>()
            : <Map<String, dynamic>>[];
        return SizedBox(
          height: 400,
          child: DynamicGridRenderer(
            definition: grid,
            data: items,
            gridKey: gridKeys?[grid.id],
            onRowTap: grid.drillDown != null
                ? (row) => onDrillDown?.call(row, grid.id)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Text(
        section.title ?? report.title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Text(
        section.title ?? 'Report generated at ${DateTime.now().toString().substring(0, 16)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  int _responsiveColumns(double width) {
    if (section.columns > 1 && width < AppSizes.mobileBreakpoint) return 1;
    if (section.columns > 2 && width < AppSizes.tabletBreakpoint) return 2;
    return section.columns;
  }

  List<CardDefinition> _resolveCards() {
    if (section.childIds.isEmpty) return report.cards;
    return section.childIds
        .map((id) => report.cardById(id))
        .whereType<CardDefinition>()
        .toList();
  }

  List<ChartDefinition> _resolveCharts() {
    if (section.childIds.isEmpty) return report.charts;
    return section.childIds
        .map((id) => report.chartById(id))
        .whereType<ChartDefinition>()
        .toList();
  }

  List<GridDefinition> _resolveGrids() {
    if (section.childIds.isEmpty) return report.grids;
    return section.childIds
        .map((id) => report.gridById(id))
        .whereType<GridDefinition>()
        .toList();
  }
}

class _CollapsibleSection extends StatelessWidget {
  final String title;
  final EdgeInsets padding;
  final Widget child;

  const _CollapsibleSection({
    required this.title,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ExpansionTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        initiallyExpanded: true,
        children: [child],
      ),
    );
  }
}
