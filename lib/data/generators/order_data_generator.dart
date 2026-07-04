import 'dart:math';
import 'package:general_reports/models/order.dart';
import 'package:general_reports/models/invoice.dart';

abstract final class OrderDataGenerator {
  static final _random = Random(50);

  static const _customers = [
    'Acme Inc', 'TechCorp', 'GlobalTrade', 'PrimeSoft', 'MegaMart',
    'DataDriven Co', 'CloudFirst', 'SmartSolutions', 'InnovateTech', 'ValuePlus',
    'NextGen Labs', 'AlphaWorks', 'BetaStream', 'GammaForce', 'DeltaLogic',
  ];
  static const _products = ['Laptop', 'Smartphone', 'Tablet', 'Monitor', 'Printer', 'Server', 'Router', 'Software License'];
  static const _regions = ['North America', 'Europe', 'Asia', 'Latin America', 'Africa', 'Oceania'];
  static const _statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Returned'];
  static const _paymentMethods = ['Credit Card', 'Bank Transfer', 'PayPal', 'Invoice', 'Cash'];

  static List<Order> generateOrders({int count = 300}) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final qty = 1 + _random.nextInt(50);
      final unitPrice = 50 + _random.nextDouble() * 2000;
      final discount = _random.nextDouble() * 0.2;
      final total = qty * unitPrice * (1 - discount);
      return Order(
        id: 10000 + i,
        orderDate: now.subtract(Duration(days: _random.nextInt(365))),
        customerName: _customers[_random.nextInt(_customers.length)],
        product: _products[_random.nextInt(_products.length)],
        quantity: qty,
        unitPrice: unitPrice,
        totalAmount: total,
        status: _statuses[_random.nextInt(_statuses.length)],
        region: _regions[_random.nextInt(_regions.length)],
        paymentMethod: _paymentMethods[_random.nextInt(_paymentMethods.length)],
        discount: discount * 100,
      );
    });
  }

  static List<Invoice> generateInvoices({int count = 100}) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final amount = 1000 + _random.nextDouble() * 49000;
      final tax = amount * 0.15;
      final invoiceDate = now.subtract(Duration(days: _random.nextInt(180)));
      final dueDate = invoiceDate.add(Duration(days: 30));
      final isPaid = _random.nextDouble() > 0.35;
      return Invoice(
        invoiceNumber: 'INV-${20000 + i}',
        invoiceDate: invoiceDate,
        dueDate: dueDate,
        customerName: _customers[_random.nextInt(_customers.length)],
        amount: amount,
        tax: tax,
        totalAmount: amount + tax,
        status: isPaid ? 'Paid' : (now.isAfter(dueDate) ? 'Overdue' : 'Pending'),
        paymentTerms: 'Net 30',
      );
    });
  }
}
