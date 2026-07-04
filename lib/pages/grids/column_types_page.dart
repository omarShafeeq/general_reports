import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

class ColumnTypesPage extends StatefulWidget {
  const ColumnTypesPage({super.key});

  @override
  State<ColumnTypesPage> createState() => _ColumnTypesPageState();
}

class _ColumnTypesPageState extends State<ColumnTypesPage> {
  late final List<Employee> _employees;
  late final _ColumnTypesDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 80);
    _dataSource = _ColumnTypesDataSource(_employees);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Column Types',
      currentRoute: RouteNames.columnTypes,
      body: GridWrapper(
        title: 'Column Type Showcase',
        subtitle: 'Text, numeric, date, and widget columns',
        grid: SfDataGrid(
          source: _dataSource,
          columnWidthMode: ColumnWidthMode.fill,
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
              label: _headerCell('Name'),
            ),
            GridColumn(
              columnName: 'department',
              label: _headerCell('Department'),
            ),
            GridColumn(
              columnName: 'salary',
              label: _headerCell('Salary', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'dateOfJoining',
              width: 140,
              label: _headerCell('Date of Joining'),
            ),
            GridColumn(
              columnName: 'performanceScore',
              width: 140,
              label: _headerCell('Performance', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'status',
              width: 120,
              label: _headerCell('Status', Alignment.center),
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

class _ColumnTypesDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  final List<Employee> _employees;
  static final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  static final _dateFormat = DateFormat('MMM dd, yyyy');

  _ColumnTypesDataSource(this._employees) {
    _rows = _employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.fullName),
              DataGridCell<String>(columnName: 'department', value: e.department),
              DataGridCell<double>(columnName: 'salary', value: e.salary),
              DataGridCell<DateTime>(columnName: 'dateOfJoining', value: e.dateOfJoining),
              DataGridCell<double>(columnName: 'performanceScore', value: e.performanceScore),
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
        switch (cell.columnName) {
          case 'salary':
            return Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _currencyFormat.format(cell.value),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            );
          case 'dateOfJoining':
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_dateFormat.format(cell.value as DateTime)),
            );
          case 'performanceScore':
            final score = cell.value as double;
            return Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: score >= 4.0
                      ? Colors.green.shade700
                      : score >= 2.5
                          ? Colors.orange.shade700
                          : Colors.red.shade700,
                ),
              ),
            );
          case 'status':
            final status = cell.value.toString();
            final isActive = status == 'Active';
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                label: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
                backgroundColor: isActive
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            );
          default:
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                cell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
        }
      }).toList(),
    );
  }
}
