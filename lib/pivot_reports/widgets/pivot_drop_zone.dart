import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

import '../models/models.dart';
import 'field_chip.dart';

class PivotDropZone extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? accentColor;
  final List<PivotField> fields;
  final List<PivotValue>? valueFields;
  final PivotFieldRole acceptRole;
  final void Function(PivotField field) onFieldAccepted;
  final void Function(PivotField field)? onFieldRemoved;
  final void Function(PivotValue value)? onValueRemoved;
  final void Function(PivotValue value)? onValueTap;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const PivotDropZone({
    super.key,
    required this.title,
    required this.icon,
    this.accentColor,
    this.fields = const [],
    this.valueFields,
    required this.acceptRole,
    required this.onFieldAccepted,
    this.onFieldRemoved,
    this.onValueRemoved,
    this.onValueTap,
    this.onReorder,
  });

  bool get _isValueZone => acceptRole == PivotFieldRole.value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return DragTarget<PivotField>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => onFieldAccepted(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovering
                ? color.withAlpha(30)
                : theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: isHovering ? color : theme.colorScheme.outlineVariant,
              width: isHovering ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(theme, color),
              _buildContent(theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusSm - 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSizes.xs),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${_isValueZone ? (valueFields?.length ?? 0) : fields.length}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final hasItems = _isValueZone
        ? (valueFields?.isNotEmpty ?? false)
        : fields.isNotEmpty;

    if (!hasItems) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Center(
          child: Text(
            'Drop fields here',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSizes.xs),
      child: Wrap(
        spacing: AppSizes.xs,
        runSpacing: AppSizes.xs,
        children: _isValueZone ? _buildValueChips() : _buildFieldChips(),
      ),
    );
  }

  List<Widget> _buildFieldChips() {
    return fields.map((field) {
      return Draggable<PivotField>(
        data: field,
        feedback: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            child: Text(field.displayName),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: FieldChip(field: field),
        ),
        child: FieldChip(
          field: field,
          onRemove: onFieldRemoved != null ? () => onFieldRemoved!(field) : null,
        ),
      );
    }).toList();
  }

  List<Widget> _buildValueChips() {
    return (valueFields ?? []).map((value) {
      return ValueFieldChip(
        value: value,
        onRemove: onValueRemoved != null ? () => onValueRemoved!(value) : null,
        onTap: onValueTap != null ? () => onValueTap!(value) : null,
      );
    }).toList();
  }
}
