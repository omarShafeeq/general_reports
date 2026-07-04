import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

class EditingPage extends StatefulWidget {
  const EditingPage({super.key});

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  late List<Employee> _employees;
  late _EditableEmployeeDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 50);
    _dataSource = _EditableEmployeeDataSource(_employees);
  }

  void _addRow() {
    final newId = (_employees.isEmpty ? 1000 : _employees.last.id + 1);
    final emp = Employee(
      id: newId,
      firstName: 'New',
      lastName: 'Employee',
      email: 'new$newId@company.com',
      department: 'Engineering',
      designation: 'Analyst',
      dateOfJoining: DateTime.now(),
      salary: 50000,
      status: 'Active',
      city: 'New York',
      country: 'USA',
      age: 25,
      performanceScore: 3.0,
    );
    setState(() {
      _employees.add(emp);
      _dataSource = _EditableEmployeeDataSource(_employees);
    });
  }

  void _deleteLastRow() {
    if (_employees.isEmpty) return;
    setState(() {
      _employees.removeLast();
      _dataSource = _EditableEmployeeDataSource(_employees);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Editing Grid',
      currentRoute: RouteNames.editingGrid,
      body: GridWrapper(
        title: 'Employee Editing',
        subtitle:
            'Double-tap a cell to edit · ${_employees.length} employees',
        toolbar: Row(
          children: [
            FilledButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add),
              label: const Text('Add Row'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _deleteLastRow,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Last'),
            ),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          allowEditing: true,
          editingGestureType: EditingGestureType.doubleTap,
          navigationMode: GridNavigationMode.cell,
          selectionMode: SelectionMode.single,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridColumn(
              columnName: 'id',
              allowEditing: false,
              label: _headerCell('ID'),
              width: 70,
            ),
            GridColumn(
              columnName: 'firstName',
              label: _headerCell('First Name'),
            ),
            GridColumn(
              columnName: 'lastName',
              label: _headerCell('Last Name'),
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
              columnName: 'salary',
              label: _headerCell('Salary'),
            ),
            GridColumn(
              columnName: 'status',
              label: _headerCell('Status'),
              width: 120,
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

class _EditableEmployeeDataSource extends DataGridSource {
  _EditableEmployeeDataSource(this._employees) {
    _rows = _employees.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<String>(columnName: 'firstName', value: e.firstName),
        DataGridCell<String>(columnName: 'lastName', value: e.lastName),
        DataGridCell<String>(columnName: 'department', value: e.department),
        DataGridCell<String>(
            columnName: 'designation', value: e.designation),
        DataGridCell<double>(columnName: 'salary', value: e.salary),
        DataGridCell<String>(columnName: 'status', value: e.status),
      ]);
    }).toList();
  }

  final List<Employee> _employees;
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

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column,
      CellSubmit submitCell) {
    final displayText =
        dataGridRow.getCells()
            .firstWhere((c) => c.columnName == column.columnName)
            .value
            ?.toString() ?? '';

    if (column.columnName == 'department') {
      return _DropdownEditor(
        value: displayText,
        items: const [
          'Sales', 'Marketing', 'Engineering', 'HR',
          'Finance', 'Operations', 'Support', 'Legal',
        ],
        onSubmit: submitCell,
      );
    }

    if (column.columnName == 'status') {
      return _DropdownEditor(
        value: displayText,
        items: const ['Active', 'Inactive'],
        onSubmit: submitCell,
      );
    }

    if (column.columnName == 'salary') {
      return _TextEditor(
        initialValue: displayText,
        keyboardType: TextInputType.number,
        onSubmit: submitCell,
      );
    }

    return _TextEditor(
      initialValue: displayText,
      onSubmit: submitCell,
    );
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) async {
    final rowIndex = _rows.indexOf(dataGridRow);
    if (rowIndex < 0) return;

    final cellIndex =
        dataGridRow.getCells().indexWhere((c) => c.columnName == column.columnName);
    if (cellIndex < 0) return;

    final newValue = dataGridRow.getCells()[cellIndex].value;

    if (rowIndex < _employees.length) {
      final old = _employees[rowIndex];
      _employees[rowIndex] = Employee(
        id: old.id,
        firstName:
            column.columnName == 'firstName' ? newValue.toString() : old.firstName,
        lastName:
            column.columnName == 'lastName' ? newValue.toString() : old.lastName,
        email: old.email,
        department:
            column.columnName == 'department' ? newValue.toString() : old.department,
        designation:
            column.columnName == 'designation' ? newValue.toString() : old.designation,
        dateOfJoining: old.dateOfJoining,
        salary: column.columnName == 'salary'
            ? double.tryParse(newValue.toString()) ?? old.salary
            : old.salary,
        status:
            column.columnName == 'status' ? newValue.toString() : old.status,
        city: old.city,
        country: old.country,
        age: old.age,
        performanceScore: old.performanceScore,
      );
    }
  }
}

class _TextEditor extends StatefulWidget {
  final String initialValue;
  final TextInputType? keyboardType;
  final CellSubmit onSubmit;

  const _TextEditor({
    required this.initialValue,
    required this.onSubmit,
    this.keyboardType,
  });

  @override
  State<_TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<_TextEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: widget.keyboardType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
        onSubmitted: (_) => widget.onSubmit(),
      ),
    );
  }
}

class _DropdownEditor extends StatefulWidget {
  final String value;
  final List<String> items;
  final CellSubmit onSubmit;

  const _DropdownEditor({
    required this.value,
    required this.items,
    required this.onSubmit,
  });

  @override
  State<_DropdownEditor> createState() => _DropdownEditorState();
}

class _DropdownEditorState extends State<_DropdownEditor> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.items.contains(widget.value)
        ? widget.value
        : widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        value: _selected,
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.items
            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
            .toList(),
        onChanged: (v) {
          if (v != null) {
            setState(() => _selected = v);
            widget.onSubmit();
          }
        },
      ),
    );
  }
}
