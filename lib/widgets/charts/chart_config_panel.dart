import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

/// A reusable controls panel that exposes switches, dropdowns, and sliders
/// for interactively configuring chart demos.
class ChartConfigPanel extends StatelessWidget {
  final List<Widget> children;
  final bool isExpanded;

  const ChartConfigPanel({
    super.key,
    required this.children,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) return const SizedBox.shrink();
    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.sm,
      children: children,
    );
  }
}

class ConfigSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ConfigSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 4),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class ConfigDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;

  const ConfigDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 8),
        DropdownButton<T>(
          value: value,
          isDense: true,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      labelBuilder?.call(item) ?? item.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class ConfigSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const ConfigSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(
          width: 120,
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        Text(value.toStringAsFixed(1), style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
