class SalesData {
  final DateTime date;
  final double revenue;
  final double cost;
  final double profit;
  final int unitsSold;
  final String region;
  final String product;
  final String category;

  const SalesData({
    required this.date,
    required this.revenue,
    required this.cost,
    required this.profit,
    required this.unitsSold,
    required this.region,
    required this.product,
    required this.category,
  });

  double get margin => revenue > 0 ? (profit / revenue) * 100 : 0;
}

class MonthlySales {
  final String month;
  final double amount;
  final double target;

  const MonthlySales({
    required this.month,
    required this.amount,
    required this.target,
  });

  double get achievement => target > 0 ? (amount / target) * 100 : 0;
}

class RegionSales {
  final String region;
  final double revenue;
  final double percentage;

  const RegionSales({
    required this.region,
    required this.revenue,
    required this.percentage,
  });
}

class ProductSales {
  final String product;
  final int quantity;
  final double revenue;
  final double growth;

  const ProductSales({
    required this.product,
    required this.quantity,
    required this.revenue,
    required this.growth,
  });
}
