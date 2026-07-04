import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/grid_view_settings_cubit.dart';
import '../models/enums.dart';
import '../models/grid_definition.dart';
import '../utils/grid_summary_utils.dart';

/// Toolbar for toggling visible columns and selecting summary (sum) columns.
class GridOptionsToolbar extends StatelessWidget {
  final GridDefinition definition;
  final List<Map<String, dynamic>>? data;

  const GridOptionsToolbar({
    super.key,
    required this.definition,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    final opts = definition.displayOptions;
    if (opts == null || !opts.hasOptions) return const SizedBox.shrink();

    return BlocBuilder<GridViewSettingsCubit, GridViewSettingsState>(
      builder: (context, state) {
        final runtime = state.forGrid(definition.id);
        if (runtime == null) return const SizedBox.shrink();

        final cubit = context.read<GridViewSettingsCubit>();
        final summarizable = cubit.summarizableColumnsFor(
          definition,
          runtime: runtime,
        );
        final activeSummaries = cubit.activeSummaryFieldsFor(definition, runtime);
        final showInHeader = cubit.showSummaryInHeader(definition, runtime);

        return Container(
          margin: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.sm, AppSizes.sm, 0),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (opts.showColumnPicker)
                _ColumnsMenu(
                  definition: definition,
                  runtime: runtime,
                  onToggle: (field, visible) =>
                      cubit.setColumnVisible(definition.id, field, visible),
                ),
              if (opts.showColumnPicker && opts.showSummaryPicker)
                const SizedBox(
                  height: 24,
                  child: VerticalDivider(width: 1),
                ),
              if (opts.showSummaryPicker)
                _SummaryMenu(
                  gridId: definition.id,
                  summarizableColumns: summarizable,
                  runtime: runtime,
                  activeSummaryCount: activeSummaries.length,
                  data: data,
                  onToggle: (field, enabled) =>
                      cubit.setSummaryColumn(definition.id, field, enabled),
                ),
              if (opts.allowSummaryInHeader && opts.showSummaryPicker)
                _SummaryPlacementMenu(
                  placement: runtime.summaryPlacement,
                  onChanged: (placement) => cubit.setSummaryPlacement(
                    definition.id,
                    placement,
                  ),
                ),
              if (opts.showSummaryPicker &&
                  activeSummaries.isNotEmpty &&
                  data != null &&
                  !showInHeader)
                ..._buildLiveTotals(context, definition, runtime, cubit),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildLiveTotals(
    BuildContext context,
    GridDefinition definition,
    GridRuntimeSettings runtime,
    GridViewSettingsCubit cubit,
  ) {
    final theme = Theme.of(context);
    final summaries = cubit.summariesFor(definition, runtime);
    if (summaries.isEmpty) return [];

    return [
      const SizedBox(
        height: 24,
        child: VerticalDivider(width: 1),
      ),
      ...summaries.map((summary) {
        final col = definition.columns
            .where((c) => c.field == summary.field)
            .firstOrNull;
        if (col == null) return const SizedBox.shrink();

        final value = GridSummaryUtils.compute(summary, data!);
        final formatted = GridSummaryUtils.format(value, col, config: summary);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Text(
            '${col.title}: $formatted',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        );
      }),
    ];
  }
}

class _ColumnsMenu extends StatelessWidget {
  final GridDefinition definition;
  final GridRuntimeSettings runtime;
  final void Function(String field, bool visible) onToggle;

  const _ColumnsMenu({
    required this.definition,
    required this.runtime,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCount = runtime.visibleColumns.length;

    return PopupMenuButton<void>(
      tooltip: 'Show columns',
      child: _ToolbarChip(
        icon: Icons.view_column_outlined,
        label: 'Columns ($visibleCount/${definition.columns.length})',
      ),
      itemBuilder: (context) {
        return definition.columns.map((col) {
          final isVisible = runtime.visibleColumns.contains(col.field);
          return PopupMenuItem<void>(
            enabled: isVisible || runtime.visibleColumns.length > 1,
            onTap: () => onToggle(col.field, !isVisible),
            child: Row(
              children: [
                Icon(
                  isVisible
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(child: Text(col.title)),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

class _SummaryMenu extends StatelessWidget {
  final String gridId;
  final List<GridColumnDefinition> summarizableColumns;
  final GridRuntimeSettings runtime;
  final int activeSummaryCount;
  final List<Map<String, dynamic>>? data;
  final void Function(String field, bool enabled) onToggle;

  const _SummaryMenu({
    required this.gridId,
    required this.summarizableColumns,
    required this.runtime,
    required this.activeSummaryCount,
    required this.data,
    required this.onToggle,
  });

  void _openSummarySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<GridViewSettingsCubit>(),
          child: _SummarySheet(
            gridId: gridId,
            summarizableColumns: summarizableColumns,
            data: data,
            onToggle: onToggle,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (summarizableColumns.isEmpty) {
      return const _ToolbarChip(
        icon: Icons.functions,
        label: 'Sum (show numeric columns first)',
      );
    }

    return InkWell(
      onTap: () => _openSummarySheet(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: _ToolbarChip(
        icon: Icons.functions,
        label: 'Sum ($activeSummaryCount active)',
      ),
    );
  }
}

class _SummarySheet extends StatelessWidget {
  final String gridId;
  final List<GridColumnDefinition> summarizableColumns;
  final List<Map<String, dynamic>>? data;
  final void Function(String field, bool enabled) onToggle;

  const _SummarySheet({
    required this.gridId,
    required this.summarizableColumns,
    required this.data,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<GridViewSettingsCubit, GridViewSettingsState>(
      builder: (context, state) {
        final runtime = state.forGrid(gridId);
        if (runtime == null) return const SizedBox.shrink();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md, 0, AppSizes.md, AppSizes.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select columns to sum',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Totals update instantly for visible columns only.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: summarizableColumns.map((col) {
                      final isSelected =
                          runtime.summaryColumns.contains(col.field);
                      final summary = GridSummaryConfig(
                        field: col.field,
                        type: 'sum',
                      );
                      final value = isSelected && data != null
                          ? GridSummaryUtils.compute(summary, data!)
                          : null;
                      final formatted = value != null
                          ? GridSummaryUtils.format(value, col, config: summary)
                          : null;

                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (checked) =>
                            onToggle(col.field, checked ?? false),
                        title: Text(col.title),
                        subtitle: formatted != null
                            ? Text(
                                'Total: $formatted',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : Text(
                                'Column type: ${col.columnType.name}',
                                style: theme.textTheme.bodySmall,
                              ),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryPlacementMenu extends StatelessWidget {
  final GridSummaryPlacement placement;
  final ValueChanged<GridSummaryPlacement> onChanged;

  const _SummaryPlacementMenu({
    required this.placement,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GridSummaryPlacement>(
      tooltip: 'Summary placement',
      onSelected: onChanged,
      itemBuilder: (context) => [
        _placementItem(
          context,
          GridSummaryPlacement.footer,
          Icons.table_rows,
          'Footer row',
        ),
        _placementItem(
          context,
          GridSummaryPlacement.header,
          Icons.view_column,
          'In column header',
        ),
        _placementItem(
          context,
          GridSummaryPlacement.both,
          Icons.view_agenda,
          'Header and footer',
        ),
      ],
      child: _ToolbarChip(
        icon: Icons.place_outlined,
        label: _placementLabel(placement),
      ),
    );
  }

  PopupMenuItem<GridSummaryPlacement> _placementItem(
    BuildContext context,
    GridSummaryPlacement value,
    IconData icon,
    String label,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            placement == value ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSizes.sm),
          Icon(icon, size: 18),
          const SizedBox(width: AppSizes.sm),
          Text(label),
        ],
      ),
    );
  }

  String _placementLabel(GridSummaryPlacement placement) {
    switch (placement) {
      case GridSummaryPlacement.footer:
        return 'Sum in footer';
      case GridSummaryPlacement.header:
        return 'Sum in header';
      case GridSummaryPlacement.both:
        return 'Sum in both';
    }
  }
}

class _ToolbarChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ToolbarChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, size: 20, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
