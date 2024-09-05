import 'entity_manager.dart';

class VendorLedgerManager extends EntityManager<VendorLedger> {
  VendorLedgerManager()
      : super(
          '',
          (json) => VendorLedger.fromJson(json),
          (e) => e.toJson(),
        );
}

class VendorLedger {
  final int? id;
  final String? method;
  final String? name;
  final String? createdBy;
  final String? approvedBy;
  final String? mobile;
  final double? total;
  final double? amount;
  final double? balance;
  final int? sourceInvoice;
  final String? accountBank;
  final String? invoice;
  final String? created;
  final String? updated;

  VendorLedger({
    this.id,
    this.method,
    this.name,
    this.createdBy,
    this.approvedBy,
    this.mobile,
    this.total,
    this.amount,
    this.balance,
    this.sourceInvoice,
    this.accountBank,
    this.invoice,
    this.created,
    this.updated,
  });

  factory VendorLedger.fromJson(Map<String, dynamic> json) {
    return VendorLedger(
      id: json['id'],
      method: json['method'],
      name: json['name'],
      createdBy: json['created_by'],
      approvedBy: json['approved_by'],
      mobile: json['mobile'],
      total: _toDouble(json['total']),
      amount: _toDouble(json['amount']),
      balance: _toDouble(json['balance']),
      sourceInvoice: json['source_invoice'],
      accountBank: json['account_bank'],
      invoice: json['invoice'],
      created: json['created'],
      updated: json['updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method,
      'name': name,
      'created_by': createdBy,
      'approved_by': approvedBy,
      'mobile': mobile,
      'total': total,
      'amount': amount,
      'balance': balance,
      'source_invoice': sourceInvoice,
      'account_bank': accountBank,
      'invoice': invoice,
      'created': created,
      'updated': updated,
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      throw FormatException('Invalid format for double');
    }
  }
}
