class CustomerLedger {
  final int? id;
  final String? method;
  final int? sales;
  final int? receive;
  final double? balance;
  final String? sourceInvoice;
  final String? invoice;
  final String? created;
  final String? updated;
  final String? customerName;
  final int? customerId;
  final String? mobile;

  CustomerLedger({
    this.id,
    this.method,
    this.sales,
    this.receive,
    this.balance,
    this.sourceInvoice,
    this.invoice,
    this.created,
    this.updated,
    this.customerName,
    this.customerId,
    this.mobile,
  });

  factory CustomerLedger.fromJson(Map<String, dynamic> json) {
    return CustomerLedger(
      id: json['id'],
      method: json['method'],
      sales: json['sales'],
      receive: json['receive'],
      balance: _parseDouble(json['balance']),
      sourceInvoice: json['sourceInvoice'],
      invoice: json['invoice'],
      created: json['created'],
      updated: json['updated'],
      customerName: json['customerName'],
      customerId: json['customerId'],
      mobile: json['mobile'],
    );
  }
  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      throw const FormatException('Invalid format for double');
    }
  }
  static int _parseInt(dynamic value) {
    if (value is double) {
      return value.toInt();
    } else if (value is double) {
      return value.toInt();
    } else {
      throw const FormatException('Invalid format for double');
    }
  }

}
