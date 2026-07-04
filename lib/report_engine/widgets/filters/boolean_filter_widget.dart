import 'package:flutter/material.dart';

import '../../models/filter_definition.dart';

class BooleanFilterWidget extends StatelessWidget {
  final FilterDefinition definition;
  final bool? value;
  final ValueChanged<bool?> onChanged;

  const BooleanFilterWidget({
    super.key,
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value ?? false,
          tristate: !definition.required,
          onChanged: onChanged,
        ),
        Text(
          definition.label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
