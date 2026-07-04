import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../models/filter_definition.dart';

class TreeSelectFilterWidget extends StatelessWidget {
  final FilterDefinition definition;
  final String? value;
  final List<FilterOption> options;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  const TreeSelectFilterWidget({
    super.key,
    required this.definition,
    required this.value,
    required this.options,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _findLabel(options, value);

    return SizedBox(
      width: 220,
      child: InkWell(
        onTap: isLoading ? null : () => _showTreeDialog(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: definition.label,
            isDense: true,
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.account_tree, size: 18),
          ),
          child: Text(
            selectedLabel ?? 'Select...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selectedLabel == null
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  String? _findLabel(List<FilterOption> options, String? value) {
    if (value == null) return null;
    for (final opt in options) {
      if (opt.value == value) return opt.label;
      if (opt.children != null) {
        final found = _findLabel(opt.children!, value);
        if (found != null) return found;
      }
    }
    return null;
  }

  Future<void> _showTreeDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _TreeDialog(
        title: definition.label,
        options: options,
        currentValue: value,
      ),
    );
    if (result != null) onChanged(result);
  }
}

class _TreeDialog extends StatelessWidget {
  final String title;
  final List<FilterOption> options;
  final String? currentValue;

  const _TreeDialog({
    required this.title,
    required this.options,
    this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 300,
        height: 400,
        child: ListView(
          children: _buildTreeItems(context, options, 0),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  List<Widget> _buildTreeItems(
    BuildContext context,
    List<FilterOption> options,
    int depth,
  ) {
    final widgets = <Widget>[];
    for (final opt in options) {
      final hasChildren = opt.children != null && opt.children!.isNotEmpty;
      if (hasChildren) {
        widgets.add(
          ExpansionTile(
            tilePadding: EdgeInsets.only(left: depth * AppSizes.md + AppSizes.md),
            title: Text(opt.label),
            children: _buildTreeItems(context, opt.children!, depth + 1),
          ),
        );
      } else {
        widgets.add(
          ListTile(
            contentPadding: EdgeInsets.only(left: depth * AppSizes.md + AppSizes.lg),
            title: Text(opt.label),
            selected: opt.value == currentValue,
            dense: true,
            onTap: () => Navigator.pop(context, opt.value),
          ),
        );
      }
    }
    return widgets;
  }
}
