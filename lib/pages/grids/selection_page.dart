import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  late List<Employee> _employees;
  late _EmployeeSelectionDataSource _dataSource;
  final DataGridController _controller = DataGridController();
  SelectionMode _selectionMode = SelectionMode.multiple;

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 80);
    _dataSource = _EmployeeSelectionDataSource(_employees);
  }

  String get _selectionInfo {
    final selected = _controller.selectedRows;
    if (selected.isEmpty) return 'No rows selected';
    return '${selected.length} row(s) selected';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Selection Grid',
      currentRoute: RouteNames.selectionGrid,
      body: GridWrapper(
        title: 'Employee Selection',
        subtitle: '${_employees.length} employees',
        toolbar: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Selection Mode:'),
                SegmentedButton<SelectionMode>(
                  segments: const [
                    ButtonSegment(
                      value: SelectionMode.single,
                      label: Text('Single'),
                    ),
                    ButtonSegment(
                      value: SelectionMode.singleDeselect,
                      label: Text('Single Deselect'),
                    ),
                    ButtonSegment(
                      value: SelectionMode.multiple,
                      label: Text('Multiple'),
                    ),
                  ],
                  selected: {_selectionMode},
                  onSelectionChanged: (v) {
                    setState(() {
                      _selectionMode = v.first;
                      _controller.selectedRows = [];
                    });
                  },
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _controller.selectedRows = []);
                  },
                  icon: const Icon(Icons.deselect, size: 18),
                  label: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _selectionInfo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          controller: _controller,
          selectionMode: _selectionMode,
          navigationMode: GridNavigationMode.row,
          columnWidthMode: ColumnWidthMode.fill,
          onSelectionChanged: (addedRows, removedRows) {
            setState(() {});
          },
          columns: [
            GridColumn(
              columnName: 'id',
              label: _headerCell('ID'),
              width: 70,
            ),
            GridColumn(
              columnName: 'name',
              label: _headerCell('Name'),
            ),
            GridColumn(
              columnName: 'department',
              label: _headerCell('Department'),
            ),
            GridColumn(
              columnName: 'designation',
              label: _headerCell('Designation'),
            ),
            GridColumn(
              columnName: 'city',
              label: _headerCell('City'),
            ),
            GridColumn(
              columnName: 'salary',
              label: _headerCell('Salary'),
            ),
            GridColumn(
              columnName: 'status',
              label: _headerCell('Status'),
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _EmployeeSelectionDataSource extends DataGridSource {
  _EmployeeSelectionDataSource(List<Employee> employees) {
    _rows = employees.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<String>(columnName: 'name', value: e.fullName),
        DataGridCell<String>(columnName: 'department', value: e.department),
        DataGridCell<String>(
            columnName: 'designation', value: e.designation),
        DataGridCell<String>(columnName: 'city', value: e.city),
        DataGridCell<double>(columnName: 'salary', value: e.salary),
        DataGridCell<String>(columnName: 'status', value: e.status),
      ]);
    }).toList();
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: cell.columnName == 'salary'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            cell.columnName == 'salary'
                ? '\$${(cell.value as double).toStringAsFixed(0)}'
                : cell.value?.toString() ?? '',
          ),
        );
      }).toList(),
    );
  }
}

