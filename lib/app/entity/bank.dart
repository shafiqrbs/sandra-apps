class Bank {
  final num? id;
  final String? name;
  final String? bankName;
  final String? amount;

  Bank({
    this.id,
    this.name,
    this.bankName,
    this.amount,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      bankName: json['bank_name'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bank_name': bankName,
      'amount': amount,
    };
  }
}
