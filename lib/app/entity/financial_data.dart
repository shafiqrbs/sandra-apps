import 'dart:convert';

class FinancialData {
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

  FinancialData({
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
  });

  // Factory method to create a FinancialData object from JSON
  factory FinancialData.fromJson(Map<String, dynamic> json) {
    return FinancialData(
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
    );
  }

  // Method to convert a FinancialData object to JSON
  Map<String, dynamic> toJson() {
    return {
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
      'version' : version,
      'update_url' : updateUrl,
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
