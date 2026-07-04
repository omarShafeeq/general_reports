import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/enums.dart';
import '../models/grid_definition.dart';
import '../models/report_definition.dart';

class GridRuntimeSettings extends Equatable {
  final Set<String> visibleColumns;
  final Set<String> summaryColumns;
  final GridSummaryPlacement summaryPlacement;

  const GridRuntimeSettings({
    required this.visibleColumns,
    required this.summaryColumns,
    this.summaryPlacement = GridSummaryPlacement.footer,
  });

  GridRuntimeSettings copyWith({
    Set<String>? visibleColumns,
    Set<String>? summaryColumns,
    GridSummaryPlacement? summaryPlacement,
  }) {
    return GridRuntimeSettings(
      visibleColumns: visibleColumns ?? this.visibleColumns,
      summaryColumns: summaryColumns ?? this.summaryColumns,
      summaryPlacement: summaryPlacement ?? this.summaryPlacement,
    );
  }

  @override
  List<Object?> get props => [
        visibleColumns,
        summaryColumns,
        summaryPlacement,
      ];
}

class GridViewSettingsState extends Equatable {
  final Map<String, GridRuntimeSettings> settings;

  const GridViewSettingsState({this.settings = const {}});

  GridRuntimeSettings? forGrid(String gridId) => settings[gridId];

  GridViewSettingsState copyWith({
    Map<String, GridRuntimeSettings>? settings,
  }) {
    return GridViewSettingsState(settings: settings ?? this.settings);
  }

  @override
  List<Object?> get props => [settings];
}

class GridViewSettingsCubit extends Cubit<GridViewSettingsState> {
  GridViewSettingsCubit() : super(const GridViewSettingsState());

  void initFromReport(ReportDefinition report) {
    final next = <String, GridRuntimeSettings>{};
    for (final grid in report.grids) {
      if (grid.displayOptions?.hasOptions == true) {
        next[grid.id] = _defaultSettings(grid);
      }
    }
    emit(GridViewSettingsState(settings: next));
  }

  GridRuntimeSettings _defaultSettings(GridDefinition grid) {
    final visible = grid.columns
        .where((c) => c.visible)
        .map((c) => c.field)
        .toSet();

    final summaryFields = grid.summaries?.map((s) => s.field).toSet() ??
        _summarizableFields(grid).toSet();

    return GridRuntimeSettings(
      visibleColumns: visible,
      summaryColumns: summaryFields,
      summaryPlacement: grid.displayOptions?.defaultSummaryPlacement ??
          GridSummaryPlacement.footer,
    );
  }

  List<String> _summarizableFields(GridDefinition grid) {
    final opts = grid.displayOptions;
    if (opts?.summarizableFields != null) {
      return opts!.summarizableFields!;
    }
    return grid.columns
        .where((c) => c.columnType == ColumnType.numeric)
        .map((c) => c.field)
        .toList();
  }

  void toggleColumnVisibility(String gridId, String field) {
    final current = state.settings[gridId];
    if (current == null) return;

    final visible = Set<String>.from(current.visibleColumns);
    if (visible.contains(field)) {
      if (visible.length <= 1) return;
      visible.remove(field);
    } else {
      visible.add(field);
    }

    _update(gridId, current.copyWith(visibleColumns: visible));
  }

  void setColumnVisible(String gridId, String field, bool isVisible) {
    final current = state.settings[gridId];
    if (current == null) return;

    final visible = Set<String>.from(current.visibleColumns);
    if (isVisible) {
      visible.add(field);
    } else if (visible.length > 1) {
      visible.remove(field);
    }

    _update(gridId, current.copyWith(visibleColumns: visible));
  }

  void toggleSummaryColumn(String gridId, String field) {
    final current = state.settings[gridId];
    if (current == null) return;

    final summaries = Set<String>.from(current.summaryColumns);
    if (summaries.contains(field)) {
      summaries.remove(field);
    } else {
      summaries.add(field);
    }

    _update(gridId, current.copyWith(summaryColumns: summaries));
  }

  void setSummaryColumn(String gridId, String field, bool enabled) {
    final current = state.settings[gridId];
    if (current == null) return;

    final summaries = Set<String>.from(current.summaryColumns);
    if (enabled) {
      summaries.add(field);
    } else {
      summaries.remove(field);
    }

    _update(gridId, current.copyWith(summaryColumns: summaries));
  }

  void setSummaryPlacement(
    String gridId,
    GridSummaryPlacement placement,
  ) {
    final current = state.settings[gridId];
    if (current == null) return;
    _update(gridId, current.copyWith(summaryPlacement: placement));
  }

  GridSummaryPlacement summaryPlacementFor(
    GridDefinition grid,
    GridRuntimeSettings? runtime,
  ) {
    if (runtime == null) {
      return grid.displayOptions?.defaultSummaryPlacement ??
          GridSummaryPlacement.footer;
    }
    return runtime.summaryPlacement;
  }

  bool showSummaryInFooter(
    GridDefinition grid,
    GridRuntimeSettings? runtime,
  ) {
    final placement = summaryPlacementFor(grid, runtime);
    return placement == GridSummaryPlacement.footer ||
        placement == GridSummaryPlacement.both;
  }

  bool showSummaryInHeader(
    GridDefinition grid,
    GridRuntimeSettings? runtime,
  ) {
    if (grid.displayOptions?.allowSummaryInHeader != true) return false;
    final placement = summaryPlacementFor(grid, runtime);
    return placement == GridSummaryPlacement.header ||
        placement == GridSummaryPlacement.both;
  }

  void _update(String gridId, GridRuntimeSettings settings) {
    final next = Map<String, GridRuntimeSettings>.from(state.settings);
    next[gridId] = settings;
    emit(state.copyWith(settings: next));
  }

  List<GridColumnDefinition> visibleColumnsFor(
    GridDefinition grid,
    GridRuntimeSettings? runtime,
  ) {
    if (runtime == null) {
      return grid.columns.where((c) => c.visible).toList();
    }
    return grid.columns
        .where((c) => runtime.visibleColumns.contains(c.field))
        .toList();
  }

  List<GridSummaryConfig> summariesFor(
    GridDefinition grid,
    GridRuntimeSettings? runtime,
  ) {
    if (runtime == null) {
      return grid.summaries ?? const [];
    }

    final dynamicPicker = grid.displayOptions?.showSummaryPicker == true;

    if (dynamicPicker && runtime.summaryColumns.isEmpty) {
      return const [];
    }

    if (!dynamicPicker && runtime.summaryColumns.isEmpty) {
      return grid.summaries ?? const [];
    }

    final label = grid.displayOptions?.summaryRowLabel ?? 'Total';
    final selectedFields = dynamicPicker
        ? runtime.summaryColumns
        : runtime.summaryColumns.isNotEmpty
            ? runtime.summaryColumns
            : (grid.summaries?.map((s) => s.field).toSet() ?? {});

    return visibleColumnsFor(grid, runtime)
        .where((col) => selectedFields.contains(col.field))
        .map((col) {
          final existing =
              grid.summaries?.where((s) => s.field == col.field).firstOrNull;
          return GridSummaryConfig(
            field: col.field,
            type: existing?.type ?? 'sum',
            title: existing?.title ?? label,
          );
        })
        .toList();
  }

  List<GridColumnDefinition> summarizableColumnsFor(
    GridDefinition grid, {
    GridRuntimeSettings? runtime,
  }) {
    final candidates = _allSummarizableColumns(grid);
    if (runtime == null) return candidates;
    return candidates
        .where((c) => runtime.visibleColumns.contains(c.field))
        .toList();
  }

  List<GridColumnDefinition> _allSummarizableColumns(GridDefinition grid) {
    final opts = grid.displayOptions;
    if (opts?.summarizableFields != null) {
      final allowed = opts!.summarizableFields!.toSet();
      return grid.columns.where((c) => allowed.contains(c.field)).toList();
    }
    return grid.columns
        .where((c) => c.columnType == ColumnType.numeric)
        .toList();
  }

  /// Selected summary fields that are currently visible (for toolbar display).
  Set<String> activeSummaryFieldsFor(
    GridDefinition grid,
    GridRuntimeSettings? runtime,
  ) {
    if (runtime == null) return {};
    return summariesFor(grid, runtime).map((s) => s.field).toSet();
  }
}
