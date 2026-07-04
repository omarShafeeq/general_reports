import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late final List<Employee> _employees;
  late final _SummaryDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 100);
    _dataSource = _SummaryDataSource(_employees);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Table Summary',
      currentRoute: RouteNames.summaryGrid,
      body: GridWrapper(
        title: 'Summary Rows',
        subtitle: 'Aggregate values displayed at the top and bottom of the grid',
        grid: SfDataGrid(
          source: _dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          rowHeight: AppSizes.gridRowHeight,
          headerRowHeight: AppSizes.gridHeaderHeight,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          tableSummaryRows: [
            GridTableSummaryRow(
              showSummaryInRow: false,
              title: 'Summary',
              position: GridTableSummaryRowPosition.top,
              columns: [
                const GridSummaryColumn(
                  name: 'count',
                  columnName: 'id',
                  summaryType: GridSummaryType.count,
                ),
                const GridSummaryColumn(
                  name: 'salarySum',
                  columnName: 'salary',
                  summaryType: GridSummaryType.sum,
                ),
                const GridSummaryColumn(
                  name: 'salaryAvg',
                  columnName: 'salary',
                  summaryType: GridSummaryType.average,
                ),
              ],
            ),
            GridTableSummaryRow(
              showSummaryInRow: true,
              title: 'Total Employees: {count} | Total Salary: \${salarySum} | Average: \${salaryAvg}',
              position: GridTableSummaryRowPosition.bottom,
              columns: [
                const GridSummaryColumn(
                  name: 'count',
                  columnName: 'id',
                  summaryType: GridSummaryType.count,
                ),
                const GridSummaryColumn(
                  name: 'salarySum',
                  columnName: 'salary',
                  summaryType: GridSummaryType.sum,
                ),
                const GridSummaryColumn(
                  name: 'salaryAvg',
                  columnName: 'salary',
                  summaryType: GridSummaryType.average,
                ),
              ],
            ),
          ],
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
              columnName: 'designation',
              label: _headerCell('Designation'),
            ),
            GridColumn(
              columnName: 'salary',
              label: _headerCell('Salary', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'city',
              label: _headerCell('City'),
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

class _SummaryDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  _SummaryDataSource(List<Employee> employees) {
    _rows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.fullName),
              DataGridCell<String>(columnName: 'department', value: e.department),
              DataGridCell<String>(columnName: 'designation', value: e.designation),
              DataGridCell<double>(columnName: 'salary', value: e.salary),
              DataGridCell<String>(columnName: 'city', value: e.city),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        final isNumeric = cell.columnName == 'salary';
        return Container(
          alignment: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            isNumeric
                ? '\$${(cell.value as double).toStringAsFixed(0)}'
                : cell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
