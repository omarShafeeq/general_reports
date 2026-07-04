import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

import '../models/models.dart';

class PivotFilterDialog extends StatefulWidget {
  final List<PivotFilter> filters;
  final List<PivotField> availableFields;
  final ValueChanged<List<PivotFilter>> onApply;

  const PivotFilterDialog({
    super.key,
    required this.filters,
    required this.availableFields,
    required this.onApply,
  });

  static Future<List<PivotFilter>?> show(
    BuildContext context, {
    required List<PivotFilter> filters,
    required List<PivotField> availableFields,
  }) {
    return showDialog<List<PivotFilter>>(
      context: context,
      builder: (context) => PivotFilterDialog(
        filters: filters,
        availableFields: availableFields,
        onApply: (result) => Navigator.of(context).pop(result),
      ),
    );
  }

  @override
  State<PivotFilterDialog> createState() => _PivotFilterDialogState();
}

class _PivotFilterDialogState extends State<PivotFilterDialog> {
  late List<PivotFilter> _filters;

  @override
  void initState() {
    super.initState();
    _filters = List.from(widget.filters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.filter_list),
          const SizedBox(width: AppSizes.sm),
          const Text('Filters'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Filter',
            onPressed: _addFilter,
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: _filters.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_alt_off,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'No filters applied',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
                itemBuilder: (context, index) =>
                    _buildFilterRow(context, index),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => widget.onApply(_filters),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildFilterRow(BuildContext context, int index) {
    final filter = _filters[index];
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                value: filter.fieldName.isEmpty ? null : filter.fieldName,
                decoration: const InputDecoration(
                  labelText: 'Field',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: widget.availableFields.map((f) {
                  return DropdownMenuItem(
                    value: f.name,
                    child: Text(f.displayName, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _filters[index] = filter.copyWith(fieldName: v);
                  });
                },
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: filter.operator,
                decoration: const InputDecoration(
                  labelText: 'Operator',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'equals', child: Text('=')),
                  DropdownMenuItem(value: 'notEquals', child: Text('≠')),
                  DropdownMenuItem(value: 'greaterThan', child: Text('>')),
                  DropdownMenuItem(value: 'lessThan', child: Text('<')),
                  DropdownMenuItem(value: 'contains', child: Text('Contains')),
                  DropdownMenuItem(value: 'between', child: Text('Between')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _filters[index] = filter.copyWith(operator: v);
                  });
                },
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: filter.value?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Value',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  setState(() {
                    _filters[index] = PivotFilter(
                      fieldName: filter.fieldName,
                      operator: filter.operator,
                      value: v.isEmpty ? null : v,
                    );
                  });
                },
              ),
            ),
            const SizedBox(width: AppSizes.xs),
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              iconSize: 20,
              onPressed: () => setState(() => _filters.removeAt(index)),
            ),
          ],
        ),
      ),
    );
  }

  void _addFilter() {
    setState(() {
      _filters.add(const PivotFilter(fieldName: ''));
    });
  }
}
