import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:general_reports/data/generators/inventory_data_generator.dart';
import 'package:general_reports/models/product.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/grids/grid_wrapper.dart';

class StylingPage extends StatefulWidget {
  const StylingPage({super.key});

  @override
  State<StylingPage> createState() => _StylingPageState();
}

class _StylingPageState extends State<StylingPage> {
  late List<Product> _products;
  late _StyledProductDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _products = InventoryDataGenerator.generateProducts(count: 100);
    _dataSource = _StyledProductDataSource(_products);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ResponsiveScaffold(
      title: 'Styling Grid',
      currentRoute: RouteNames.stylingGrid,
      body: GridWrapper(
        title: 'Product Inventory – Conditional Styling',
        subtitle: 'Alternating rows · Status-based coloring · Hover highlight',
        toolbar: Wrap(
          spacing: 16,
          children: [
            _legendChip('In Stock', Colors.green.shade50, Colors.green),
            _legendChip('Low Stock', Colors.orange.shade50, Colors.orange),
            _legendChip('Out of Stock', Colors.red.shade50, Colors.red),
          ],
        ),
        grid: SfDataGrid(
          source: _dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          highlightRowOnHover: true,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          headerRowHeight: 56,
          columns: [
            GridColumn(
              columnName: 'id',
              label: _styledHeaderCell('ID', colorScheme),
              width: 70,
            ),
            GridColumn(
              columnName: 'name',
              label: _styledHeaderCell('Product', colorScheme),
            ),
            GridColumn(
              columnName: 'category',
              label: _styledHeaderCell('Category', colorScheme),
            ),
            GridColumn(
              columnName: 'price',
              label: _styledHeaderCell('Price', colorScheme),
              width: 100,
            ),
            GridColumn(
              columnName: 'stock',
              label: _styledHeaderCell('Stock', colorScheme),
              width: 80,
            ),
            GridColumn(
              columnName: 'reorderLevel',
              label: _styledHeaderCell('Reorder Lvl', colorScheme),
              width: 100,
            ),
            GridColumn(
              columnName: 'rating',
              label: _styledHeaderCell('Rating', colorScheme),
              width: 80,
            ),
            GridColumn(
              columnName: 'status',
              label: _styledHeaderCell('Status', colorScheme),
              width: 120,
            ),
          ],
        ),
      ),
    );
  }

  Widget _styledHeaderCell(String text, ColorScheme cs) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: cs.primaryContainer,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: cs.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _legendChip(String label, Color bg, Color fg) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: fg, radius: 6),
      label: Text(label, style: TextStyle(fontSize: 12, color: fg)),
      backgroundColor: bg,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _StyledProductDataSource extends DataGridSource {
  _StyledProductDataSource(this._products) {
    _rows = _products.map<DataGridRow>((p) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: p.id),
        DataGridCell<String>(columnName: 'name', value: p.name),
        DataGridCell<String>(columnName: 'category', value: p.category),
        DataGridCell<double>(columnName: 'price', value: p.price),
        DataGridCell<int>(columnName: 'stock', value: p.stockQuantity),
        DataGridCell<int>(
            columnName: 'reorderLevel', value: p.reorderLevel),
        DataGridCell<double>(columnName: 'rating', value: p.rating),
        DataGridCell<String>(columnName: 'status', value: p.status),
      ]);
    }).toList();
  }

  final List<Product> _products;
  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final rowIndex = _rows.indexOf(row);
    final status =
        row.getCells().firstWhere((c) => c.columnName == 'status').value
            as String;

    Color? rowColor;
    if (status == 'Out of Stock') {
      rowColor = Colors.red.shade50;
    } else if (status == 'Low Stock') {
      rowColor = Colors.orange.shade50;
    } else if (rowIndex.isEven) {
      rowColor = Colors.grey.shade50;
    }

    return DataGridRowAdapter(
      color: rowColor,
      cells: row.getCells().map<Widget>((cell) {
        Widget child;
        if (cell.columnName == 'price') {
          child = Text('\$${(cell.value as double).toStringAsFixed(2)}');
        } else if (cell.columnName == 'rating') {
          final rating = cell.value as double;
          child = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                rating >= 4
                    ? Icons.star
                    : rating >= 2.5
                        ? Icons.star_half
                        : Icons.star_border,
                size: 16,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(rating.toStringAsFixed(1)),
            ],
          );
        } else if (cell.columnName == 'status') {
          final color = switch (cell.value as String) {
            'In Stock' => Colors.green,
            'Low Stock' => Colors.orange,
            'Out of Stock' => Colors.red,
            _ => Colors.grey,
          };
          child = Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 0.5),
            ),
            child: Text(
              cell.value.toString(),
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          );
        } else if (cell.columnName == 'stock') {
          final stock = cell.value as int;
          child = Text(
            stock.toString(),
            style: TextStyle(
              color: stock == 0
                  ? Colors.red
                  : stock < 30
                      ? Colors.orange
                      : null,
              fontWeight: stock <= 30 ? FontWeight.w600 : null,
            ),
          );
        } else {
          child = Text(cell.value?.toString() ?? '');
        }

        return Container(
          alignment: (cell.columnName == 'price' ||
                  cell.columnName == 'stock' ||
                  cell.columnName == 'reorderLevel')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        );
      }).toList(),
    );
  }
}
