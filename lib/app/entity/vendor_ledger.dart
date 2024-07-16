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
  final int? sales;
  final int? receive;
  final double? balance;
  final String? sourceInvoice;
  final String? invoice;
  final String? created;
  final String? updated;
  final String? vendorName;
  final int? vendorId;
  final String? mobile;

  VendorLedger({
    this.id,
    this.method,
    this.sales,
    this.receive,
    this.balance,
    this.sourceInvoice,
    this.invoice,
    this.created,
    this.updated,
    this.vendorName,
    this.vendorId,
    this.mobile,
  });

  factory VendorLedger.fromJson(Map<String, dynamic> json) {
    return VendorLedger(
      id: json['id'],
      method: json['method'],
      sales: json['sales'],
      receive: json['receive'],
      balance: _parseDouble(json['balance']),
      sourceInvoice: json['source_invoice'],
      invoice: json['invoice'],
      created: json['created'],
      updated: json['updated'],
      vendorName: json['vendor_name'],
      vendorId: json['vendor_id'],
      mobile: json['mobile'],
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
      'vendor_name': vendorName,
      'vendor_id': vendorId,
      'mobile': mobile,
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
