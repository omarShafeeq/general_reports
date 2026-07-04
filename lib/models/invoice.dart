class Invoice {
  final String invoiceNumber;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final String customerName;
  final double amount;
  final double tax;
  final double totalAmount;
  final String status;
  final String paymentTerms;

  const Invoice({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.customerName,
    required this.amount,
    required this.tax,
    required this.totalAmount,
    required this.status,
    required this.paymentTerms,
  });

  bool get isOverdue =>
      status != 'Paid' && DateTime.now().isAfter(dueDate);

  int get daysOverdue =>
      isOverdue ? DateTime.now().difference(dueDate).inDays : 0;
}
