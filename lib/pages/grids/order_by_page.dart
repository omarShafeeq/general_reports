import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/data/generators/order_data_generator.dart';
import 'package:general_reports/models/order.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

/// Demonstrates programmatic row ordering via [DataGridSource.sortedColumns]
/// and [DataGridSource.sort] — similar to SQL `ORDER BY`.
class OrderByPage extends StatefulWidget {
  const OrderByPage({super.key});

  @override
  State<OrderByPage> createState() => _OrderByPageState();
}

class _OrderByPageState extends State<OrderByPage> {
  static const _orderableColumns = {
    'orderDate': 'Order Date',
    'customerName': 'Customer',
    'product': 'Product',
    'totalAmount': 'Total',
    'quantity': 'Qty',
    'status': 'Status',
    'region': 'Region',
  };

  late final _OrderByDataSource _dataSource;
  String _primaryColumn = 'orderDate';
  String? _secondaryColumn;
  DataGridSortDirection _primaryDirection = DataGridSortDirection.descending;
  DataGridSortDirection _secondaryDirection = DataGridSortDirection.ascending;
  bool _caseInsensitiveCustomer = false;

  @override
  void initState() {
    super.initState();
    final orders = OrderDataGenerator.generateOrders(count: 150);
    _dataSource = _OrderByDataSource(orders);
  }

  String get _orderByClause {
    if (_dataSource.sortedColumns.isEmpty) return 'None (original order)';
    return _dataSource.sortedColumns
        .map((s) {
          final label = _orderableColumns[s.name] ?? s.name;
          final dir = s.sortDirection == DataGridSortDirection.ascending
              ? 'ASC'
              : 'DESC';
          return '$label $dir';
        })
        .join(', ');
  }

  void _applyOrderBy() {
    final specs = <SortColumnDetails>[
      SortColumnDetails(
        name: _primaryColumn,
        sortDirection: _primaryDirection,
      ),
      if (_secondaryColumn != null &&
          _secondaryColumn != _primaryColumn)
        SortColumnDetails(
          name: _secondaryColumn!,
          sortDirection: _secondaryDirection,
        ),
    ];
    _dataSource.applyOrderBy(specs);
    setState(() {});
  }

  void _applyPreset(List<SortColumnDetails> specs) {
    if (specs.isNotEmpty) {
      _primaryColumn = specs.first.name;
      _primaryDirection = specs.first.sortDirection;
      _secondaryColumn = specs.length > 1 ? specs[1].name : null;
      _secondaryDirection =
          specs.length > 1 ? specs[1].sortDirection : DataGridSortDirection.ascending;
    }
    _dataSource.applyOrderBy(specs);
    setState(() {});
  }

  void _clearOrderBy() {
    _dataSource.clearOrderBy();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Order By',
      currentRoute: RouteNames.orderByGrid,
      body: GridWrapper(
        title: 'Programmatic Order By',
        subtitle:
            'Sort rows via sortedColumns + sort() without clicking headers — like SQL ORDER BY.',
        toolbar: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Primary:', style: theme.textTheme.bodyMedium),
                SizedBox(
                  width: 160,
                  child: DropdownButtonFormField<String>(
                    value: _primaryColumn,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _orderableColumns.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _primaryColumn = v);
                    },
                  ),
                ),
                SegmentedButton<DataGridSortDirection>(
                  segments: const [
                    ButtonSegment(
                      value: DataGridSortDirection.ascending,
                      label: Text('ASC'),
                      icon: Icon(Icons.arrow_upward, size: 16),
                    ),
                    ButtonSegment(
                      value: DataGridSortDirection.descending,
                      label: Text('DESC'),
                      icon: Icon(Icons.arrow_downward, size: 16),
                    ),
                  ],
                  selected: {_primaryDirection},
                  onSelectionChanged: (v) =>
                      setState(() => _primaryDirection = v.first),
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Then by:', style: theme.textTheme.bodyMedium),
                SizedBox(
                  width: 160,
                  child: DropdownButtonFormField<String?>(
                    value: _secondaryColumn,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('None'),
                      ),
                      ..._orderableColumns.entries
                          .where((e) => e.key != _primaryColumn)
                          .map((e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value),
                              )),
                    ],
                    onChanged: (v) => setState(() => _secondaryColumn = v),
                  ),
                ),
                if (_secondaryColumn != null)
                  SegmentedButton<DataGridSortDirection>(
                    segments: const [
                      ButtonSegment(
                        value: DataGridSortDirection.ascending,
                        label: Text('ASC'),
                      ),
                      ButtonSegment(
                        value: DataGridSortDirection.descending,
                        label: Text('DESC'),
                      ),
                    ],
                    selected: {_secondaryDirection},
                    onSelectionChanged: (v) =>
                        setState(() => _secondaryDirection = v.first),
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _applyOrderBy,
                  icon: const Icon(Icons.sort, size: 18),
                  label: const Text('Apply Order By'),
                ),
                OutlinedButton.icon(
                  onPressed: _clearOrderBy,
                  icon: const Icon(Icons.restart_alt, size: 18),
                  label: const Text('Reset'),
                ),
                FilterChip(
                  label: const Text('Case-insensitive customer'),
                  selected: _caseInsensitiveCustomer,
                  onSelected: (v) {
                    setState(() {
                      _caseInsensitiveCustomer = v;
                      _dataSource.caseInsensitiveCustomer = v;
                      if (_dataSource.sortedColumns.isNotEmpty) {
                        _dataSource.sort();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Presets:',
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: AppSizes.xs),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.xs,
              children: [
                ActionChip(
                  label: const Text('Newest orders first'),
                  onPressed: () => _applyPreset([
                    const SortColumnDetails(
                      name: 'orderDate',
                      sortDirection: DataGridSortDirection.descending,
                    ),
                  ]),
                ),
                ActionChip(
                  label: const Text('Highest total amount'),
                  onPressed: () => _applyPreset([
                    const SortColumnDetails(
                      name: 'totalAmount',
                      sortDirection: DataGridSortDirection.descending,
                    ),
                  ]),
                ),
                ActionChip(
                  label: const Text('Region → Total'),
                  onPressed: () => _applyPreset([
                    const SortColumnDetails(
                      name: 'region',
                      sortDirection: DataGridSortDirection.ascending,
                    ),
                    const SortColumnDetails(
                      name: 'totalAmount',
                      sortDirection: DataGridSortDirection.descending,
                    ),
                  ]),
                ),
                ActionChip(
                  label: const Text('Customer A–Z'),
                  onPressed: () {
                    setState(() => _caseInsensitiveCustomer = true);
                    _dataSource.caseInsensitiveCustomer = true;
                    _applyPreset([
                      const SortColumnDetails(
                        name: 'customerName',
                        sortDirection: DataGridSortDirection.ascending,
                      ),
                    ]);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                'ORDER BY $_orderByClause',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          allowSorting: false,
          showSortNumbers: true,
          columnWidthMode: ColumnWidthMode.fill,
          rowHeight: AppSizes.gridRowHeight,
          headerRowHeight: AppSizes.gridHeaderHeight,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columns: <GridColumn>[
            GridColumn(columnName: 'id', width: 90, label: _headerCell('Order #')),
            GridColumn(
              columnName: 'orderDate',
              width: 120,
              label: _headerCell('Date'),
            ),
            GridColumn(
              columnName: 'customerName',
              label: _headerCell('Customer'),
            ),
            GridColumn(columnName: 'product', label: _headerCell('Product')),
            GridColumn(
              columnName: 'quantity',
              width: 70,
              label: _headerCell('Qty', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'totalAmount',
              width: 110,
              label: _headerCell('Total', Alignment.centerRight),
            ),
            GridColumn(
              columnName: 'status',
              width: 110,
              label: _headerCell('Status'),
            ),
            GridColumn(
              columnName: 'region',
              width: 130,
              label: _headerCell('Region'),
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

class _OrderByDataSource extends DataGridSource {
  _OrderByDataSource(List<Order> orders)
      : _orders = List<Order>.from(orders) {
    _rows = _buildRows(_orders);
  }

  final List<Order> _orders;
  List<DataGridRow> _rows = [];
  bool caseInsensitiveCustomer = false;

  static final _dateFormat = DateFormat('MMM dd, yyyy');

  List<DataGridRow> _buildRows(List<Order> orders) {
    return orders
        .map<DataGridRow>((o) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: o.id),
              DataGridCell<DateTime>(columnName: 'orderDate', value: o.orderDate),
              DataGridCell<String>(
                columnName: 'customerName',
                value: o.customerName,
              ),
              DataGridCell<String>(columnName: 'product', value: o.product),
              DataGridCell<int>(columnName: 'quantity', value: o.quantity),
              DataGridCell<double>(
                columnName: 'totalAmount',
                value: o.totalAmount,
              ),
              DataGridCell<String>(columnName: 'status', value: o.status),
              DataGridCell<String>(columnName: 'region', value: o.region),
            ]))
        .toList();
  }

  void applyOrderBy(List<SortColumnDetails> specs) {
    sortedColumns
      ..clear()
      ..addAll(specs);
    sort();
  }

  void clearOrderBy() {
    sortedColumns.clear();
    _rows = _buildRows(_orders);
    notifyListeners();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    if (caseInsensitiveCustomer && sortColumn.name == 'customerName') {
      final valueA = a
          ?.getCells()
          .firstWhere((c) => c.columnName == 'customerName')
          .value
          ?.toString();
      final valueB = b
          ?.getCells()
          .firstWhere((c) => c.columnName == 'customerName')
          .value
          ?.toString();
      if (valueA == null || valueB == null) return 0;
      final cmp = valueA.toLowerCase().compareTo(valueB.toLowerCase());
      return sortColumn.sortDirection == DataGridSortDirection.ascending
          ? cmp
          : -cmp;
    }
    return super.compare(a, b, sortColumn);
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'status') {
          final status = cell.value.toString();
          final color = switch (status) {
            'Delivered' => Colors.green.shade100,
            'Shipped' => Colors.blue.shade100,
            'Cancelled' => Colors.red.shade100,
            'Pending' => Colors.orange.shade100,
            _ => Colors.grey.shade200,
          };
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              label: Text(status, style: const TextStyle(fontSize: 11)),
              backgroundColor: color,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
          );
        }

        final isNumeric =
            cell.columnName == 'quantity' || cell.columnName == 'totalAmount';
        final text = switch (cell.columnName) {
          'orderDate' => _dateFormat.format(cell.value as DateTime),
          'totalAmount' =>
            '\$${(cell.value as double).toStringAsFixed(2)}',
          _ => cell.value.toString(),
        };

        return Container(
          alignment: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}
