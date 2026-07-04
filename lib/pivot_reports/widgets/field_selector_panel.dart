import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

import '../models/models.dart';

class FieldSelectorPanel extends StatefulWidget {
  final List<PivotField> availableFields;
  final List<PivotField> usedFields;
  final List<PivotValue> usedValues;
  final void Function(PivotField field, PivotFieldRole role) onFieldAction;

  const FieldSelectorPanel({
    super.key,
    required this.availableFields,
    this.usedFields = const [],
    this.usedValues = const [],
    required this.onFieldAction,
  });

  @override
  State<FieldSelectorPanel> createState() => _FieldSelectorPanelState();
}

class _FieldSelectorPanelState extends State<FieldSelectorPanel> {
  String _search = '';

  Set<String> get _usedFieldNames {
    final names = widget.usedFields.map((f) => f.name).toSet();
    names.addAll(widget.usedValues.map((v) => v.field));
    return names;
  }

  List<PivotField> get _filteredFields {
    if (_search.isEmpty) return widget.availableFields;
    final query = _search.toLowerCase();
    return widget.availableFields
        .where((f) =>
            f.displayName.toLowerCase().contains(query) ||
            f.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fields = _filteredFields;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          _buildSearch(theme),
          Expanded(
            child: fields.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Text(
                        widget.availableFields.isEmpty
                            ? 'Select a data source'
                            : 'No matching fields',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    itemCount: fields.length,
                    itemBuilder: (context, index) =>
                        _buildFieldTile(context, fields[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(60),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusSm - 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.list_alt, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: AppSizes.xs),
          Text(
            'Available Fields',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${widget.availableFields.length}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        decoration: InputDecoration(
          hintText: 'Search fields...',
          prefixIcon: const Icon(Icons.search, size: 18),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
        ),
        style: theme.textTheme.bodySmall,
      ),
    );
  }

  Widget _buildFieldTile(BuildContext context, PivotField field) {
    final theme = Theme.of(context);
    final isUsed = _usedFieldNames.contains(field.name);

    return Draggable<PivotField>(
      data: field,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_iconForFieldType(field.fieldType), size: 14),
              const SizedBox(width: AppSizes.xs),
              Text(field.displayName, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _fieldListTile(theme, field, isUsed),
      ),
      child: _fieldListTile(theme, field, isUsed),
    );
  }

  Widget _fieldListTile(ThemeData theme, PivotField field, bool isUsed) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      leading: Icon(
        _iconForFieldType(field.fieldType),
        size: 16,
        color: isUsed
            ? theme.colorScheme.onSurfaceVariant.withAlpha(100)
            : theme.colorScheme.primary,
      ),
      title: Text(
        field.displayName,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isUsed ? theme.colorScheme.onSurfaceVariant.withAlpha(100) : null,
          decoration: isUsed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        field.fieldType.name,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
        ),
      ),
      trailing: isUsed
          ? Icon(Icons.check_circle, size: 16, color: theme.colorScheme.primary)
          : PopupMenuButton<PivotFieldRole>(
              icon: const Icon(Icons.add, size: 16),
              iconSize: 16,
              padding: EdgeInsets.zero,
              tooltip: 'Add to...',
              onSelected: (role) => widget.onFieldAction(field, role),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: PivotFieldRole.row,
                  child: _RoleMenuItem(Icons.table_rows, 'Rows'),
                ),
                const PopupMenuItem(
                  value: PivotFieldRole.column,
                  child: _RoleMenuItem(Icons.view_column, 'Columns'),
                ),
                const PopupMenuItem(
                  value: PivotFieldRole.value,
                  child: _RoleMenuItem(Icons.functions, 'Values'),
                ),
                const PopupMenuItem(
                  value: PivotFieldRole.filter,
                  child: _RoleMenuItem(Icons.filter_list, 'Filters'),
                ),
              ],
            ),
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

class _RoleMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RoleMenuItem(this.icon, this.label);

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
