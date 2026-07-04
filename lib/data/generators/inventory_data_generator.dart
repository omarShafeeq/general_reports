import 'dart:math';
import 'package:general_reports/models/product.dart';

abstract final class InventoryDataGenerator {
  static final _random = Random(45);

  static const _categories = ['Electronics', 'Clothing', 'Food & Beverage', 'Office Supplies', 'Furniture', 'Hardware'];
  static const _suppliers = ['Acme Corp', 'GlobalTech', 'PrimeParts', 'MetroSupply', 'TechSource', 'ValueWare'];
  static const _productNames = [
    'Wireless Mouse', 'Mechanical Keyboard', 'USB Hub', 'Monitor Stand', 'Desk Lamp',
    'Webcam HD', 'Noise Canceling Headphones', 'Laptop Stand', 'External SSD', 'Ergonomic Chair',
    'Standing Desk', 'Whiteboard', 'Projector', 'Router', 'Docking Station',
    'Cable Kit', 'Surge Protector', 'Bluetooth Speaker', 'Drawing Tablet', 'Microphone',
    'Printer Paper', 'Ink Cartridge', 'Binder Set', 'Sticky Notes', 'File Cabinet',
    'Safety Goggles', 'Work Gloves', 'Tool Kit', 'First Aid Kit', 'Fire Extinguisher',
  ];

  static List<Product> generateProducts({int count = 100}) {
    return List.generate(count, (i) {
      final stock = _random.nextInt(500);
      final reorder = 20 + _random.nextInt(80);
      String status;
      if (stock == 0) {
        status = 'Out of Stock';
      } else if (stock <= reorder) {
        status = 'Low Stock';
      } else {
        status = 'In Stock';
      }
      return Product(
        id: 5000 + i,
        name: _productNames[i % _productNames.length],
        category: _categories[_random.nextInt(_categories.length)],
        price: 5 + _random.nextDouble() * 995,
        stockQuantity: stock,
        reorderLevel: reorder,
        supplier: _suppliers[_random.nextInt(_suppliers.length)],
        rating: 1 + _random.nextDouble() * 4,
        status: status,
      );
    });
  }

  static List<InventoryData> generateInventorySummary() {
    return _categories.map((cat) {
      final total = 50 + _random.nextInt(200);
      final outOfStock = _random.nextInt(10);
      final lowStock = _random.nextInt(20);
      final inStock = total - outOfStock - lowStock;
      return InventoryData(
        category: cat,
        totalItems: total,
        inStock: inStock,
        lowStock: lowStock,
        outOfStock: outOfStock,
        totalValue: 10000 + _random.nextDouble() * 90000,
      );
    }).toList();
  }
}
