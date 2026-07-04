import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

import '../models/models.dart';

class FieldChip extends StatelessWidget {
  final PivotField field;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool showType;

  const FieldChip({
    super.key,
    required this.field,
    this.onRemove,
    this.onTap,
    this.backgroundColor,
    this.showType = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconForFieldType(field.fieldType), size: 14),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Text(
              field.displayName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showType) ...[
            const SizedBox(width: AppSizes.xs),
            Text(
              field.fieldType.name,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      onPressed: onTap,
      onDeleted: onRemove,
      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
      deleteIconColor: theme.colorScheme.error,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  IconData _iconForFieldType(PivotFieldType type) {
    switch (type) {
      case PivotFieldType.text:
        return Icons.text_fields;
      case PivotFieldType.numeric:
        return Icons.numbers;
      case PivotFieldType.date:
        return Icons.calendar_today;
      case PivotFieldType.dateTime:
        return Icons.access_time;
      case PivotFieldType.boolean:
        return Icons.check_box;
    }
  }
}

class ValueFieldChip extends StatelessWidget {
  final PivotValue value;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const ValueFieldChip({
    super.key,
    required this.value,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.functions, size: 14),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Text(
              value.displayLabel,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      onPressed: onTap,
      onDeleted: onRemove,
      backgroundColor: theme.colorScheme.tertiaryContainer,
      deleteIconColor: theme.colorScheme.error,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
