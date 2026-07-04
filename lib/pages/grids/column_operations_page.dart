import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/order_data_generator.dart';
import 'package:general_reports/models/order.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

class ColumnOperationsPage extends StatefulWidget {
  const ColumnOperationsPage({super.key});

  @override
  State<ColumnOperationsPage> createState() => _ColumnOperationsPageState();
}

class _ColumnOperationsPageState extends State<ColumnOperationsPage> {
  late List<Order> _orders;
  late _OrderColumnOpsDataSource _dataSource;
  ColumnWidthMode _columnWidthMode = ColumnWidthMode.fill;
  bool _allowResizing = true;

  final Map<String, bool> _columnVisibility = {
    'id': true,
    'orderDate': true,
    'customer': true,
    'product': true,
    'quantity': true,
    'unitPrice': true,
    'total': true,
    'status': true,
    'region': true,
    'payment': true,
  };

  @override
  void initState() {
    super.initState();
    _orders = OrderDataGenerator.generateOrders(count: 100);
    _dataSource = _OrderColumnOpsDataSource(_orders);
  }

  List<GridColumn> _buildColumns() {
    final defs = <_ColDef>[
      _ColDef('id', 'ID', 80),
      _ColDef('orderDate', 'Order Date', double.nan),
      _ColDef('customer', 'Customer', double.nan),
      _ColDef('product', 'Product', double.nan),
      _ColDef('quantity', 'Qty', 70),
      _ColDef('unitPrice', 'Unit Price', double.nan),
      _ColDef('total', 'Total', double.nan),
      _ColDef('status', 'Status', 120),
      _ColDef('region', 'Region', double.nan),
      _ColDef('payment', 'Payment', double.nan),
    ];

    return defs
        .where((d) => _columnVisibility[d.name] ?? true)
        .map((d) => GridColumn(
              columnName: d.name,
              label: _headerCell(d.label),
              width: d.width,
              visible: _columnVisibility[d.name] ?? true,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Column Operations',
      currentRoute: RouteNames.columnOpsGrid,
      body: GridWrapper(
        title: 'Order Grid – Column Operations',
        subtitle: 'Resize columns · Toggle visibility · Change width mode',
        toolbar: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Width Mode:'),
                SegmentedButton<ColumnWidthMode>(
                  segments: const [
                    ButtonSegment(
                      value: ColumnWidthMode.fill,
                      label: Text('Fill'),
                    ),
                    ButtonSegment(
                      value: ColumnWidthMode.auto,
                      label: Text('Auto'),
                    ),
                    ButtonSegment(
                      value: ColumnWidthMode.lastColumnFill,
                      label: Text('Last Fill'),
                    ),
                    ButtonSegment(
                      value: ColumnWidthMode.none,
                      label: Text('None'),
                    ),
                  ],
                  selected: {_columnWidthMode},
                  onSelectionChanged: (v) =>
                      setState(() => _columnWidthMode = v.first),
                ),
                const SizedBox(width: 16),
                FilterChip(
                  label: const Text('Allow Resizing'),
                  selected: _allowResizing,
                  onSelected: (v) => setState(() => _allowResizing = v),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _columnVisibility.entries.map((entry) {
                return FilterChip(
                  label: Text(entry.key),
                  selected: entry.value,
                  onSelected: (v) {
                    setState(() => _columnVisibility[entry.key] = v);
                  },
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          columnWidthMode: _columnWidthMode,
          allowColumnsResizing: _allowResizing,
          columnResizeMode: ColumnResizeMode.onResize,
          columns: _buildColumns(),
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

class _ColDef {
  final String name;
  final String label;
  final double width;
  const _ColDef(this.name, this.label, this.width);
}

class _OrderColumnOpsDataSource extends DataGridSource {
  _OrderColumnOpsDataSource(List<Order> orders) {
    _rows = orders.map<DataGridRow>((o) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: o.id),
        DataGridCell<String>(
          columnName: 'orderDate',
          value:
              '${o.orderDate.year}-${o.orderDate.month.toString().padLeft(2, '0')}-${o.orderDate.day.toString().padLeft(2, '0')}',
        ),
        DataGridCell<String>(columnName: 'customer', value: o.customerName),
        DataGridCell<String>(columnName: 'product', value: o.product),
        DataGridCell<int>(columnName: 'quantity', value: o.quantity),
        DataGridCell<String>(
          columnName: 'unitPrice',
          value: '\$${o.unitPrice.toStringAsFixed(2)}',
        ),
        DataGridCell<String>(
          columnName: 'total',
          value: '\$${o.totalAmount.toStringAsFixed(2)}',
        ),
        DataGridCell<String>(columnName: 'status', value: o.status),
        DataGridCell<String>(columnName: 'region', value: o.region),
        DataGridCell<String>(columnName: 'payment', value: o.paymentMethod),
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
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(cell.value?.toString() ?? ''),
        );
      }).toList(),
    );
  }
}
