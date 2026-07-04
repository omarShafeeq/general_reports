import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';

class SavedReportsDialog extends StatelessWidget {
  final List<PivotReport> reports;
  final ValueChanged<PivotReport> onLoad;
  final ValueChanged<String> onDelete;
  final void Function(String id, String newName) onDuplicate;

  const SavedReportsDialog({
    super.key,
    required this.reports,
    required this.onLoad,
    required this.onDelete,
    required this.onDuplicate,
  });

  static Future<void> show(
    BuildContext context, {
    required List<PivotReport> reports,
    required ValueChanged<PivotReport> onLoad,
    required ValueChanged<String> onDelete,
    required void Function(String id, String newName) onDuplicate,
  }) {
    return showDialog(
      context: context,
      builder: (_) => SavedReportsDialog(
        reports: reports,
        onLoad: onLoad,
        onDelete: onDelete,
        onDuplicate: onDuplicate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.folder_open),
          const SizedBox(width: AppSizes.sm),
          const Text('Saved Reports'),
          const Spacer(),
          Text(
            '${reports.length} reports',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        height: 400,
        child: reports.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_off,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'No saved reports yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: reports.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return ListTile(
                    leading: const Icon(Icons.pivot_table_chart),
                    title: Text(report.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (report.description != null)
                          Text(
                            report.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          '${report.layout.dataSourceId} · '
                          '${report.layout.rows.length} rows, '
                          '${report.layout.values.length} values'
                          '${report.updatedAt != null ? ' · ${dateFormat.format(report.updatedAt!)}' : ''}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: report.description != null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          tooltip: 'Duplicate',
                          onPressed: () {
                            onDuplicate(report.id!, '${report.name} (Copy)');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              size: 18, color: theme.colorScheme.error),
                          tooltip: 'Delete',
                          onPressed: () => _confirmDelete(context, report),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onLoad(report);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, PivotReport report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Report'),
        content: Text('Are you sure you want to delete "${report.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete(report.id!);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
