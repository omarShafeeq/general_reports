import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../data/report_repository.dart';
import '../models/nested_grid_definition.dart';
import '../widgets/document_master_detail_grid.dart';
import 'dynamic_grid_renderer.dart';

class NestedGridRenderer extends StatefulWidget {
  final List<NestedGridDefinition> nestedDefinitions;
  final Map<String, dynamic> parentRow;
  final ReportRepository repository;
  final int depth;
  final bool documentMode;

  const NestedGridRenderer({
    super.key,
    required this.nestedDefinitions,
    required this.parentRow,
    required this.repository,
    this.depth = 0,
    this.documentMode = false,
  });

  @override
  State<NestedGridRenderer> createState() => _NestedGridRendererState();
}

class _NestedGridRendererState extends State<NestedGridRenderer> {
  final Map<String, List<Map<String, dynamic>>> _childDataCache = {};
  final Map<String, bool> _loadingStates = {};
  final Map<String, String?> _errorStates = {};

  @override
  void initState() {
    super.initState();
    for (final nested in widget.nestedDefinitions) {
      _loadChildData(nested);
    }
  }

  Future<void> _loadChildData(NestedGridDefinition nested) async {
    final parentValue = widget.parentRow[nested.parentKeyField];
    if (parentValue == null) return;

    setState(() {
      _loadingStates[nested.id] = true;
      _errorStates[nested.id] = null;
    });

    try {
      final data = await widget.repository.fetchChildData(
        childDatasource: nested.childDatasource,
        parentKeyField: nested.parentKeyField,
        parentKeyValue: parentValue,
      );
      if (mounted) {
        setState(() {
          _childDataCache[nested.id] = data;
          _loadingStates[nested.id] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingStates[nested.id] = false;
          _errorStates[nested.id] = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.documentMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.nestedDefinitions.map((nested) {
          return _buildNestedSection(context, nested);
        }).toList(),
      );
    }

    final theme = Theme.of(context);
    final indent = widget.depth * 24.0;

    return Container(
      margin: EdgeInsets.only(left: indent),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.nestedDefinitions.map((nested) {
          return _buildNestedSection(context, nested);
        }).toList(),
      ),
    );
  }

  Widget _buildNestedSection(
    BuildContext context,
    NestedGridDefinition nested,
  ) {
    final isLoading = _loadingStates[nested.id] ?? true;
    final error = _errorStates[nested.id];
    final data = _childDataCache[nested.id];

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Text(
          'Failed to load data',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    if (data == null || data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Text(
          'No records found',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    if (widget.documentMode) {
      return DocumentMasterDetailGrid(
        definition: nested.gridDefinition,
        data: data,
        repository: widget.repository,
        compact: true,
      );
    }

    return SizedBox(
      height: _calculateHeight(data.length),
      child: DynamicGridRenderer(
        definition: nested.gridDefinition,
        data: data,
        expandedRowBuilder: nested.children.isNotEmpty
            ? (row) => NestedGridRenderer(
                  nestedDefinitions: nested.children,
                  parentRow: row,
                  repository: widget.repository,
                  depth: widget.depth + 1,
                )
            : null,
      ),
    );
  }

  double _calculateHeight(int rowCount) {
    const headerHeight = AppSizes.gridHeaderHeight;
    const rowHeight = AppSizes.gridRowHeight;
    const titleHeight = 64.0;
    const padding = AppSizes.sm * 2;
    final contentHeight =
        titleHeight + headerHeight + (rowHeight * rowCount) + padding;
    return contentHeight.clamp(200.0, 500.0);
  }
}
