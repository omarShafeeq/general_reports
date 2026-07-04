import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

import '../models/models.dart';

class AggregationSelector extends StatelessWidget {
  final PivotValue value;
  final ValueChanged<PivotAggregation> onChanged;

  const AggregationSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static Future<PivotAggregation?> show(
    BuildContext context,
    PivotValue value,
  ) {
    return showDialog<PivotAggregation>(
      context: context,
      builder: (context) => _AggregationDialog(current: value.aggregation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PivotAggregation>(
      initialValue: value.aggregation,
      onSelected: onChanged,
      tooltip: 'Change aggregation',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.functions, size: 14),
            const SizedBox(width: AppSizes.xs),
            Text(value.aggregation.label),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
      itemBuilder: (_) => PivotAggregation.values.map((agg) {
        return PopupMenuItem(
          value: agg,
          child: Row(
            children: [
              if (agg == value.aggregation)
                const Icon(Icons.check, size: 16)
              else
                const SizedBox(width: 16),
              const SizedBox(width: AppSizes.sm),
              Text(agg.label),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AggregationDialog extends StatelessWidget {
  final PivotAggregation current;

  const _AggregationDialog({required this.current});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Select Aggregation'),
      contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: PivotAggregation.values.map((agg) {
          return RadioListTile<PivotAggregation>(
            title: Text(agg.label),
            value: agg,
            groupValue: current,
            dense: true,
            onChanged: (v) => Navigator.of(context).pop(v),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        ),
      ],
    );
  }
}
