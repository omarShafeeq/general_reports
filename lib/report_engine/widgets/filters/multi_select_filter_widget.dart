import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../models/filter_definition.dart';

class MultiSelectFilterWidget extends StatelessWidget {
  final FilterDefinition definition;
  final List<String> selectedValues;
  final List<FilterOption> options;
  final bool isLoading;
  final ValueChanged<List<String>> onChanged;

  const MultiSelectFilterWidget({
    super.key,
    required this.definition,
    required this.selectedValues,
    required this.options,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: InkWell(
        onTap: isLoading ? null : () => _showDialog(context),
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
                : const Icon(Icons.arrow_drop_down, size: 20),
          ),
          child: Text(
            selectedValues.isEmpty
                ? 'All'
                : '${selectedValues.length} selected',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selectedValues.isEmpty
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => _MultiSelectDialog(
        title: definition.label,
        options: options,
        initialSelection: selectedValues,
      ),
    );
    if (result != null) onChanged(result);
  }
}

class _MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<FilterOption> options;
  final List<String> initialSelection;

  const _MultiSelectDialog({
    required this.title,
    required this.options,
    required this.initialSelection,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            final opt = widget.options[index];
            return CheckboxListTile(
              title: Text(opt.label),
              value: _selected.contains(opt.value),
              dense: true,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selected.add(opt.value);
                  } else {
                    _selected.remove(opt.value);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() => _selected.clear()),
          child: const Text('Clear All'),
        ),
        const SizedBox(width: AppSizes.sm),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selected.toList()),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
