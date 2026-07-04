import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/order_data_generator.dart';
import 'package:general_reports/models/order.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

class PagingPage extends StatefulWidget {
  const PagingPage({super.key});

  @override
  State<PagingPage> createState() => _PagingPageState();
}

class _PagingPageState extends State<PagingPage> {
  late List<Order> _orders;
  late _OrderPagingDataSource _dataSource;
  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _orders = OrderDataGenerator.generateOrders(count: 300);
    _dataSource = _OrderPagingDataSource(_orders, _rowsPerPage);
  }

  void _updatePageSize(int size) {
    setState(() {
      _rowsPerPage = size;
      _dataSource = _OrderPagingDataSource(_orders, _rowsPerPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Paging Grid',
      currentRoute: RouteNames.pagingGrid,
      body: GridWrapper(
        title: 'Orders with Pagination',
        subtitle: '${_orders.length} orders · $_rowsPerPage rows per page',
        toolbar: Row(
          children: [
            const Text('Rows per page: '),
            const SizedBox(width: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 10, label: Text('10')),
                ButtonSegment(value: 20, label: Text('20')),
                ButtonSegment(value: 50, label: Text('50')),
              ],
              selected: {_rowsPerPage},
              onSelectionChanged: (v) => _updatePageSize(v.first),
            ),
          ],
        ),
        grid: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SfDataGrid(
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
                        columnName: 'total',
                        label: _headerCell('Total'),
                      ),
                      GridColumn(
                        columnName: 'status',
                        label: _headerCell('Status'),
                      ),
                    ],
                  ),
                ),
                SfDataPager(
                  delegate: _dataSource,
                  pageCount:
                      (_orders.length / _rowsPerPage).ceilToDouble(),
                  direction: Axis.horizontal,
                ),
              ],
            );
          },
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

class _OrderPagingDataSource extends DataGridSource {
  final List<Order> _orders;
  final int _rowsPerPage;
  List<DataGridRow> _paginatedRows = [];

  _OrderPagingDataSource(this._orders, this._rowsPerPage) {
    _paginatedRows = _buildRows(0);
  }

  List<DataGridRow> _buildRows(int startIndex) {
    final end = (startIndex + _rowsPerPage).clamp(0, _orders.length);
    return _orders.getRange(startIndex, end).map<DataGridRow>((order) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: order.id),
        DataGridCell<String>(
          columnName: 'orderDate',
          value:
              '${order.orderDate.year}-${order.orderDate.month.toString().padLeft(2, '0')}-${order.orderDate.day.toString().padLeft(2, '0')}',
        ),
        DataGridCell<String>(
            columnName: 'customer', value: order.customerName),
        DataGridCell<String>(columnName: 'product', value: order.product),
        DataGridCell<int>(columnName: 'quantity', value: order.quantity),
        DataGridCell<String>(
          columnName: 'total',
          value: '\$${order.totalAmount.toStringAsFixed(2)}',
        ),
        DataGridCell<String>(columnName: 'status', value: order.status),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _paginatedRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final startIndex = newPageIndex * _rowsPerPage;
    if (startIndex < _orders.length) {
      _paginatedRows = _buildRows(startIndex);
      notifyListeners();
    }
    return true;
  }

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
