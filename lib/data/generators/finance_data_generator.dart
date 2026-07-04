import 'dart:math';
import 'package:general_reports/models/finance_data.dart';

abstract final class FinanceDataGenerator {
  static final _random = Random(43);

  static const _departments = ['Sales', 'Marketing', 'Engineering', 'HR', 'Finance', 'Operations'];
  static const _expenseCategories = ['Salaries', 'Marketing', 'R&D', 'Infrastructure', 'Travel', 'Utilities', 'Insurance'];

  static List<FinanceData> generateMonthlyFinance({int months = 12}) {
    final now = DateTime.now();
    return List.generate(months, (i) {
      final date = DateTime(now.year, now.month - months + i + 1, 1);
      final income = 200000 + _random.nextDouble() * 300000;
      final expenses = income * (0.6 + _random.nextDouble() * 0.25);
      return FinanceData(
        date: date,
        income: income,
        expenses: expenses,
        netProfit: income - expenses,
        department: _departments[_random.nextInt(_departments.length)],
        category: _expenseCategories[_random.nextInt(_expenseCategories.length)],
      );
    });
  }

  static List<BudgetData> generateBudgetData() {
    return _expenseCategories.map((cat) {
      final budget = 50000 + _random.nextDouble() * 150000;
      final actual = budget * (0.7 + _random.nextDouble() * 0.5);
      return BudgetData(
        category: cat,
        budget: budget,
        actual: actual,
        variance: actual - budget,
      );
    }).toList();
  }

  static List<StockData> generateStockData({int days = 180}) {
    final now = DateTime.now();
    double prevClose = 150 + _random.nextDouble() * 50;
    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - i));
      final change = (_random.nextDouble() - 0.48) * 8;
      final open = prevClose + change;
      final high = open + _random.nextDouble() * 5;
      final low = open - _random.nextDouble() * 5;
      final close = low + _random.nextDouble() * (high - low);
      prevClose = close;
      return StockData(
        date: date,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: 100000 + _random.nextInt(900000),
      );
    });
  }

  static List<CashFlowData> generateCashFlow() {
    return const [
      CashFlowData(category: 'Revenue', amount: 450000),
      CashFlowData(category: 'COGS', amount: -180000),
      CashFlowData(category: 'Gross Profit', amount: 270000, isTotal: true),
      CashFlowData(category: 'Salaries', amount: -95000),
      CashFlowData(category: 'Marketing', amount: -35000),
      CashFlowData(category: 'R&D', amount: -42000),
      CashFlowData(category: 'Utilities', amount: -12000),
      CashFlowData(category: 'Net Income', amount: 86000, isTotal: true),
    ];
  }
}
