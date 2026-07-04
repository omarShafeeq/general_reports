import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:general_reports/data/generators/order_data_generator.dart';
import 'package:general_reports/models/order.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final GlobalKey<SfDataGridState> _gridKey = GlobalKey<SfDataGridState>();
  late List<Order> _orders;
  late _ExportOrderDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _orders = OrderDataGenerator.generateOrders(count: 200);
    _dataSource = _ExportOrderDataSource(_orders);
  }

  void _exportToExcel() {
    final workbook = _gridKey.currentState!.exportToExcelWorkbook();
    workbook.dispose();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel export complete')),
      );
    }
  }

  void _exportToPdf() {
    final document = _gridKey.currentState!.exportToPdfDocument();
    document.dispose();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF export complete')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Export Grid',
      currentRoute: RouteNames.exportGrid,
      body: GridWrapper(
        title: 'Order Data – Export',
        subtitle: '${_orders.length} orders',
        toolbar: Row(
          children: [
            FilledButton.icon(
              onPressed: _exportToExcel,
              icon: const Icon(Icons.table_chart_outlined),
              label: const Text('Export to Excel'),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: _exportToPdf,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.picture_as_pdf_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Export to PDF'),
                ],
              ),
            ),
          ],
        ),
        grid: SfDataGrid(
          key: _gridKey,
          source: _dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridColumn(
              columnName: 'id',
              label: _headerCell('ID'),
              width: 80,
            ),
            GridColumn(
              columnName: 'orderDate',
              label: _headerCell('Order Date'),
            ),
            GridColumn(
              columnName: 'customer',
              label: _headerCell('Customer'),
            ),
            GridColumn(
              columnName: 'product',
              label: _headerCell('Product'),
            ),
            GridColumn(
              columnName: 'quantity',
              label: _headerCell('Qty'),
              width: 70,
            ),
            GridColumn(
              columnName: 'unitPrice',
              label: _headerCell('Unit Price'),
            ),
            GridColumn(
              columnName: 'total',
              label: _headerCell('Total'),
            ),
            GridColumn(
              columnName: 'status',
              label: _headerCell('Status'),
              width: 120,
            ),
            GridColumn(
              columnName: 'region',
              label: _headerCell('Region'),
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

class _ExportOrderDataSource extends DataGridSource {
  _ExportOrderDataSource(List<Order> orders) {
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
