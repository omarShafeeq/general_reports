import 'dart:math';

import '../models/filter_definition.dart';
import 'report_repository.dart';

class MockReportRepository implements ReportRepository {
  final _random = Random(42);

  @override
  Future<Map<String, dynamic>> fetchReportData(
    String datasource,
    Map<String, dynamic> params,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    switch (datasource) {
      case 'sales-overview':
        return _salesOverviewData(params);
      case 'finance-summary':
        return _financeSummaryData(params);
      case 'inventory-status':
        return _inventoryStatusData(params);
      case 'sales-by-country':
        return _salesByCountryData(params);
      case 'sales-by-customer':
        return _salesByCustomerData(params);
      case 'hr-overview':
        return _hrOverviewData(params);
      default:
        return _salesOverviewData(params);
    }
  }

  @override
  Future<List<FilterOption>> fetchFilterOptions(
    String endpoint,
    Map<String, dynamic> parentParams,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    switch (endpoint) {
      case '/api/regions':
        return _regionOptions();
      case '/api/countries':
        return _countryOptions(parentParams['region'] as String?);
      case '/api/cities':
        return _cityOptions(parentParams['country'] as String?);
      case '/api/categories':
        return _categoryOptions();
      case '/api/statuses':
        return _statusOptions();
      case '/api/departments':
        return _departmentOptions();
      case '/api/products':
        return _productOptions();
      default:
        return [];
    }
  }

  // ── Sales Overview ──────────────────────────────────────────────────

  Map<String, dynamic> _salesOverviewData(Map<String, dynamic> params) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final monthlyTrend = <Map<String, dynamic>>[];
    double cumulative = 0;
    for (var i = 0; i < months.length; i++) {
      final revenue = 50000 + _random.nextDouble() * 80000;
      cumulative += revenue;
      monthlyTrend.add({
        'month': months[i],
        'revenue': revenue.round(),
        'orders': 200 + _random.nextInt(300),
        'profit': (revenue * (0.15 + _random.nextDouble() * 0.2)).round(),
      });
    }

    final regions = ['North America', 'Europe', 'Asia Pacific', 'Middle East', 'Latin America'];
    final regionSales = regions.map((r) => {
      'region': r,
      'revenue': (80000 + _random.nextDouble() * 200000).round(),
      'orders': 500 + _random.nextInt(2000),
      'growth': (_random.nextDouble() * 30 - 5).roundToDouble(),
    }).toList();

    final orderDetails = List.generate(12, (i) {
      final region = regions[_random.nextInt(regions.length)];
      final orderDate = DateTime(2025, 1 + _random.nextInt(6), 1 + _random.nextInt(28));
      final shipDate = orderDate.add(Duration(days: 1 + _random.nextInt(10)));
      final total = (500 + _random.nextDouble() * 15000).roundToDouble();
      return {
        'orderId': 'ORD-${10000 + i}',
        'orderDate': orderDate.toIso8601String().substring(0, 10),
        'invoiceNumber': 'INV-${20000 + i}',
        'shipDate': shipDate.toIso8601String().substring(0, 10),
        'shipmentStatus': ['Delivered', 'In Transit', 'Pending', 'Cancelled'][_random.nextInt(4)],
        'customer': _customerNames[_random.nextInt(_customerNames.length)],
        'region': region,
        'product': _productNames[_random.nextInt(_productNames.length)],
        'quantity': 1 + _random.nextInt(50),
        'unitPrice': (10 + _random.nextDouble() * 500).roundToDouble(),
        'total': total,
        'date': orderDate.toIso8601String().substring(0, 10),
        'status': ['Completed', 'Pending', 'Shipped', 'Cancelled'][_random.nextInt(4)],
      };
    });

    return {
      'totalRevenue': cumulative.round(),
      'totalRevenueTrend': 12.5,
      'totalOrders': orderDetails.length * 20,
      'totalOrdersTrend': 8.3,
      'avgOrderValue': (cumulative / (orderDetails.length * 20)).round(),
      'avgOrderValueTrend': 4.1,
      'conversionRate': 3.2,
      'conversionRateTrend': -0.5,
      'monthlyTrend': monthlyTrend,
      'regionSales': regionSales,
      'orderDetails': orderDetails,
    };
  }

  // ── Finance Summary ─────────────────────────────────────────────────

  Map<String, dynamic> _financeSummaryData(Map<String, dynamic> params) {
    final quarters = ['Q1', 'Q2', 'Q3', 'Q4'];
    final quarterlyPnL = quarters.map((q) => {
      'quarter': q,
      'revenue': (200000 + _random.nextDouble() * 300000).round(),
      'expenses': (150000 + _random.nextDouble() * 200000).round(),
      'profit': (30000 + _random.nextDouble() * 100000).round(),
    }).toList();

    final categories = ['Salaries', 'Marketing', 'R&D', 'Operations', 'Infrastructure', 'Legal'];
    final expenseBreakdown = categories.map((c) => {
      'category': c,
      'amount': (20000 + _random.nextDouble() * 150000).round(),
    }).toList();

    final transactions = List.generate(40, (i) => {
      'transactionId': 'TXN-${20000 + i}',
      'date': '2025-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}',
      'description': _transactionDescs[_random.nextInt(_transactionDescs.length)],
      'category': categories[_random.nextInt(categories.length)],
      'amount': (_random.nextBool() ? 1 : -1) * (500 + _random.nextDouble() * 50000).round(),
      'type': _random.nextBool() ? 'Credit' : 'Debit',
    });

    final totalRevenue = quarterlyPnL.fold<int>(0, (sum, q) => sum + (q['revenue'] as int));
    final totalExpenses = quarterlyPnL.fold<int>(0, (sum, q) => sum + (q['expenses'] as int));

    return {
      'totalProfit': totalRevenue - totalExpenses,
      'totalProfitTrend': 15.2,
      'totalExpenses': totalExpenses,
      'totalExpensesTrend': -3.1,
      'profitMargin': ((totalRevenue - totalExpenses) / totalRevenue * 100).roundToDouble(),
      'profitMarginTrend': 2.4,
      'operatingCashFlow': (totalRevenue * 0.3).round(),
      'operatingCashFlowTrend': 7.8,
      'quarterlyPnL': quarterlyPnL,
      'expenseBreakdown': expenseBreakdown,
      'transactions': transactions,
    };
  }

  // ── Inventory Status ────────────────────────────────────────────────

  Map<String, dynamic> _inventoryStatusData(Map<String, dynamic> params) {
    final categories = ['Electronics', 'Clothing', 'Food & Beverage', 'Furniture', 'Automotive', 'Office Supplies'];
    final byCategory = categories.map((c) => {
      'category': c,
      'count': 100 + _random.nextInt(2000),
      'value': (10000 + _random.nextDouble() * 500000).round(),
    }).toList();

    final products = List.generate(45, (i) {
      final cat = categories[_random.nextInt(categories.length)];
      final stock = _random.nextInt(500);
      final reorder = 20 + _random.nextInt(80);
      return {
        'sku': 'SKU-${1000 + i}',
        'name': _productNames[_random.nextInt(_productNames.length)],
        'category': cat,
        'stock': stock,
        'reorderLevel': reorder,
        'unitCost': (5 + _random.nextDouble() * 300).roundToDouble(),
        'totalValue': (stock * (5 + _random.nextDouble() * 300)).round(),
        'status': stock <= reorder ? 'Low Stock' : (stock > reorder * 3 ? 'Overstocked' : 'Normal'),
        'lastRestocked': '2025-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}',
      };
    });

    final totalItems = products.fold<int>(0, (sum, p) => sum + (p['stock'] as int));
    final lowStockCount = products.where((p) => p['status'] == 'Low Stock').length;

    return {
      'totalItems': totalItems,
      'totalItemsTrend': 5.2,
      'lowStockCount': lowStockCount,
      'lowStockCountTrend': -12.0,
      'totalValue': products.fold<int>(0, (sum, p) => sum + (p['totalValue'] as int)),
      'totalValueTrend': 8.7,
      'turnoverRate': 4.2,
      'turnoverRateTrend': 1.3,
      'byCategory': byCategory,
      'products': products,
    };
  }

  // ── Drill-Down Data ─────────────────────────────────────────────────

  Map<String, dynamic> _salesByCountryData(Map<String, dynamic> params) {
    final region = params['region'] as String? ?? 'North America';
    final countries = _countriesByRegion[region] ?? ['Unknown'];

    final countryData = countries.map((c) => {
      'country': c,
      'revenue': (20000 + _random.nextDouble() * 150000).round(),
      'orders': 100 + _random.nextInt(1000),
      'growth': (_random.nextDouble() * 40 - 10).roundToDouble(),
    }).toList();

    return {
      'totalRevenue': countryData.fold<int>(0, (s, c) => s + (c['revenue'] as int)),
      'totalRevenueTrend': 9.5,
      'totalOrders': countryData.fold<int>(0, (s, c) => s + (c['orders'] as int)),
      'totalOrdersTrend': 6.2,
      'countrySales': countryData,
      'countryDetails': countryData,
    };
  }

  Map<String, dynamic> _salesByCustomerData(Map<String, dynamic> params) {
    final customers = List.generate(30, (i) {
      return {
        'customer': _customerNames[i % _customerNames.length],
        'orders': 5 + _random.nextInt(100),
        'revenue': (5000 + _random.nextDouble() * 100000).round(),
        'lastOrder': '2025-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}',
      };
    });

    return {
      'totalRevenue': customers.fold<int>(0, (s, c) => s + (c['revenue'] as int)),
      'totalRevenueTrend': 11.0,
      'customerSales': customers,
      'customerDetails': customers,
    };
  }

  // ── HR Overview ─────────────────────────────────────────────────────

  Map<String, dynamic> _hrOverviewData(Map<String, dynamic> params) {
    final departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations'];
    final deptDist = departments.map((d) => {
      'department': d,
      'count': 15 + _random.nextInt(60),
    }).toList();

    final tenureRanges = ['< 1 year', '1-3 years', '3-5 years', '5-10 years', '> 10 years'];
    final tenureDist = tenureRanges.map((r) => {
      'range': r,
      'count': 10 + _random.nextInt(50),
    }).toList();

    final employees = List.generate(50, (i) {
      final dept = departments[_random.nextInt(departments.length)];
      final positions = ['Engineer', 'Manager', 'Analyst', 'Director', 'Coordinator', 'Specialist'];
      return {
        'employeeId': 'EMP-${1000 + i}',
        'name': _employeeNames[i % _employeeNames.length],
        'department': dept,
        'position': positions[_random.nextInt(positions.length)],
        'salary': (45000 + _random.nextInt(100000)),
        'hireDate': '${2015 + _random.nextInt(10)}-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}',
        'status': _random.nextDouble() > 0.1 ? 'Active' : 'On Leave',
      };
    });

    return {
      'totalEmployees': employees.length,
      'employeeTrend': 3.2,
      'avgSalary': employees.fold<int>(0, (s, e) => s + (e['salary'] as int)) ~/ employees.length,
      'salaryTrend': 4.5,
      'turnoverRate': 8.3,
      'turnoverTrend': -1.2,
      'openPositions': 12,
      'openPositionsTrend': 25.0,
      'departmentDistribution': deptDist,
      'tenureDistribution': tenureDist,
      'employees': employees,
    };
  }

  // ── Child Data (Master-Detail) ──────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> fetchChildData({
    required String childDatasource,
    required String parentKeyField,
    required dynamic parentKeyValue,
    Map<String, dynamic> params = const {},
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    switch (childDatasource) {
      case 'order-details':
        return _orderDetailsData(parentKeyValue);
      case 'invoice-details':
        return _invoiceDetailsData(parentKeyValue);
      case 'payment-details':
        return _paymentDetailsData(parentKeyValue);
      case 'shipment-details':
        return _shipmentDetailsData(parentKeyValue);
      case 'order-items':
        return _orderItemsData(parentKeyValue);
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _orderDetailsData(dynamic orderId) {
    return List.generate(2 + _random.nextInt(4), (i) {
      final qty = 1 + _random.nextInt(20);
      final unitPrice = (10 + _random.nextDouble() * 200).roundToDouble();
      final discount = (_random.nextDouble() * 0.15);
      final total = qty * unitPrice * (1 - discount);
      return {
        'lineId': '$orderId-L${i + 1}',
        'product': _productNames[_random.nextInt(_productNames.length)],
        'quantity': qty,
        'unitPrice': unitPrice,
        'discount': discount,
        'total': total,
      };
    });
  }

  List<Map<String, dynamic>> _invoiceDetailsData(dynamic lineId) {
    return [
      {
        'invoiceId': 'INV-${_random.nextInt(90000) + 10000}',
        'date': '2025-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}',
        'amount': (100 + _random.nextDouble() * 5000).round(),
        'tax': (_random.nextDouble() * 500).round(),
        'status': ['Paid', 'Pending', 'Overdue'][_random.nextInt(3)],
      },
    ];
  }

  List<Map<String, dynamic>> _paymentDetailsData(dynamic invoiceId) {
    return List.generate(1 + _random.nextInt(2), (i) => {
      'paymentId': 'PAY-${_random.nextInt(90000) + 10000}',
      'date': '2025-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}',
      'amount': (50 + _random.nextDouble() * 3000).round(),
      'method': ['Credit Card', 'Bank Transfer', 'PayPal', 'Check'][_random.nextInt(4)],
      'reference': 'REF-${_random.nextInt(900000) + 100000}',
    });
  }

  List<Map<String, dynamic>> _shipmentDetailsData(dynamic orderId) {
    return [
      {
        'shipmentId': 'SHP-${_random.nextInt(90000) + 10000}',
        'carrier': ['FedEx', 'UPS', 'DHL', 'USPS'][_random.nextInt(4)],
        'trackingNumber': 'TRK${_random.nextInt(9000000) + 1000000}',
        'shippedDate': '2025-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}',
        'deliveredDate': _random.nextBool() ? '2025-${(1 + _random.nextInt(12)).toString().padLeft(2, '0')}-${(1 + _random.nextInt(28)).toString().padLeft(2, '0')}' : null,
        'status': ['In Transit', 'Delivered', 'Out for Delivery'][_random.nextInt(3)],
      },
    ];
  }

  List<Map<String, dynamic>> _orderItemsData(dynamic orderId) {
    return List.generate(1 + _random.nextInt(6), (i) => {
      'itemId': '$orderId-I${i + 1}',
      'product': _productNames[_random.nextInt(_productNames.length)],
      'quantity': 1 + _random.nextInt(10),
      'unitPrice': (15 + _random.nextDouble() * 300).roundToDouble(),
      'total': (30 + _random.nextDouble() * 3000).round(),
    });
  }

  // ── Filter Options ──────────────────────────────────────────────────

  List<FilterOption> _regionOptions() {
    return const [
      FilterOption(value: 'North America', label: 'North America'),
      FilterOption(value: 'Europe', label: 'Europe'),
      FilterOption(value: 'Asia Pacific', label: 'Asia Pacific'),
      FilterOption(value: 'Middle East', label: 'Middle East'),
      FilterOption(value: 'Latin America', label: 'Latin America'),
    ];
  }

  List<FilterOption> _countryOptions(String? region) {
    final countries = _countriesByRegion[region] ?? _countriesByRegion.values.expand((e) => e).toList();
    return countries.map((c) => FilterOption(value: c, label: c)).toList();
  }

  List<FilterOption> _cityOptions(String? country) {
    final cities = _citiesByCountry[country] ?? ['All Cities'];
    return cities.map((c) => FilterOption(value: c, label: c)).toList();
  }

  List<FilterOption> _categoryOptions() {
    return const [
      FilterOption(value: 'electronics', label: 'Electronics'),
      FilterOption(value: 'clothing', label: 'Clothing'),
      FilterOption(value: 'food', label: 'Food & Beverage'),
      FilterOption(value: 'furniture', label: 'Furniture'),
      FilterOption(value: 'automotive', label: 'Automotive'),
      FilterOption(value: 'office', label: 'Office Supplies'),
    ];
  }

  List<FilterOption> _statusOptions() {
    return const [
      FilterOption(value: 'completed', label: 'Completed'),
      FilterOption(value: 'pending', label: 'Pending'),
      FilterOption(value: 'shipped', label: 'Shipped'),
      FilterOption(value: 'cancelled', label: 'Cancelled'),
    ];
  }

  List<FilterOption> _departmentOptions() {
    return const [
      FilterOption(value: 'sales', label: 'Sales'),
      FilterOption(value: 'marketing', label: 'Marketing'),
      FilterOption(value: 'engineering', label: 'Engineering'),
      FilterOption(value: 'hr', label: 'Human Resources'),
      FilterOption(value: 'finance', label: 'Finance'),
    ];
  }

  List<FilterOption> _productOptions() {
    return _productNames
        .map((p) => FilterOption(value: p.toLowerCase().replaceAll(' ', '-'), label: p))
        .toList();
  }

  // ── Static Data ─────────────────────────────────────────────────────

  static const _employeeNames = [
    'James Wilson', 'Maria Garcia', 'Robert Johnson', 'Sarah Williams',
    'Michael Brown', 'Emily Davis', 'David Martinez', 'Lisa Anderson',
    'Daniel Thomas', 'Jennifer Taylor', 'Andrew Moore', 'Amanda Jackson',
    'Christopher White', 'Stephanie Harris', 'Matthew Martin', 'Nicole Thompson',
    'Joshua Robinson', 'Rachel Clark', 'Kevin Lewis', 'Laura Walker',
    'Brian Hall', 'Michelle Allen', 'Jason Young', 'Amber King',
    'Ryan Wright', 'Megan Lopez', 'Justin Hill', 'Heather Scott',
    'Brandon Green', 'Tiffany Adams', 'Tyler Baker', 'Kimberly Nelson',
    'Aaron Carter', 'Christina Mitchell', 'Zachary Perez', 'Rebecca Roberts',
    'Nathan Turner', 'Victoria Phillips', 'Patrick Campbell', 'Samantha Parker',
    'Jeremy Evans', 'Lauren Edwards', 'Derek Collins', 'Danielle Stewart',
    'Sean Morris', 'Brittany Rogers', 'Austin Reed', 'Courtney Cook',
    'Cody Morgan', 'Kayla Bell',
  ];

  static const _customerNames = [
    'Acme Corp', 'GlobalTech', 'Summit Industries', 'Vertex Solutions',
    'Pinnacle Group', 'Atlas Enterprises', 'Horizon Labs', 'NexGen Systems',
    'CoreBridge', 'Stellar Dynamics', 'OmniFlow', 'PrimeWare',
    'BlueStar Inc', 'IronClad Co', 'SwiftEdge', 'DataPulse',
    'CloudPeak', 'TerraFirm', 'NovaLink', 'AquaVista',
  ];

  static const _productNames = [
    'Laptop Pro', 'Wireless Mouse', 'USB-C Hub', 'Monitor 4K',
    'Mechanical Keyboard', 'Webcam HD', 'Standing Desk', 'Office Chair',
    'Printer Laser', 'External SSD', 'Headset Pro', 'Docking Station',
    'Tablet 10"', 'Smartphone X', 'Smart Watch', 'Power Bank',
  ];

  static const _transactionDescs = [
    'Monthly payroll', 'Cloud hosting fees', 'Marketing campaign',
    'Office supplies', 'Software license', 'Consulting services',
    'Equipment purchase', 'Travel expenses', 'Insurance premium',
    'Maintenance contract', 'Client payment', 'Vendor invoice',
  ];

  static const _countriesByRegion = {
    'North America': ['United States', 'Canada', 'Mexico'],
    'Europe': ['United Kingdom', 'Germany', 'France', 'Spain', 'Italy'],
    'Asia Pacific': ['Japan', 'China', 'Australia', 'India', 'South Korea'],
    'Middle East': ['UAE', 'Saudi Arabia', 'Qatar', 'Bahrain'],
    'Latin America': ['Brazil', 'Argentina', 'Chile', 'Colombia'],
  };

  static const _citiesByCountry = {
    'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal', 'Calgary'],
    'Mexico': ['Mexico City', 'Guadalajara', 'Monterrey'],
    'United Kingdom': ['London', 'Manchester', 'Birmingham', 'Edinburgh'],
    'Germany': ['Berlin', 'Munich', 'Frankfurt', 'Hamburg'],
    'France': ['Paris', 'Lyon', 'Marseille', 'Toulouse'],
    'Japan': ['Tokyo', 'Osaka', 'Kyoto', 'Yokohama'],
    'China': ['Shanghai', 'Beijing', 'Shenzhen', 'Guangzhou'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth'],
    'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah'],
    'Saudi Arabia': ['Riyadh', 'Jeddah', 'Dammam'],
    'Brazil': ['São Paulo', 'Rio de Janeiro', 'Brasília'],
  };
}
