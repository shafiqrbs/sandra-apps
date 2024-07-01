import 'entity_manager.dart';

class CustomerManager extends EntityManager<Customer> {
  CustomerManager()
      : super(
          'customers',
          Customer.fromJson,
          (e) => e.toJson(),
        );
}

class Customer {
  int? globalId;
  int? customerId;
  String? name;
  String? mobile;
  String? address;
  String? email;
  num? debit;
  num? credit;
  num? balance;

  Customer({
    this.globalId,
    this.customerId,
    this.name,
    this.mobile,
    this.address,
    this.email,
    this.debit,
    this.credit,
    this.balance,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        globalId: json['global_id'],
        customerId: json['customer_id'],
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

  Map<String, dynamic> toJson() => {
        'global_id': globalId,
        'customer_id': customerId,
        'name': name,
        'mobile': mobile,
        'address': address,
        'email': email,
        'debit': debit,
        'credit': credit,
        'balance': balance,
      };
}
