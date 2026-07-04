import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/context_extensions.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

import '../blocs/pivot_report_cubit.dart';
import '../blocs/pivot_report_state.dart';
import '../data/mock_pivot_repository.dart';
import '../models/models.dart';
import '../utils/pivot_export_service.dart';
import '../widgets/aggregation_selector.dart';
import '../widgets/data_source_selector.dart';
import '../widgets/field_selector_panel.dart';
import '../widgets/pivot_chart.dart';
import '../widgets/pivot_drop_zone.dart';
import '../widgets/pivot_grid.dart';
import '../widgets/pivot_toolbar.dart';
import '../widgets/save_report_dialog.dart';
import '../widgets/saved_reports_dialog.dart';

class PivotReportPage extends StatelessWidget {
  const PivotReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PivotReportCubit(
        repository: MockPivotRepository(),
      )..loadDataSources(),
      child: const _PivotReportView(),
    );
  }
}

class _PivotReportView extends StatelessWidget {
  const _PivotReportView();

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: context.l10n.pageTitle('pivot-reports'),
      currentRoute: 'pivot-reports',
      body: BlocBuilder<PivotReportCubit, PivotReportState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildToolbar(context, state),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, PivotReportState state) {
    final cubit = context.read<PivotReportCubit>();

    return PivotToolbar(
      onExecute: cubit.executeReport,
      onSave: () => _showSaveDialog(context, state),
      onClear: cubit.clearLayout,
      onToggleChart: cubit.toggleChart,
      onLoadReports: () => _showSavedReports(context, cubit),
      onExportExcel: state.hasResult
          ? () => PivotExportService.exportExcel(
                state.result!,
                reportName: state.currentReport?.name,
              )
          : null,
      onExportPdf: state.hasResult
          ? () => PivotExportService.exportPdf(
                state.result!,
                reportName: state.currentReport?.name,
              )
          : null,
      onExportCsv: state.hasResult
          ? () => PivotExportService.exportCsv(
                state.result!,
                reportName: state.currentReport?.name,
              )
          : null,
      onPrint: state.hasResult
          ? () => PivotExportService.printReport(
                state.result!,
                reportName: state.currentReport?.name,
              )
          : null,
      chartType: state.chartType,
      onChartTypeChanged: cubit.setChartType,
      canExecute: state.canExecute,
      isLoading: state.isLoading,
      showChart: state.showChart,
      currentReport: state.currentReport,
    );
  }

  Widget _buildBody(BuildContext context, PivotReportState state) {
    if (context.isMobile) {
      return _buildMobileBody(context, state);
    }
    if (context.isTablet) {
      return _buildTabletBody(context, state);
    }
    return _buildDesktopBody(context, state);
  }

  Widget _buildDesktopBody(BuildContext context, PivotReportState state) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 240,
          child: _buildFieldsSidebar(context, state),
        ),
        VerticalDivider(width: 1, color: theme.colorScheme.outlineVariant),
        Expanded(
          child: Column(
            children: [
              _buildDropZones(context, state, columns: 4),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              Expanded(child: _buildResultArea(context, state)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletBody(BuildContext context, PivotReportState state) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: _buildFieldsSidebar(context, state),
        ),
        VerticalDivider(width: 1, color: theme.colorScheme.outlineVariant),
        Expanded(
          child: Column(
            children: [
              _buildDropZones(context, state, columns: 2),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              Expanded(child: _buildResultArea(context, state)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBody(BuildContext context, PivotReportState state) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: theme.colorScheme.surfaceContainerLow,
            child: const TabBar(
              tabs: [
                Tab(
                  height: 44,
                  icon: Icon(Icons.tune, size: 18),
                  text: 'Layout',
                ),
                Tab(
                  height: 44,
                  icon: Icon(Icons.grid_on, size: 18),
                  text: 'Results',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DataSourceSelector(
                        dataSources: state.dataSources,
                        selected: state.selectedDataSource,
                        onSelected:
                            context.read<PivotReportCubit>().selectDataSource,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      SizedBox(
                        height: 240,
                        child: FieldSelectorPanel(
                          availableFields: state.availableFields,
                          usedFields: [
                            ...state.rowFields,
                            ...state.columnFields,
                          ],
                          usedValues: state.valueFields,
                          onFieldAction: (field, role) =>
                              _handleFieldAction(context, field, role),
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      _buildDropZones(context, state, columns: 1),
                    ],
                  ),
                ),
                _buildResultArea(context, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsSidebar(BuildContext context, PivotReportState state) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        children: [
          DataSourceSelector(
            dataSources: state.dataSources,
            selected: state.selectedDataSource,
            onSelected: context.read<PivotReportCubit>().selectDataSource,
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: FieldSelectorPanel(
              availableFields: state.availableFields,
              usedFields: [...state.rowFields, ...state.columnFields],
              usedValues: state.valueFields,
              onFieldAction: (field, role) =>
                  _handleFieldAction(context, field, role),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropZones(
    BuildContext context,
    PivotReportState state, {
    required int columns,
  }) {
    final cubit = context.read<PivotReportCubit>();
    final theme = Theme.of(context);

    final zones = [
      PivotDropZone(
        title: 'Rows',
        icon: Icons.table_rows,
        accentColor: Colors.blue,
        fields: state.rowFields,
        acceptRole: PivotFieldRole.row,
        onFieldAccepted: cubit.addFieldToRows,
        onFieldRemoved: cubit.removeFieldFromRows,
      ),
      PivotDropZone(
        title: 'Columns',
        icon: Icons.view_column,
        accentColor: Colors.green,
        fields: state.columnFields,
        acceptRole: PivotFieldRole.column,
        onFieldAccepted: cubit.addFieldToColumns,
        onFieldRemoved: cubit.removeFieldFromColumns,
      ),
      PivotDropZone(
        title: 'Values',
        icon: Icons.functions,
        accentColor: Colors.orange,
        valueFields: state.valueFields,
        acceptRole: PivotFieldRole.value,
        onFieldAccepted: cubit.addFieldToValues,
        onValueRemoved: cubit.removeValueField,
        onValueTap: (value) => _showAggregationDialog(context, value),
      ),
      PivotDropZone(
        title: 'Filters',
        icon: Icons.filter_list,
        accentColor: Colors.purple,
        fields: state.filters
            .map((f) => PivotField(
                  name: f.fieldName,
                  displayName: f.fieldName,
                  fieldType: PivotFieldType.text,
                  role: PivotFieldRole.filter,
                ))
            .toList(),
        acceptRole: PivotFieldRole.filter,
        onFieldAccepted: cubit.addFieldToFilters,
        onFieldRemoved: (field) => cubit.removeFilter(
          PivotFilter(fieldName: field.name),
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: columns == 4
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < zones.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSizes.sm),
                  Expanded(child: zones[i]),
                ],
              ],
            )
          : GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              crossAxisSpacing: AppSizes.sm,
              mainAxisSpacing: AppSizes.sm,
              childAspectRatio: columns == 1 ? 3.2 : 2.0,
              children: zones,
            ),
    );
  }

  Widget _buildResultArea(BuildContext context, PivotReportState state) {
    if (state.status == PivotReportStatus.executing) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSizes.md),
            Text('Executing pivot report...'),
          ],
        ),
      );
    }

    if (state.status == PivotReportStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: AppSizes.md),
              Text(
                state.errorMessage ?? 'An error occurred',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: AppSizes.md),
              FilledButton.icon(
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                onPressed: context.read<PivotReportCubit>().executeReport,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        children: [
          if (state.showChart && state.hasResult) ...[
            PivotChart(
              result: state.result!,
              chartType: state.chartType,
            ),
            const SizedBox(height: AppSizes.sm),
          ],
          Expanded(
            child: state.hasResult
                ? PivotGrid(
                    result: state.result!,
                    expandedRowKeys: state.expandedRowKeys,
                    onToggleExpand:
                        context.read<PivotReportCubit>().toggleRowExpansion,
                  )
                : PivotGrid(
                    result: const PivotResult(),
                    onToggleExpand: (_) {},
                  ),
          ),
        ],
      ),
    );
  }

  void _handleFieldAction(
    BuildContext context,
    PivotField field,
    PivotFieldRole role,
  ) {
    final cubit = context.read<PivotReportCubit>();
    switch (role) {
      case PivotFieldRole.row:
        cubit.addFieldToRows(field);
      case PivotFieldRole.column:
        cubit.addFieldToColumns(field);
      case PivotFieldRole.value:
        cubit.addFieldToValues(field);
      case PivotFieldRole.filter:
        cubit.addFieldToFilters(field);
      case PivotFieldRole.available:
        break;
    }
  }

  void _showAggregationDialog(BuildContext context, PivotValue value) async {
    final result = await AggregationSelector.show(context, value);
    if (result != null && context.mounted) {
      context.read<PivotReportCubit>().updateValueAggregation(
            value.field,
            result,
          );
    }
  }

  void _showSaveDialog(BuildContext context, PivotReportState state) async {
    final result = await SaveReportDialog.show(
      context,
      initialName: state.currentReport?.name,
      initialDescription: state.currentReport?.description,
    );
    if (result != null && context.mounted) {
      context.read<PivotReportCubit>().saveCurrentReport(
            result.name,
            description: result.description,
          );
    }
  }

  void _showSavedReports(BuildContext context, PivotReportCubit cubit) async {
    await cubit.loadSavedReports();
    if (!context.mounted) return;

    final state = cubit.state;
    SavedReportsDialog.show(
      context,
      reports: state.savedReports,
      onLoad: (report) {
        cubit.loadSavedReport(report);
      },
      onDelete: cubit.deleteReport,
      onDuplicate: cubit.duplicateReport,
    );
  }
}
