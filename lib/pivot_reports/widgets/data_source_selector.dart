import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

import '../models/models.dart';

class DataSourceSelector extends StatelessWidget {
  final List<PivotDataSource> dataSources;
  final PivotDataSource? selected;
  final ValueChanged<PivotDataSource> onSelected;

  const DataSourceSelector({
    super.key,
    required this.dataSources,
    this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      value: selected?.id,
      decoration: InputDecoration(
        labelText: 'Data Source',
        prefixIcon: Icon(
          selected?.icon ?? Icons.storage,
          size: 20,
        ),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        isDense: true,
      ),
      items: dataSources.map((ds) {
        return DropdownMenuItem(
          value: ds.id,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ds.icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: AppSizes.sm),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(ds.name, style: theme.textTheme.bodyMedium),
                    if (ds.description.isNotEmpty)
                      Text(
                        ds.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (id) {
        if (id == null) return;
        final ds = dataSources.firstWhere((s) => s.id == id);
        onSelected(ds);
      },
      selectedItemBuilder: (context) => dataSources.map((ds) {
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(ds.name),
        );
      }).toList(),
    );
  }
}
