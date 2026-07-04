import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/context_extensions.dart';

import '../models/models.dart';

class PivotToolbar extends StatelessWidget {
  final VoidCallback onExecute;
  final VoidCallback onSave;
  final VoidCallback onClear;
  final VoidCallback onToggleChart;
  final VoidCallback onLoadReports;
  final VoidCallback? onExportExcel;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportCsv;
  final VoidCallback? onPrint;
  final PivotChartType chartType;
  final ValueChanged<PivotChartType> onChartTypeChanged;
  final bool canExecute;
  final bool isLoading;
  final bool showChart;
  final PivotReport? currentReport;

  const PivotToolbar({
    super.key,
    required this.onExecute,
    required this.onSave,
    required this.onClear,
    required this.onToggleChart,
    required this.onLoadReports,
    this.onExportExcel,
    this.onExportPdf,
    this.onExportCsv,
    this.onPrint,
    required this.chartType,
    required this.onChartTypeChanged,
    required this.canExecute,
    required this.isLoading,
    required this.showChart,
    this.currentReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: context.isMobile
          ? _buildMobileLayout(context, theme)
          : context.isTablet
              ? _buildTabletLayout(context, theme)
              : _buildDesktopLayout(context, theme),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Row(
        children: [
          _buildTitle(theme),
          const Spacer(),
          _buildChartToggle(theme),
          const SizedBox(width: AppSizes.sm),
          if (showChart) ...[
            _buildChartTypeSelector(theme),
            const SizedBox(width: AppSizes.sm),
          ],
          _buildExecuteButton(theme, showLabel: true),
          const SizedBox(width: AppSizes.sm),
          _buildExportMenu(theme, showLabel: true),
          const SizedBox(width: AppSizes.sm),
          _buildSaveButton(theme, showLabel: true),
          const SizedBox(width: AppSizes.sm),
          _buildSecondaryActions(theme),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _buildTitle(theme)),
              _buildExecuteButton(theme, showLabel: true),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChartToggle(theme),
                if (showChart) ...[
                  const SizedBox(width: AppSizes.sm),
                  _buildChartTypeSelector(theme),
                ],
                const SizedBox(width: AppSizes.sm),
                _buildExportMenu(theme, showLabel: false),
                const SizedBox(width: AppSizes.sm),
                _buildSaveButton(theme, showLabel: false),
                const SizedBox(width: AppSizes.sm),
                _buildSecondaryActions(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.pivot_table_chart,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  currentReport?.name ?? 'Pivot Report',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildExecuteButton(theme, showLabel: false),
            ],
          ),
          if (showChart) ...[
            const SizedBox(height: AppSizes.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildChartTypeSelector(theme),
            ),
          ],
          const SizedBox(height: AppSizes.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChartToggle(theme),
                _buildExportMenu(theme, showLabel: false),
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  tooltip: 'Save',
                  onPressed: onSave,
                ),
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  tooltip: 'Load Saved Reports',
                  onPressed: onLoadReports,
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Clear Layout',
                  onPressed: onClear,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.pivot_table_chart, color: theme.colorScheme.primary),
        const SizedBox(width: AppSizes.sm),
        Flexible(
          child: Text(
            currentReport?.name ?? 'Pivot Report',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryActions(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.folder_open),
          tooltip: 'Load Saved Reports',
          onPressed: onLoadReports,
        ),
        IconButton(
          icon: const Icon(Icons.clear_all),
          tooltip: 'Clear Layout',
          onPressed: onClear,
        ),
      ],
    );
  }

  Widget _buildExecuteButton(ThemeData theme, {required bool showLabel}) {
    final icon = isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: showLabel ? theme.colorScheme.onPrimary : null,
            ),
          )
        : const Icon(Icons.play_arrow, size: 18);

    if (!showLabel) {
      return IconButton.filled(
        icon: icon,
        tooltip: 'Execute',
        onPressed: canExecute && !isLoading ? onExecute : null,
      );
    }

    return FilledButton.icon(
      icon: icon,
      label: const Text('Execute'),
      onPressed: canExecute && !isLoading ? onExecute : null,
    );
  }

  Widget _buildSaveButton(ThemeData theme, {required bool showLabel}) {
    if (!showLabel) {
      return IconButton(
        icon: const Icon(Icons.save_outlined),
        tooltip: 'Save',
        onPressed: onSave,
      );
    }

    return OutlinedButton.icon(
      icon: const Icon(Icons.save, size: 18),
      label: const Text('Save'),
      onPressed: onSave,
    );
  }

  Widget _buildExportMenu(ThemeData theme, {required bool showLabel}) {
    return PopupMenuButton<String>(
      tooltip: 'Export',
      icon: const Icon(Icons.file_download_outlined),
      child: showLabel
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm - 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_download,
                      size: 18, color: theme.colorScheme.onSurface),
                  const SizedBox(width: AppSizes.xs),
                  Text('Export', style: theme.textTheme.bodyMedium),
                ],
              ),
            )
          : null,
      itemBuilder: (_) => [
        if (onExportExcel != null)
          const PopupMenuItem(
            value: 'excel',
            child: _ExportMenuItem(Icons.table_chart, 'Excel (.xlsx)'),
          ),
        if (onExportPdf != null)
          const PopupMenuItem(
            value: 'pdf',
            child: _ExportMenuItem(Icons.picture_as_pdf, 'PDF'),
          ),
        if (onExportCsv != null)
          const PopupMenuItem(
            value: 'csv',
            child: _ExportMenuItem(Icons.text_snippet, 'CSV'),
          ),
        if (onPrint != null)
          const PopupMenuItem(
            value: 'print',
            child: _ExportMenuItem(Icons.print, 'Print'),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'excel':
            onExportExcel?.call();
          case 'pdf':
            onExportPdf?.call();
          case 'csv':
            onExportCsv?.call();
          case 'print':
            onPrint?.call();
        }
      },
    );
  }

  Widget _buildChartToggle(ThemeData theme) {
    return IconButton(
      icon: Icon(
        showChart ? Icons.bar_chart : Icons.bar_chart_outlined,
        color: showChart ? theme.colorScheme.primary : null,
      ),
      tooltip: showChart ? 'Hide Chart' : 'Show Chart',
      onPressed: onToggleChart,
    );
  }

  Widget _buildChartTypeSelector(ThemeData theme) {
    return SegmentedButton<PivotChartType>(
      segments: const [
        ButtonSegment(
            value: PivotChartType.bar, icon: Icon(Icons.bar_chart, size: 16)),
        ButtonSegment(
            value: PivotChartType.line, icon: Icon(Icons.show_chart, size: 16)),
        ButtonSegment(
            value: PivotChartType.pie, icon: Icon(Icons.pie_chart, size: 16)),
        ButtonSegment(
            value: PivotChartType.area, icon: Icon(Icons.area_chart, size: 16)),
        ButtonSegment(
            value: PivotChartType.doughnut,
            icon: Icon(Icons.donut_large, size: 16)),
      ],
      selected: {chartType},
      onSelectionChanged: (s) => onChartTypeChanged(s.first),
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _ExportMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ExportMenuItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: AppSizes.sm),
        Text(label),
      ],
    );
  }
}
