import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

class FrozenPage extends StatefulWidget {
  const FrozenPage({super.key});

  @override
  State<FrozenPage> createState() => _FrozenPageState();
}

class _FrozenPageState extends State<FrozenPage> {
  late final List<Employee> _employees;
  late final _FrozenDataSource _dataSource;
  int _frozenColumns = 1;
  int _frozenRows = 1;

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 100);
    _dataSource = _FrozenDataSource(_employees);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Frozen Rows & Columns',
      currentRoute: RouteNames.frozenGrid,
      body: GridWrapper(
        title: 'Frozen Panes',
        subtitle: 'Freeze columns and rows to keep them visible while scrolling',
        toolbar: Row(
          children: [
            Text('Frozen Columns:', style: theme.textTheme.bodyMedium),
            const SizedBox(width: AppSizes.sm),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('0')),
                ButtonSegment(value: 1, label: Text('1')),
                ButtonSegment(value: 2, label: Text('2')),
                ButtonSegment(value: 3, label: Text('3')),
              ],
              selected: {_frozenColumns},
              onSelectionChanged: (v) => setState(() => _frozenColumns = v.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: AppSizes.lg),
            Text('Frozen Rows:', style: theme.textTheme.bodyMedium),
            const SizedBox(width: AppSizes.sm),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('0')),
                ButtonSegment(value: 1, label: Text('1')),
                ButtonSegment(value: 2, label: Text('2')),
                ButtonSegment(value: 3, label: Text('3')),
              ],
              selected: {_frozenRows},
              onSelectionChanged: (v) => setState(() => _frozenRows = v.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          frozenColumnsCount: _frozenColumns,
          frozenRowsCount: _frozenRows,
          columnWidthMode: ColumnWidthMode.none,
          rowHeight: AppSizes.gridRowHeight,
          headerRowHeight: AppSizes.gridHeaderHeight,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              width: 80,
              label: _headerCell('ID'),
            ),
            GridColumn(
              columnName: 'name',
              width: 160,
              label: _headerCell('Name'),
            ),
            GridColumn(
              columnName: 'email',
              width: 200,
              label: _headerCell('Email'),
            ),
            GridColumn(
              columnName: 'department',
              width: 140,
              label: _headerCell('Department'),
            ),
            GridColumn(
              columnName: 'designation',
              width: 160,
              label: _headerCell('Designation'),
            ),
            GridColumn(
              columnName: 'salary',
              width: 120,
              label: _headerCell('Salary', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'city',
              width: 130,
              label: _headerCell('City'),
            ),
            GridColumn(
              columnName: 'country',
              width: 120,
              label: _headerCell('Country'),
            ),
            GridColumn(
              columnName: 'age',
              width: 80,
              label: _headerCell('Age', Alignment.centerRight),
            ),
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

class _FrozenDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  _FrozenDataSource(List<Employee> employees) {
    _rows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.fullName),
              DataGridCell<String>(columnName: 'email', value: e.email),
              DataGridCell<String>(columnName: 'department', value: e.department),
              DataGridCell<String>(columnName: 'designation', value: e.designation),
              DataGridCell<double>(columnName: 'salary', value: e.salary),
              DataGridCell<String>(columnName: 'city', value: e.city),
              DataGridCell<String>(columnName: 'country', value: e.country),
              DataGridCell<int>(columnName: 'age', value: e.age),
              DataGridCell<String>(columnName: 'status', value: e.status),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        final isNumeric = cell.columnName == 'salary' || cell.columnName == 'age';
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
