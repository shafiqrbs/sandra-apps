import 'entity_manager.dart';

class VendorManager extends EntityManager<Vendor> {
  VendorManager()
      : super(
          'vendors',
          Vendor.fromJson,
          (e) => e.toJson(),
        );
}

class Vendor {
  int? globalId;
  int? vendorId;
  String? name;
  String? mobile;
  String? address;
  String? email;
  num? debit;
  num? credit;
  num? balance;

  Vendor({
    this.globalId,
    this.vendorId,
    this.name,
    this.mobile,
    this.address,
    this.email,
    this.debit,
    this.credit,
    this.balance,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      globalId: json['global_id'],
      vendorId: json['vendor_id'],
      name: json['name'],
      mobile: json['mobile'],
      address: json['address'],
      email: json['email'],
      debit: json['debit'],
      credit: json['credit'],
      balance: json['balance'] is String
          ? double.parse(json['balance'])
          : json['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'global_id': globalId,
      'customer_id': vendorId,
      'name': name,
      'mobile': mobile,
      'address': address,
      'email': email,
      'debit': debit,
      'credit': credit,
      'balance': balance,
    };
  }
}
