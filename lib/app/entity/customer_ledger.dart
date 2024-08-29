import 'entity_manager.dart';

class CustomerLedgerManager extends EntityManager<CustomerLedger> {
  CustomerLedgerManager()
      : super(
          '',
          (json) => CustomerLedger.fromJson(json),
          (e) => e.toJson(),
        );
}

class CustomerLedger {
  final int? id;
  final String? method;
  final int? sales;
  final int? receive;
  final double? balance;
  final int? sourceInvoice;
  final String? invoice;
  final String? created;
  final String? updated;
  final String? customerName;
  final int? customerId;
  final String? mobile;
  String? approvedBy;
  final String? accountBank;
  final int? total;
  final int? amount;
  final String? createdBy;

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
    this.approvedBy,
    this.accountBank,
    this.total,
    this.amount,
    this.createdBy,
  });

  factory CustomerLedger.fromJson(Map<String, dynamic> json) {
    return CustomerLedger(
      id: json['id'],
      method: json['method'],
      sales: json['sales'],
      receive: json['receive'],
      balance: _parseDouble(json['balance']),
      sourceInvoice: json['source_invoice'],
      invoice: json['invoice'],
      created: json['created'],
      updated: json['updated'],
      customerName: json['name'],
      customerId: json['customer_id'],
      mobile: json['mobile'],
      approvedBy: json['approved_by'],
      accountBank: json['account_bank'],
      total: json['total'],
      amount: json['amount'],
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method,
      'sales': sales,
      'receive': receive,
      'balance': balance,
      'source_invoice': sourceInvoice,
      'invoice': invoice,
      'created': created,
      'updated': updated,
      'customer_name': customerName,
      'customer_id': customerId,
      'mobile': mobile,
      'approved_by': approvedBy,
      'account_bank': accountBank,
      'total': total,
      'amount': amount,
      'created_by': createdBy,
    };
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
