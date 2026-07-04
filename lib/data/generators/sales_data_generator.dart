import 'dart:math';
import 'package:general_reports/models/sales_data.dart';

abstract final class SalesDataGenerator {
  static final _random = Random(42);

  static const _regions = ['North America', 'Europe', 'Asia', 'Latin America', 'Africa', 'Oceania'];
  static const _products = ['Laptop', 'Smartphone', 'Tablet', 'Headphones', 'Monitor', 'Keyboard', 'Mouse', 'Camera'];
  static const _categories = ['Electronics', 'Accessories', 'Software', 'Services'];
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static List<SalesData> generateDailySales({int days = 365}) {
    final now = DateTime.now();
    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - i));
      final revenue = 5000 + _random.nextDouble() * 45000;
      final cost = revenue * (0.4 + _random.nextDouble() * 0.25);
      return SalesData(
        date: date,
        revenue: revenue,
        cost: cost,
        profit: revenue - cost,
        unitsSold: 10 + _random.nextInt(490),
        region: _regions[_random.nextInt(_regions.length)],
        product: _products[_random.nextInt(_products.length)],
        category: _categories[_random.nextInt(_categories.length)],
      );
    });
  }

  static List<MonthlySales> generateMonthlySales({int months = 12}) {
    return List.generate(months, (i) {
      final amount = 80000 + _random.nextDouble() * 120000;
      return MonthlySales(
        month: _months[i % 12],
        amount: amount,
        target: 100000 + _random.nextDouble() * 50000,
      );
    });
  }

  static List<RegionSales> generateRegionSales() {
    final values = _regions.map((r) => 20000 + _random.nextDouble() * 80000).toList();
    final total = values.reduce((a, b) => a + b);
    return List.generate(_regions.length, (i) {
      return RegionSales(
        region: _regions[i],
        revenue: values[i],
        percentage: (values[i] / total) * 100,
      );
    });
  }

  static List<ProductSales> generateProductSales() {
    return _products.map((p) {
      return ProductSales(
        product: p,
        quantity: 100 + _random.nextInt(5000),
        revenue: 10000 + _random.nextDouble() * 90000,
        growth: -15 + _random.nextDouble() * 40,
      );
    }).toList();
  }

  static List<Map<String, dynamic>> generateForGrid({int count = 200}) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final revenue = 500 + _random.nextDouble() * 50000;
      final cost = revenue * (0.4 + _random.nextDouble() * 0.25);
      return {
        'id': i + 1,
        'date': now.subtract(Duration(days: _random.nextInt(365))),
        'product': _products[_random.nextInt(_products.length)],
        'category': _categories[_random.nextInt(_categories.length)],
        'region': _regions[_random.nextInt(_regions.length)],
        'unitsSold': 1 + _random.nextInt(500),
        'revenue': revenue,
        'cost': cost,
        'profit': revenue - cost,
      };
    });
  }
}
