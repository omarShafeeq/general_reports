import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/filter_definition.dart';

class DateFilterWidget extends StatelessWidget {
  final FilterDefinition definition;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const DateFilterWidget({
    super.key,
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: InkWell(
        onTap: () => _pickDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: definition.label,
            suffixIcon: const Icon(Icons.calendar_today, size: 18),
            isDense: true,
          ),
          child: Text(
            value != null
                ? DateFormat('MMM dd, yyyy').format(value!)
                : 'Select date',
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

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onChanged(picked);
  }
}
