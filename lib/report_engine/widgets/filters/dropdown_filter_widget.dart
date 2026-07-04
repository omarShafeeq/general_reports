import 'package:flutter/material.dart';

import '../../models/filter_definition.dart';

class DropdownFilterWidget extends StatelessWidget {
  final FilterDefinition definition;
  final String? value;
  final List<FilterOption> options;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  const DropdownFilterWidget({
    super.key,
    required this.definition,
    required this.value,
    required this.options,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: isLoading
          ? InputDecorator(
              decoration: InputDecoration(
                labelText: definition.label,
                isDense: true,
              ),
              child: const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : DropdownButtonFormField<String>(
              value: options.any((o) => o.value == value) ? value : null,
              decoration: InputDecoration(
                labelText: definition.label,
                isDense: true,
              ),
              isExpanded: true,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All'),
                ),
                ...options.map((opt) {
                  return DropdownMenuItem<String>(
                    value: opt.value,
                    child: Text(opt.label, overflow: TextOverflow.ellipsis),
                  );
                }),
              ],
              onChanged: onChanged,
            ),
    );
  }
}
