import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

class SaveReportDialog extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final ValueChanged<({String name, String? description})> onSave;

  const SaveReportDialog({
    super.key,
    this.initialName,
    this.initialDescription,
    required this.onSave,
  });

  static Future<({String name, String? description})?> show(
    BuildContext context, {
    String? initialName,
    String? initialDescription,
  }) {
    return showDialog<({String name, String? description})>(
      context: context,
      builder: (context) => SaveReportDialog(
        initialName: initialName,
        initialDescription: initialDescription,
        onSave: (result) => Navigator.of(context).pop(result),
      ),
    );
  }

  @override
  State<SaveReportDialog> createState() => _SaveReportDialogState();
}

class _SaveReportDialogState extends State<SaveReportDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.save),
          const SizedBox(width: AppSizes.sm),
          Text(widget.initialName != null ? 'Update Report' : 'Save Report'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Report Name',
                  hintText: 'Enter a name for this report',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Add a description...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.save, size: 18),
          label: const Text('Save'),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            widget.onSave((
              name: _nameController.text.trim(),
              description: _descController.text.trim().isEmpty
                  ? null
                  : _descController.text.trim(),
            ));
          },
        ),
      ],
    );
  }
}
