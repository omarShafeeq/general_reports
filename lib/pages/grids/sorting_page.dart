import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

class SortingPage extends StatefulWidget {
  const SortingPage({super.key});

  @override
  State<SortingPage> createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  late final List<Employee> _employees;
  late final _SortingDataSource _dataSource;
  bool _allowMultiSort = true;
  SortingGestureType _gestureType = SortingGestureType.tap;

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 100);
    _dataSource = _SortingDataSource(_employees);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Sorting',
      currentRoute: RouteNames.sortingGrid,
      body: GridWrapper(
        title: 'Column Sorting',
        subtitle: 'Click column headers to sort. ${_allowMultiSort ? 'Hold Ctrl/Cmd and click for multi-column sort.' : 'Single column sort only.'}',
        toolbar: Row(
          children: [
            FilterChip(
              label: const Text('Multi-Column Sort'),
              selected: _allowMultiSort,
              onSelected: (v) => setState(() => _allowMultiSort = v),
            ),
            const SizedBox(width: AppSizes.md),
            Text('Gesture:', style: theme.textTheme.bodyMedium),
            const SizedBox(width: AppSizes.sm),
            SegmentedButton<SortingGestureType>(
              segments: const [
                ButtonSegment(
                  value: SortingGestureType.tap,
                  label: Text('Tap'),
                ),
                ButtonSegment(
                  value: SortingGestureType.doubleTap,
                  label: Text('Double Tap'),
                ),
              ],
              selected: {_gestureType},
              onSelectionChanged: (v) => setState(() => _gestureType = v.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                _dataSource.sortedColumns.clear();
                _dataSource.sort();
              },
              icon: const Icon(Icons.clear_all, size: 20),
              label: const Text('Clear Sort'),
            ),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          allowSorting: true,
          allowMultiColumnSorting: _allowMultiSort,
          allowTriStateSorting: true,
          showSortNumbers: _allowMultiSort,
          sortingGestureType: _gestureType,
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

class _SortingDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  _SortingDataSource(List<Employee> employees) {
    _rows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.fullName),
              DataGridCell<String>(columnName: 'department', value: e.department),
              DataGridCell<String>(columnName: 'designation', value: e.designation),
              DataGridCell<double>(columnName: 'salary', value: e.salary),
              DataGridCell<String>(columnName: 'city', value: e.city),
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
