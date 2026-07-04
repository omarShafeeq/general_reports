import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
class FilterBar extends StatelessWidget {
  final List<FilterItem> filters;
  final VoidCallback? onReset;

  const FilterBar({super.key, required this.filters, this.onReset});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Row(
        children: [
          ...filters.map((f) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.sm),
                child: f,
              )),
          if (onReset != null)
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(context.l10n.reset),
            ),        ],
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const FilterItem({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        constraints: const BoxConstraints(maxWidth: 180),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: theme.textTheme.bodySmall))).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class DateRangeFilterItem extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTimeRange> onChanged;

  const DateRangeFilterItem({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      avatar: const Icon(Icons.date_range, size: 16),
      label: Text(
        '${_format(startDate)} - ${_format(endDate)}',
        style: theme.textTheme.bodySmall,
      ),
      onPressed: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: DateTimeRange(start: startDate, end: endDate),
        );
        if (range != null) onChanged(range);
      },
    );
  }

  String _format(DateTime d) => '${d.month}/${d.day}/${d.year}';
}
