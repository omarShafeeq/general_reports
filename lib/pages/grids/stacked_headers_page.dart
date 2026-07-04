import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

class StackedHeadersPage extends StatefulWidget {
  const StackedHeadersPage({super.key});

  @override
  State<StackedHeadersPage> createState() => _StackedHeadersPageState();
}

class _StackedHeadersPageState extends State<StackedHeadersPage> {
  late final List<Employee> _employees;
  late final _StackedDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 80);
    _dataSource = _StackedDataSource(_employees);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Stacked Headers',
      currentRoute: RouteNames.stackedHeaders,
      body: GridWrapper(
        title: 'Stacked Header Rows',
        subtitle: 'Group related columns under parent headers',
        grid: SfDataGrid(
          source: _dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          rowHeight: AppSizes.gridRowHeight,
          headerRowHeight: AppSizes.gridHeaderHeight,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          stackedHeaderRows: [
            StackedHeaderRow(cells: [
              StackedHeaderCell(
                columnNames: ['name', 'age', 'city', 'country'],
                child: _stackedHeaderCell('Personal Info', theme),
              ),
              StackedHeaderCell(
                columnNames: ['department', 'designation', 'dateOfJoining'],
                child: _stackedHeaderCell('Job Details', theme),
              ),
              StackedHeaderCell(
                columnNames: ['salary', 'performanceScore'],
                child: _stackedHeaderCell('Compensation & Performance', theme),
              ),
            ]),
          ],
          columns: <GridColumn>[
            GridColumn(
              columnName: 'name',
              label: _headerCell('Name'),
            ),
            GridColumn(
              columnName: 'age',
              width: 70,
              label: _headerCell('Age', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'city',
              label: _headerCell('City'),
            ),
            GridColumn(
              columnName: 'country',
              label: _headerCell('Country'),
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
              columnName: 'dateOfJoining',
              width: 130,
              label: _headerCell('Joined'),
            ),
            GridColumn(
              columnName: 'salary',
              label: _headerCell('Salary', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'performanceScore',
              width: 120,
              label: _headerCell('Score', Alignment.centerRight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stackedHeaderCell(String text, ThemeData theme) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimaryContainer,
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

class _StackedDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  static final _dateFormat = _SimpleDateFormat();

  _StackedDataSource(List<Employee> employees) {
    _rows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: e.fullName),
              DataGridCell<int>(columnName: 'age', value: e.age),
              DataGridCell<String>(columnName: 'city', value: e.city),
              DataGridCell<String>(columnName: 'country', value: e.country),
              DataGridCell<String>(columnName: 'department', value: e.department),
              DataGridCell<String>(columnName: 'designation', value: e.designation),
              DataGridCell<DateTime>(columnName: 'dateOfJoining', value: e.dateOfJoining),
              DataGridCell<double>(columnName: 'salary', value: e.salary),
              DataGridCell<double>(columnName: 'performanceScore', value: e.performanceScore),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        switch (cell.columnName) {
          case 'salary':
            return Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('\$${(cell.value as double).toStringAsFixed(0)}'),
            );
          case 'performanceScore':
            return Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text((cell.value as double).toStringAsFixed(1)),
            );
          case 'dateOfJoining':
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_dateFormat.format(cell.value as DateTime)),
            );
          case 'age':
            return Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(cell.value.toString()),
            );
          default:
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(cell.value.toString(), overflow: TextOverflow.ellipsis),
            );
        }
      }).toList(),
    );
  }
}

class _SimpleDateFormat {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String format(DateTime date) {
    return '${_months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}
