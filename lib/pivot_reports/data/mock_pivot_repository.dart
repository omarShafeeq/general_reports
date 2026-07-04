import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import 'pivot_repository.dart';

class MockPivotRepository implements PivotRepository {
  final _random = Random(42);
  final List<PivotReport> _savedReports = [];
  int _nextId = 1;

  static const _dataSources = [
    PivotDataSource(
      id: 'SalesInvoice',
      name: 'Sales Invoices',
      description: 'All sales invoice transactions',
      category: 'Sales',
      icon: Icons.receipt_long,
    ),
    PivotDataSource(
      id: 'PurchaseOrder',
      name: 'Purchase Orders',
      description: 'Purchase order records',
      category: 'Purchases',
      icon: Icons.shopping_cart,
    ),
    PivotDataSource(
      id: 'Inventory',
      name: 'Inventory',
      description: 'Current inventory levels and movements',
      category: 'Inventory',
      icon: Icons.inventory_2,
    ),
    PivotDataSource(
      id: 'Customer',
      name: 'Customers',
      description: 'Customer master data',
      category: 'CRM',
      icon: Icons.people,
    ),
    PivotDataSource(
      id: 'Supplier',
      name: 'Suppliers',
      description: 'Supplier master data',
      category: 'Purchases',
      icon: Icons.local_shipping,
    ),
    PivotDataSource(
      id: 'GLTransaction',
      name: 'GL Transactions',
      description: 'General ledger journal entries',
      category: 'Accounting',
      icon: Icons.account_balance,
    ),
    PivotDataSource(
      id: 'Employee',
      name: 'Employees',
      description: 'Employee records and payroll',
      category: 'HR',
      icon: Icons.badge,
    ),
  ];

  static const _salesFields = [
    PivotField(name: 'InvoiceNumber', displayName: 'Invoice #', fieldType: PivotFieldType.text),
    PivotField(name: 'InvoiceDate', displayName: 'Invoice Date', fieldType: PivotFieldType.date),
    PivotField(name: 'Customer', displayName: 'Customer', fieldType: PivotFieldType.text),
    PivotField(name: 'SalesPerson', displayName: 'Sales Person', fieldType: PivotFieldType.text),
    PivotField(name: 'Product', displayName: 'Product', fieldType: PivotFieldType.text),
    PivotField(name: 'Category', displayName: 'Category', fieldType: PivotFieldType.text),
    PivotField(name: 'Region', displayName: 'Region', fieldType: PivotFieldType.text),
    PivotField(name: 'Branch', displayName: 'Branch', fieldType: PivotFieldType.text),
    PivotField(name: 'Quantity', displayName: 'Quantity', fieldType: PivotFieldType.numeric),
    PivotField(name: 'UnitPrice', displayName: 'Unit Price', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Discount', displayName: 'Discount', fieldType: PivotFieldType.numeric),
    PivotField(name: 'NetAmount', displayName: 'Net Amount', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Tax', displayName: 'Tax', fieldType: PivotFieldType.numeric),
    PivotField(name: 'TotalAmount', displayName: 'Total Amount', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Profit', displayName: 'Profit', fieldType: PivotFieldType.numeric),
    PivotField(name: 'PaymentMethod', displayName: 'Payment Method', fieldType: PivotFieldType.text),
    PivotField(name: 'Status', displayName: 'Status', fieldType: PivotFieldType.text),
    PivotField(name: 'Month', displayName: 'Month', fieldType: PivotFieldType.text),
    PivotField(name: 'Quarter', displayName: 'Quarter', fieldType: PivotFieldType.text),
    PivotField(name: 'Year', displayName: 'Year', fieldType: PivotFieldType.numeric),
  ];

  static const _purchaseFields = [
    PivotField(name: 'PONumber', displayName: 'PO #', fieldType: PivotFieldType.text),
    PivotField(name: 'PODate', displayName: 'PO Date', fieldType: PivotFieldType.date),
    PivotField(name: 'Supplier', displayName: 'Supplier', fieldType: PivotFieldType.text),
    PivotField(name: 'Product', displayName: 'Product', fieldType: PivotFieldType.text),
    PivotField(name: 'Category', displayName: 'Category', fieldType: PivotFieldType.text),
    PivotField(name: 'Warehouse', displayName: 'Warehouse', fieldType: PivotFieldType.text),
    PivotField(name: 'Quantity', displayName: 'Quantity', fieldType: PivotFieldType.numeric),
    PivotField(name: 'UnitCost', displayName: 'Unit Cost', fieldType: PivotFieldType.numeric),
    PivotField(name: 'TotalCost', displayName: 'Total Cost', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Status', displayName: 'Status', fieldType: PivotFieldType.text),
    PivotField(name: 'Month', displayName: 'Month', fieldType: PivotFieldType.text),
    PivotField(name: 'Year', displayName: 'Year', fieldType: PivotFieldType.numeric),
  ];

  static const _inventoryFields = [
    PivotField(name: 'ItemCode', displayName: 'Item Code', fieldType: PivotFieldType.text),
    PivotField(name: 'ItemName', displayName: 'Item Name', fieldType: PivotFieldType.text),
    PivotField(name: 'Category', displayName: 'Category', fieldType: PivotFieldType.text),
    PivotField(name: 'Warehouse', displayName: 'Warehouse', fieldType: PivotFieldType.text),
    PivotField(name: 'OnHand', displayName: 'On Hand', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Reserved', displayName: 'Reserved', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Available', displayName: 'Available', fieldType: PivotFieldType.numeric),
    PivotField(name: 'ReorderLevel', displayName: 'Reorder Level', fieldType: PivotFieldType.numeric),
    PivotField(name: 'UnitCost', displayName: 'Unit Cost', fieldType: PivotFieldType.numeric),
    PivotField(name: 'TotalValue', displayName: 'Total Value', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Status', displayName: 'Status', fieldType: PivotFieldType.text),
  ];

  static const _customerFields = [
    PivotField(name: 'CustomerCode', displayName: 'Customer Code', fieldType: PivotFieldType.text),
    PivotField(name: 'CustomerName', displayName: 'Customer Name', fieldType: PivotFieldType.text),
    PivotField(name: 'Region', displayName: 'Region', fieldType: PivotFieldType.text),
    PivotField(name: 'Country', displayName: 'Country', fieldType: PivotFieldType.text),
    PivotField(name: 'City', displayName: 'City', fieldType: PivotFieldType.text),
    PivotField(name: 'Type', displayName: 'Type', fieldType: PivotFieldType.text),
    PivotField(name: 'CreditLimit', displayName: 'Credit Limit', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Balance', displayName: 'Balance', fieldType: PivotFieldType.numeric),
    PivotField(name: 'TotalPurchases', displayName: 'Total Purchases', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Status', displayName: 'Status', fieldType: PivotFieldType.text),
  ];

  static const _supplierFields = [
    PivotField(name: 'SupplierCode', displayName: 'Supplier Code', fieldType: PivotFieldType.text),
    PivotField(name: 'SupplierName', displayName: 'Supplier Name', fieldType: PivotFieldType.text),
    PivotField(name: 'Country', displayName: 'Country', fieldType: PivotFieldType.text),
    PivotField(name: 'Category', displayName: 'Category', fieldType: PivotFieldType.text),
    PivotField(name: 'Rating', displayName: 'Rating', fieldType: PivotFieldType.numeric),
    PivotField(name: 'TotalOrders', displayName: 'Total Orders', fieldType: PivotFieldType.numeric),
    PivotField(name: 'TotalAmount', displayName: 'Total Amount', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Balance', displayName: 'Balance', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Status', displayName: 'Status', fieldType: PivotFieldType.text),
  ];

  static const _glFields = [
    PivotField(name: 'JournalNumber', displayName: 'Journal #', fieldType: PivotFieldType.text),
    PivotField(name: 'TransactionDate', displayName: 'Date', fieldType: PivotFieldType.date),
    PivotField(name: 'AccountCode', displayName: 'Account Code', fieldType: PivotFieldType.text),
    PivotField(name: 'AccountName', displayName: 'Account Name', fieldType: PivotFieldType.text),
    PivotField(name: 'AccountType', displayName: 'Account Type', fieldType: PivotFieldType.text),
    PivotField(name: 'Department', displayName: 'Department', fieldType: PivotFieldType.text),
    PivotField(name: 'CostCenter', displayName: 'Cost Center', fieldType: PivotFieldType.text),
    PivotField(name: 'Debit', displayName: 'Debit', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Credit', displayName: 'Credit', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Balance', displayName: 'Balance', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Month', displayName: 'Month', fieldType: PivotFieldType.text),
    PivotField(name: 'Year', displayName: 'Year', fieldType: PivotFieldType.numeric),
  ];

  static const _employeeFields = [
    PivotField(name: 'EmployeeCode', displayName: 'Employee Code', fieldType: PivotFieldType.text),
    PivotField(name: 'EmployeeName', displayName: 'Employee Name', fieldType: PivotFieldType.text),
    PivotField(name: 'Department', displayName: 'Department', fieldType: PivotFieldType.text),
    PivotField(name: 'Position', displayName: 'Position', fieldType: PivotFieldType.text),
    PivotField(name: 'Branch', displayName: 'Branch', fieldType: PivotFieldType.text),
    PivotField(name: 'Salary', displayName: 'Salary', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Allowances', displayName: 'Allowances', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Deductions', displayName: 'Deductions', fieldType: PivotFieldType.numeric),
    PivotField(name: 'NetPay', displayName: 'Net Pay', fieldType: PivotFieldType.numeric),
    PivotField(name: 'Status', displayName: 'Status', fieldType: PivotFieldType.text),
  ];

  List<PivotField> _fieldsFor(String dataSourceId) {
    switch (dataSourceId) {
      case 'SalesInvoice':
        return _salesFields;
      case 'PurchaseOrder':
        return _purchaseFields;
      case 'Inventory':
        return _inventoryFields;
      case 'Customer':
        return _customerFields;
      case 'Supplier':
        return _supplierFields;
      case 'GLTransaction':
        return _glFields;
      case 'Employee':
        return _employeeFields;
      default:
        return _salesFields;
    }
  }

  @override
  Future<List<PivotDataSource>> fetchDataSources() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dataSources;
  }

  @override
  Future<List<PivotField>> fetchFields(String dataSourceId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _fieldsFor(dataSourceId);
  }

  @override
  Future<PivotResult> executeReport(PivotLayout layout) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _generatePivotResult(layout);
  }

  @override
  Future<PivotReport> saveReport(PivotReport report) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final saved = report.copyWith(
      id: report.id ?? 'pivot-${_nextId++}',
      updatedAt: DateTime.now(),
      createdAt: report.createdAt ?? DateTime.now(),
    );
    _savedReports.removeWhere((r) => r.id == saved.id);
    _savedReports.add(saved);
    return saved;
  }

  @override
  Future<List<PivotReport>> fetchSavedReports() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_savedReports);
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _savedReports.removeWhere((r) => r.id == reportId);
  }

  @override
  Future<PivotReport> duplicateReport(String reportId, String newName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final source = _savedReports.firstWhere((r) => r.id == reportId);
    final copy = source.copyWith(
      id: 'pivot-${_nextId++}',
      name: newName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _savedReports.add(copy);
    return copy;
  }

  PivotResult _generatePivotResult(PivotLayout layout) {
    final rowFields = layout.rows;
    final colFields = layout.columns;
    final valueFields = layout.values;

    if (rowFields.isEmpty || valueFields.isEmpty) {
      return const PivotResult();
    }

    final rowDimValues = _dimensionValues(layout.dataSourceId, rowFields);
    final colDimValues = colFields.isNotEmpty
        ? _dimensionValues(layout.dataSourceId, colFields)
        : <String, List<String>>{};

    final columnHeaders = <String>[];
    if (colDimValues.isNotEmpty) {
      final firstColValues = colDimValues.values.first;
      for (final colVal in firstColValues) {
        for (final v in valueFields) {
          columnHeaders.add('$colVal | ${v.displayLabel}');
        }
      }
    } else {
      for (final v in valueFields) {
        columnHeaders.add(v.displayLabel);
      }
    }

    final rowHeaders = rowFields.map((f) => f.displayName).toList();
    final rows = <PivotResultRow>[];
    final grandTotals = <String, double>{};

    final firstRowValues = rowDimValues.isNotEmpty
        ? rowDimValues.values.first
        : <String>[];

    for (final rowVal in firstRowValues) {
      final values = <String, double>{};

      if (colDimValues.isNotEmpty) {
        final firstColValues = colDimValues.values.first;
        for (final colVal in firstColValues) {
          for (final v in valueFields) {
            final key = '$colVal | ${v.displayLabel}';
            final val = _mockValue(v.aggregation);
            values[key] = val;
            grandTotals[key] = (grandTotals[key] ?? 0) + val;
          }
        }
      } else {
        for (final v in valueFields) {
          final key = v.displayLabel;
          final val = _mockValue(v.aggregation);
          values[key] = val;
          grandTotals[key] = (grandTotals[key] ?? 0) + val;
        }
      }

      List<PivotResultRow>? children;
      if (rowFields.length > 1 && rowDimValues.length > 1) {
        final secondRowValues = rowDimValues.values.elementAt(1);
        children = secondRowValues.take(3).map((childVal) {
          final childValues = <String, double>{};
          for (final key in values.keys) {
            childValues[key] = _mockValue(PivotAggregation.sum) * 0.3;
          }
          return PivotResultRow(
            keys: {rowFields[1].name: childVal},
            values: childValues,
          );
        }).toList();
      }

      rows.add(PivotResultRow(
        keys: {rowFields.first.name: rowVal},
        values: values,
        children: children,
        subTotals: values,
      ));
    }

    return PivotResult(
      rowHeaders: rowHeaders,
      columnHeaders: columnHeaders,
      rows: rows,
      grandTotals: grandTotals,
      totalRecords: rows.length,
      page: 1,
      pageSize: 50,
      hasMore: false,
    );
  }

  double _mockValue(PivotAggregation agg) {
    switch (agg) {
      case PivotAggregation.sum:
        return (5000 + _random.nextDouble() * 95000).roundToDouble();
      case PivotAggregation.count:
        return (10 + _random.nextInt(990)).toDouble();
      case PivotAggregation.average:
        return (100 + _random.nextDouble() * 900).roundToDouble();
      case PivotAggregation.min:
        return (10 + _random.nextDouble() * 100).roundToDouble();
      case PivotAggregation.max:
        return (5000 + _random.nextDouble() * 15000).roundToDouble();
    }
  }

  Map<String, List<String>> _dimensionValues(
    String dataSourceId,
    List<PivotField> fields,
  ) {
    final result = <String, List<String>>{};
    for (final field in fields) {
      result[field.name] = _valuesForField(dataSourceId, field.name);
    }
    return result;
  }

  List<String> _valuesForField(String dataSourceId, String fieldName) {
    final values = <String, List<String>>{
      'Customer': [
        'Acme Corp', 'GlobalTech', 'MegaStore', 'Prime Industries',
        'StarLogistics', 'BlueSky Ltd', 'OceanView Inc', 'Summit Enterprises',
      ],
      'SalesPerson': ['Ahmad', 'Sara', 'Khalid', 'Nora', 'Omar', 'Fatima'],
      'Product': [
        'Laptop Pro', 'Desktop Elite', 'Monitor 4K', 'Keyboard BT',
        'Mouse Wireless', 'Printer All-in-One', 'Server Rack', 'UPS System',
      ],
      'Category': ['Electronics', 'Hardware', 'Software', 'Services', 'Accessories'],
      'Region': ['North', 'South', 'East', 'West', 'Central'],
      'Branch': ['Main', 'Downtown', 'Airport', 'Industrial'],
      'Month': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      'Quarter': ['Q1', 'Q2', 'Q3', 'Q4'],
      'Year': ['2024', '2025', '2026'],
      'Status': ['Active', 'Pending', 'Completed', 'Cancelled'],
      'PaymentMethod': ['Cash', 'Credit Card', 'Bank Transfer', 'Cheque'],
      'Supplier': ['TechSupply Co', 'Parts Direct', 'Industrial Source', 'Digital Wholesale'],
      'Warehouse': ['Main WH', 'North WH', 'South WH', 'Transit WH'],
      'AccountType': ['Asset', 'Liability', 'Equity', 'Revenue', 'Expense'],
      'Department': ['Sales', 'Marketing', 'Engineering', 'Support', 'HR', 'Finance'],
      'CostCenter': ['CC-100', 'CC-200', 'CC-300', 'CC-400'],
      'Position': ['Manager', 'Senior', 'Junior', 'Intern', 'Director'],
      'Type': ['Retail', 'Wholesale', 'Corporate', 'Government'],
      'Country': ['USA', 'UK', 'UAE', 'Germany', 'Japan', 'India'],
      'City': ['New York', 'London', 'Dubai', 'Berlin', 'Tokyo', 'Mumbai'],
    };

    return values[fieldName] ?? ['Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'];
  }
}
