class UserSalesOverviewReport {
  int? globalOption;
  List<UserSales>? userSales;

  UserSalesOverviewReport({this.globalOption, this.userSales});

  factory UserSalesOverviewReport.fromJson(Map<String, dynamic> json) {
    return UserSalesOverviewReport(
      globalOption: json['globalOption'],
      userSales: json['user_sales'] != null
          ? (json['user_sales'] as List)
          .map((i) => UserSales.fromJson(i))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalOption': globalOption,
      'user_sales': userSales?.map((i) => i.toJson()).toList(),
    };
  }
}

class UserSales {
  int? salesById;
  String? salesBy;
  double? total;
  double? amount;
  double? dueReceive;

  UserSales({this.salesById, this.salesBy, this.total, this.amount, this.dueReceive});

  factory UserSales.fromJson(Map<String, dynamic> json) {
    return UserSales(
      salesById: json['salesById'],
      salesBy: json['salesBy'],
      total: (json['total'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      dueReceive: (json['due_receive'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesById': salesById,
      'salesBy': salesBy,
      'total': total,
      'amount': amount,
      'due_receive': dueReceive,
    };
  }
}