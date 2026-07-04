import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/hr_data_generator.dart';
import 'package:general_reports/models/employee.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

class FilteringPage extends StatefulWidget {
  const FilteringPage({super.key});

  @override
  State<FilteringPage> createState() => _FilteringPageState();
}

class _FilteringPageState extends State<FilteringPage> {
  late final List<Employee> _employees;
  late final _FilteringDataSource _dataSource;
  final _searchController = TextEditingController();
  String? _departmentFilter;

  static const _departments = [
    'All',
    'Sales',
    'Marketing',
    'Engineering',
    'HR',
    'Finance',
    'Operations',
    'Support',
    'Legal',
  ];

  @override
  void initState() {
    super.initState();
    _employees = HrDataGenerator.generateEmployees(count: 100);
    _dataSource = _FilteringDataSource(_employees);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applySearch(String query) {
    _dataSource.applySearch(query, _departmentFilter);
  }

  void _applyDepartmentFilter(String? department) {
    setState(() {
      _departmentFilter = department == 'All' ? null : department;
    });
    _dataSource.applySearch(_searchController.text, _departmentFilter);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() => _departmentFilter = null);
    _dataSource.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Filtering',
      currentRoute: RouteNames.filteringGrid,
      body: GridWrapper(
        title: 'Data Filtering',
        subtitle: 'Use the search bar, department filter, or column filter icons',
        toolbar: Row(
          children: [
            SizedBox(
              width: 280,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search across all columns...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  suffixIcon: ListenableBuilder(
                    listenable: _searchController,
                    builder: (_, __) {
                      if (_searchController.text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _applySearch('');
                        },
                      );
                    },
                  ),
                ),
                onChanged: _applySearch,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            DropdownButton<String>(
              value: _departmentFilter ?? 'All',
              hint: const Text('Department'),
              isDense: true,
              items: _departments
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: _applyDepartmentFilter,
            ),
            const SizedBox(width: AppSizes.sm),
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.filter_alt_off, size: 20),
              label: const Text('Clear All'),
            ),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          allowFiltering: true,
          allowSorting: true,
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

class _FilteringDataSource extends DataGridSource {
  final List<Employee> _allEmployees;
  List<DataGridRow> _rows = [];

  _FilteringDataSource(this._allEmployees) {
    _buildRows(_allEmployees);
  }

  void _buildRows(List<Employee> employees) {
    _rows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.fullName),
              DataGridCell<String>(columnName: 'department', value: e.department),
              DataGridCell<String>(columnName: 'designation', value: e.designation),
              DataGridCell<double>(columnName: 'salary', value: e.salary),
              DataGridCell<String>(columnName: 'city', value: e.city),
              DataGridCell<String>(columnName: 'status', value: e.status),
            ]))
        .toList();
  }

  void applySearch(String query, String? departmentFilter) {
    final lowerQuery = query.toLowerCase();
    final filtered = _allEmployees.where((e) {
      final matchesDepartment =
          departmentFilter == null || e.department == departmentFilter;
      if (!matchesDepartment) return false;
      if (query.isEmpty) return true;
      return e.fullName.toLowerCase().contains(lowerQuery) ||
          e.department.toLowerCase().contains(lowerQuery) ||
          e.designation.toLowerCase().contains(lowerQuery) ||
          e.city.toLowerCase().contains(lowerQuery) ||
          e.status.toLowerCase().contains(lowerQuery) ||
          e.salary.toStringAsFixed(0).contains(lowerQuery);
    }).toList();
    _buildRows(filtered);
    notifyListeners();
  }

  @override
  void clearFilters({String? columnName}) {
    _buildRows(_allEmployees);
    notifyListeners();
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
