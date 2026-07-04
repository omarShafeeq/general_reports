import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

/// Demonstrates Syncfusion [SfDataGrid] column grouping via [ColumnGroup].
class GroupByPage extends StatefulWidget {
  const GroupByPage({super.key});

  @override
  State<GroupByPage> createState() => _GroupByPageState();
}

class _GroupByPageState extends State<GroupByPage> {
  static const _groupableColumns = {
    'department': 'Department',
    'city': 'City',
    'status': 'Status',
    'designation': 'Designation',
    'country': 'Country',
  };

  late final _GroupByDataSource _dataSource;
  bool _autoExpandGroups = true;
  bool _allowExpandCollapse = true;
  bool _sortGroupRows = true;
  bool _useCustomGrouping = false;

  @override
  void initState() {
    super.initState();
    final employees = HrDataGenerator.generateEmployees(count: 120);
    _dataSource = _GroupByDataSource(employees, useCustomGrouping: false);
  }

  void _setGrouping(List<String> columnNames) {
    _dataSource.clearColumnGroups();
    for (final name in columnNames) {
      _dataSource.addColumnGroup(
        ColumnGroup(name: name, sortGroupRows: _sortGroupRows),
      );
    }
    setState(() {});
  }

  void _toggleCustomGrouping(bool value) {
    setState(() {
      _useCustomGrouping = value;
      _dataSource.useCustomGrouping = value;
      final currentGroups =
          _dataSource.groupedColumns.map((g) => g.name).toList();
      if (currentGroups.isNotEmpty) {
        _dataSource.clearColumnGroups();
        for (final name in currentGroups) {
          _dataSource.addColumnGroup(
            ColumnGroup(name: name, sortGroupRows: _sortGroupRows),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeGroups =
        _dataSource.groupedColumns.map((g) => g.name).toList();

    return ResponsiveScaffold(
      title: 'Group By',
      currentRoute: RouteNames.groupByGrid,
      body: GridWrapper(
        title: 'Column Grouping',
        subtitle:
            'Group rows by one or more columns. Supports multi-level groups, expand/collapse, and custom grouping keys.',
        toolbar: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Group by:', style: theme.textTheme.bodyMedium),
                ..._groupableColumns.entries.map((entry) {
                  final isSelected = activeGroups.contains(entry.key);
                  return FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      final updated = List<String>.from(activeGroups);
                      if (selected) {
                        if (!updated.contains(entry.key)) {
                          updated.add(entry.key);
                        }
                      } else {
                        updated.remove(entry.key);
                      }
                      _setGrouping(updated);
                    },
                  );
                }),
                TextButton.icon(
                  onPressed: activeGroups.isEmpty
                      ? null
                      : () => _setGrouping([]),
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.md,
              runSpacing: AppSizes.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('Auto Expand'),
                  selected: _autoExpandGroups,
                  onSelected: (v) => setState(() => _autoExpandGroups = v),
                ),
                FilterChip(
                  label: const Text('Expand / Collapse'),
                  selected: _allowExpandCollapse,
                  onSelected: (v) => setState(() => _allowExpandCollapse = v),
                ),
                FilterChip(
                  label: const Text('Sort Groups'),
                  selected: _sortGroupRows,
                  onSelected: (v) {
                    setState(() => _sortGroupRows = v);
                    _setGrouping(activeGroups);
                  },
                ),
                FilterChip(
                  label: const Text('Custom Keys'),
                  selected: _useCustomGrouping,
                  onSelected: _toggleCustomGrouping,
                ),
              ],
            ),
            if (activeGroups.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              Text(
                'Active levels: ${activeGroups.map((c) => _groupableColumns[c] ?? c).join(' → ')}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          autoExpandGroups: _autoExpandGroups,
          allowExpandCollapseGroup: _allowExpandCollapse,
          groupCaptionTitleFormat:
              '{ColumnName}: {Key} ({ItemsCount} employees)',
          columnWidthMode: ColumnWidthMode.fill,
          rowHeight: AppSizes.gridRowHeight,
          headerRowHeight: AppSizes.gridHeaderHeight,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columns: <GridColumn>[
            GridColumn(columnName: 'id', width: 80, label: _headerCell('ID')),
            GridColumn(columnName: 'name', label: _headerCell('Name')),
            GridColumn(
              columnName: 'department',
              label: _headerCell('Department'),
            ),
            GridColumn(
              columnName: 'designation',
              label: _headerCell('Designation'),
            ),
            GridColumn(
              columnName: 'salary',
              label: _headerCell('Salary', Alignment.centerRight),
            ),
            GridColumn(columnName: 'city', label: _headerCell('City')),
            GridColumn(columnName: 'country', label: _headerCell('Country')),
            GridColumn(
              columnName: 'status',
              width: 100,
              label: _headerCell('Status'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text, [Alignment alignment = Alignment.centerLeft]) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _GroupByDataSource extends DataGridSource {
  _GroupByDataSource(List<Employee> employees, {this.useCustomGrouping = false}) {
    _buildRows(employees);
  }

  bool useCustomGrouping;
  List<DataGridRow> _rows = [];

  void _buildRows(List<Employee> employees) {
    _rows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.fullName),
              DataGridCell<String>(columnName: 'department', value: e.department),
              DataGridCell<String>(
                columnName: 'designation',
                value: e.designation,
              ),
              DataGridCell<double>(columnName: 'salary', value: e.salary),
              DataGridCell<String>(columnName: 'city', value: e.city),
              DataGridCell<String>(columnName: 'country', value: e.country),
              DataGridCell<String>(columnName: 'status', value: e.status),
            ]))
        .toList();
  }

  @override
  String performGrouping(String columnName, DataGridRow row) {
    if (!useCustomGrouping) {
      return super.performGrouping(columnName, row);
    }

    final value = super.performGrouping(columnName, row);
    if (columnName == 'department') {
      return 'Team: $value';
    }
    return value;
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'status') {
          final status = cell.value.toString();
          final color = status == 'Active'
              ? Colors.green.shade100
              : Colors.grey.shade200;
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              label: Text(status, style: const TextStyle(fontSize: 12)),
              backgroundColor: color,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
          );
        }

        final isNumeric = cell.columnName == 'salary';
        return Container(
          alignment: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            cell.columnName == 'salary'
                ? '\$${(cell.value as double).toStringAsFixed(0)}'
                : cell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
