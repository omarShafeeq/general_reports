import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../../models/filter_definition.dart';

class PeriodFilterWidget extends StatelessWidget {
  final FilterDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const PeriodFilterWidget({
    super.key,
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (definition.type) {
      case ReportFilterType.month:
        return _buildMonthFilter(context);
      case ReportFilterType.quarter:
        return _buildQuarterFilter(context);
      case ReportFilterType.year:
        return _buildYearFilter(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMonthFilter(BuildContext context) {
    final months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];

    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<int>(
        value: value as int?,
        decoration: InputDecoration(
          labelText: definition.label,
          isDense: true,
        ),
        isExpanded: true,
        items: [
          const DropdownMenuItem<int>(value: null, child: Text('All')),
          ...List.generate(12, (i) {
            return DropdownMenuItem<int>(
              value: i + 1,
              child: Text(months[i]),
            );
          }),
        ],
        onChanged: (v) => onChanged(v),
      ),
    );
  }

  Widget _buildQuarterFilter(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<int>(
        value: value as int?,
        decoration: InputDecoration(
          labelText: definition.label,
          isDense: true,
        ),
        isExpanded: true,
        items: [
          const DropdownMenuItem<int>(value: null, child: Text('All')),
          ...List.generate(4, (i) {
            return DropdownMenuItem<int>(
              value: i + 1,
              child: Text('Q${i + 1}'),
            );
          }),
        ],
        onChanged: (v) => onChanged(v),
      ),
    );
  }

  Widget _buildYearFilter(BuildContext context) {
    final currentYear = DateTime.now().year;
    return SizedBox(
      width: 140,
      child: DropdownButtonFormField<int>(
        value: value as int?,
        decoration: InputDecoration(
          labelText: definition.label,
          isDense: true,
        ),
        isExpanded: true,
        items: [
          const DropdownMenuItem<int>(value: null, child: Text('All')),
          ...List.generate(10, (i) {
            final year = currentYear - i;
            return DropdownMenuItem<int>(
              value: year,
              child: Text('$year'),
            );
          }),
        ],
        onChanged: (v) => onChanged(v),
      ),
    );
  }
}
