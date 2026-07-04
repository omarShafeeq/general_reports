class FinanceData {
  final DateTime date;
  final double income;
  final double expenses;
  final double netProfit;
  final String department;
  final String category;

  const FinanceData({
    required this.date,
    required this.income,
    required this.expenses,
    required this.netProfit,
    required this.department,
    required this.category,
  });
}

class BudgetData {
  final String category;
  final double budget;
  final double actual;
  final double variance;

  const BudgetData({
    required this.category,
    required this.budget,
    required this.actual,
    required this.variance,
  });

  double get utilizationPercent => budget > 0 ? (actual / budget) * 100 : 0;
}

class StockData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  const StockData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class CashFlowData {
  final String category;
  final double amount;
  final bool isTotal;

  const CashFlowData({
    required this.category,
    required this.amount,
    this.isTotal = false,
  });
}
