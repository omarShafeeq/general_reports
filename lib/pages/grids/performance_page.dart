import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({super.key});

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  static const int _rowCount = 100000;
  late _PerformanceDataSource _dataSource;
  late Duration _generationTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    setState(() => _isLoading = true);
    final stopwatch = Stopwatch()..start();

    final random = Random(42);
    const firstNames = [
      'James', 'Mary', 'Robert', 'Patricia', 'John', 'Jennifer',
      'Michael', 'Linda', 'David', 'Elizabeth',
    ];
    const lastNames = [
      'Smith', 'Johnson', 'Williams', 'Brown', 'Jones',
      'Garcia', 'Miller', 'Davis', 'Wilson', 'Taylor',
    ];
    const departments = [
      'Sales', 'Marketing', 'Engineering', 'HR',
      'Finance', 'Operations', 'Support', 'Legal',
    ];

    final rows = List<DataGridRow>.generate(_rowCount, (i) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: i + 1),
        DataGridCell<String>(
          columnName: 'name',
          value:
              '${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}',
        ),
        DataGridCell<String>(
          columnName: 'department',
          value: departments[random.nextInt(departments.length)],
        ),
        DataGridCell<int>(
          columnName: 'age',
          value: 22 + random.nextInt(43),
        ),
        DataGridCell<double>(
          columnName: 'salary',
          value: 30000 + random.nextDouble() * 170000,
        ),
        DataGridCell<double>(
          columnName: 'score',
          value: 1.0 + random.nextDouble() * 4.0,
        ),
      ]);
    });

    stopwatch.stop();
    _generationTime = stopwatch.elapsed;
    _dataSource = _PerformanceDataSource(rows);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Performance Grid',
      currentRoute: RouteNames.performanceGrid,
      body: GridWrapper(
        title: 'Performance Test – ${_formatNumber(_rowCount)} Rows',
        subtitle: _isLoading
            ? 'Generating data...'
            : 'Generated in ${_generationTime.inMilliseconds}ms',
        isLoading: _isLoading,
        actions: [
          IconButton(
            onPressed: _generateData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate data',
          ),
        ],
        toolbar: _isLoading
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Data generation: ${_generationTime.inMilliseconds}ms  ·  '
                  'Rows: ${_formatNumber(_rowCount)}  ·  '
                  'Columns: 6',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
        grid: SfDataGrid(
          source: _dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridColumn(
              columnName: 'id',
              label: _headerCell('ID'),
              width: 90,
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
              columnName: 'age',
              label: _headerCell('Age'),
              width: 70,
            ),
            GridColumn(
              columnName: 'salary',
              label: _headerCell('Salary'),
            ),
            GridColumn(
              columnName: 'score',
              label: _headerCell('Score'),
              width: 80,
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

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return n.toString();
  }
}

class _PerformanceDataSource extends DataGridSource {
  _PerformanceDataSource(this._rows);

  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        String text;
        if (cell.columnName == 'salary') {
          text = '\$${(cell.value as double).toStringAsFixed(0)}';
        } else if (cell.columnName == 'score') {
          text = (cell.value as double).toStringAsFixed(2);
        } else {
          text = cell.value?.toString() ?? '';
        }
        return Container(
          alignment: (cell.columnName == 'salary' ||
                  cell.columnName == 'age' ||
                  cell.columnName == 'score')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text),
        );
      }).toList(),
    );
  }
}
