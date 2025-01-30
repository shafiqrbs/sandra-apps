class FinancialData {
  final int? totalSalesInvoice;
  final int? totalPurchaseInvoice;

  final int? globalOption;
  final String? expenditure;
  final String? sales;
  final String? receive;
  final String? due;
  final String? voucher;
  final String? purchase;
  final String? payment;
  final List<TransactionOverview>? transactionOverview;
  final num? version;
  final String? updateUrl;
  final String? receiveAmount;
  final String? paymentAmount;
  final String? expenseAmount;
  final String? balanceAmount;

  FinancialData({
    this.totalSalesInvoice,
  this.totalPurchaseInvoice,
    this.globalOption,
    this.expenditure,
    this.sales,
    this.receive,
    this.due,
    this.voucher,
    this.purchase,
    this.payment,
    this.transactionOverview,
    this.version,
    this.updateUrl,
    this.receiveAmount,
    this.paymentAmount,
    this.expenseAmount,
    this.balanceAmount,
  });

  // Factory method to create a FinancialData object from JSON
  factory FinancialData.fromJson(Map<String, dynamic> json) {
    return FinancialData(
      // totalInvoice: json['total_invoice'] as int?,
      totalSalesInvoice: json['total_sales_invoice'] as int?,
      totalPurchaseInvoice: json['total_purchase_invoice'] as int?,
      globalOption: json['globalOption'] as int?,
      expenditure: json['expenditure'] as String?,
      sales: json['sales'] as String?,
      receive: json['receive'] as String?,
      due: json['due'] as String?,
      voucher: json['voucher'] as String?,
      purchase: json['purchase'] as String?,
      payment: json['payment'] as String?,
      transactionOverview: (json['transaction_overview'] as List?)?.map((item) {
        return TransactionOverview.fromJson(item);
      }).toList(),
      version: json['version'] as num?,
      updateUrl: json['update_url'] as String?,
      receiveAmount: json['receive_amount'] as String?,
      paymentAmount: json['payment_amount'] as String?,
      expenseAmount: json['expense_amount'] as String?,
      balanceAmount: json['balance_amount'] as String?,
    );
  }

  // Method to convert a FinancialData object to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_sales_invoice': totalSalesInvoice,
      'total_purchase_invoice': totalPurchaseInvoice,
      'globalOption': globalOption,
      'expenditure': expenditure,
      'sales': sales,
      'receive': receive,
      'due': due,
      'voucher': voucher,
      'purchase': purchase,
      'payment': payment,
      'transaction_overview': transactionOverview?.map((item) {
        return item.toJson();
      }).toList(),
      'version': version,
      'update_url': updateUrl,
      'receive_amount': receiveAmount,
      'payment_amount': paymentAmount,
      'expense_amount': expenseAmount,
      'balance': balanceAmount,
    };
  }
}

class TransactionOverview {
  final int? id;
  final String? name;
  final String? amount;

  TransactionOverview({
    this.id,
    this.name,
    this.amount,
  });

  // Factory method to create a TransactionOverview object from JSON
  factory TransactionOverview.fromJson(Map<String, dynamic> json) {
    return TransactionOverview(
      id: json['id'] as int?,
      name: json['name'] as String?,
      amount: json['amount'] as String?,
    );
  }

  // Method to convert a TransactionOverview object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
    };
  }
}
