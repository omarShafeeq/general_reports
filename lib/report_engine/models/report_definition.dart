import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'card_definition.dart';
import 'chart_definition.dart';
import 'enums.dart';
import 'export_definition.dart';
import 'filter_definition.dart';
import 'grid_definition.dart';
import 'layout_definition.dart';
import 'section_definition.dart';
import 'toolbar_definition.dart';

class ReportDefinition extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final List<String> permissions;
  final String datasource;
  final List<FilterDefinition> filters;
  final List<ChartDefinition> charts;
  final List<GridDefinition> grids;
  final List<CardDefinition> cards;
  final List<SectionDefinition> sections;
  final ExportDefinition exportOptions;
  final ToolbarDefinition toolbar;
  final LayoutDefinition? layout;
  final ReportViewMode viewMode;
  final Map<String, dynamic> metadata;

  const ReportDefinition({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'General',
    this.icon = Icons.assessment,
    this.permissions = const [],
    this.datasource = '',
    this.filters = const [],
    this.charts = const [],
    this.grids = const [],
    this.cards = const [],
    this.sections = const [],
    this.exportOptions = const ExportDefinition(),
    this.toolbar = const ToolbarDefinition(),
    this.layout,
    this.viewMode = ReportViewMode.dashboard,
    this.metadata = const {},
  });

  bool get isDashboard =>
      viewMode == ReportViewMode.dashboard && layout != null;

  bool get isDocumentView => viewMode == ReportViewMode.document;

  ChartDefinition? chartById(String id) =>
      charts.where((c) => c.id == id).firstOrNull;

  GridDefinition? gridById(String id) =>
      grids.where((g) => g.id == id).firstOrNull;

  CardDefinition? cardById(String id) =>
      cards.where((c) => c.id == id).firstOrNull;

  @override
  List<Object?> get props => [
        id, title, description, category, icon, permissions,
        datasource, filters, charts, grids, cards, sections,
        exportOptions, toolbar, layout, viewMode, metadata,
      ];
}
