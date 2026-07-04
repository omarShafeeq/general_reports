class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stockQuantity;
  final int reorderLevel;
  final String supplier;
  final double rating;
  final String status;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stockQuantity,
    required this.reorderLevel,
    required this.supplier,
    required this.rating,
    required this.status,
  });

  bool get isLowStock => stockQuantity <= reorderLevel;
  bool get isOutOfStock => stockQuantity == 0;
}

class InventoryData {
  final String category;
  final int totalItems;
  final int inStock;
  final int lowStock;
  final int outOfStock;
  final double totalValue;

  const InventoryData({
    required this.category,
    required this.totalItems,
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
    required this.totalValue,
  });
}
