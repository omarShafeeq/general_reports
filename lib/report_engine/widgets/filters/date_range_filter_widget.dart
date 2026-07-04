import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/filter_definition.dart';

class DateRangeFilterWidget extends StatelessWidget {
  final FilterDefinition definition;
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?> onChanged;

  const DateRangeFilterWidget({
    super.key,
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM dd, yyyy');
    final display = value != null
        ? '${fmt.format(value!.start)} – ${fmt.format(value!.end)}'
        : 'Select range';

    return SizedBox(
      width: 280,
      child: InkWell(
        onTap: () => _pickRange(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: definition.label,
            suffixIcon: const Icon(Icons.date_range, size: 18),
            isDense: true,
          ),
          child: Text(
            display,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: value == null
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: value ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now(),
          ),
    );
    if (picked != null) onChanged(picked);
  }
}
