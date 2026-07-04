class Order {
  final int id;
  final DateTime orderDate;
  final String customerName;
  final String product;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final String status;
  final String region;
  final String paymentMethod;
  final double discount;

  const Order({
    required this.id,
    required this.orderDate,
    required this.customerName,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.status,
    required this.region,
    required this.paymentMethod,
    required this.discount,
  });
}
