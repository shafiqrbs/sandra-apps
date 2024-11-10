class SystemOverViewReport {
  int? globalOption;
  CurrentStockOverview? currentStock;
  IncomeOverview? income;
  PurchaseOverview? purchase;
  SalesOverview? sales;
  TransactionOverview? transaction;

  SystemOverViewReport({
    this.globalOption,
    this.currentStock,
    this.income,
    this.purchase,
    this.sales,
    this.transaction,
  });

  factory SystemOverViewReport.fromJson(Map<String, dynamic> json) {
    return SystemOverViewReport(
      globalOption: json['globalOption'],
      currentStock: json['current_stock'] != null
          ? CurrentStockOverview.fromJson(json['current_stock'])
          : null,
      income: json['income'] != null
          ? IncomeOverview.fromJson(json['income'])
          : null,
      purchase: json['purchase'] != null
          ? PurchaseOverview.fromJson(json['purchase'])
          : null,
      sales:
          json['sales'] != null ? SalesOverview.fromJson(json['sales']) : null,
      transaction: json['transaction'] != null
          ? TransactionOverview.fromJson(json['transaction'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalOption': globalOption,
      'current_stock': currentStock?.toJson(),
      'income': income?.toJson(),
      'purchase': purchase?.toJson(),
      'sales': sales?.toJson(),
      'transaction': transaction?.toJson(),
    };
  }
}

class CurrentStockOverview {
  String? quantity;
  String? salesPrice;
  String? purchasePrice;
  String? profit;

  CurrentStockOverview({
    this.quantity,
    this.salesPrice,
    this.purchasePrice,
    this.profit,
  });

  factory CurrentStockOverview.fromJson(Map<String, dynamic> json) {
    return CurrentStockOverview(
      quantity: json['quantity'],
      salesPrice: json['salesPrice'],
      purchasePrice: json['purchasePrice'],
      profit: json['profit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'salesPrice': salesPrice,
      'purchasePrice': purchasePrice,
      'profit': profit,
    };
  }
}

class IncomeOverview {
  String? sales;
  String? purchase;
  String? expense;
  String? profit;

  IncomeOverview({
    this.sales,
    this.purchase,
    this.expense,
    this.profit,
  });

  factory IncomeOverview.fromJson(Map<String, dynamic> json) {
    return IncomeOverview(
      sales: json['sales'],
      purchase: json['purchase'],
      expense: json['expense'],
      profit: json['profit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales': sales,
      'purchase': purchase,
      'expense': expense,
      'profit': profit,
    };
  }
}

class PurchaseOverview {
  String? purchase;
  String? amount;
  String? payable;

  PurchaseOverview({
    this.purchase,
    this.amount,
    this.payable,
  });

  factory PurchaseOverview.fromJson(Map<String, dynamic> json) {
    return PurchaseOverview(
      purchase: json['purchase'],
      amount: json['amount'],
      payable: json['payable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase': purchase,
      'amount': amount,
      'payable': payable,
    };
  }
}

class SalesOverview {
  String? sales;
  String? amount;
  String? receivable;

  SalesOverview({
    this.sales,
    this.amount,
    this.receivable,
  });

  factory SalesOverview.fromJson(Map<String, dynamic> json) {
    return SalesOverview(
      sales: json['sales'],
      amount: json['amount'],
      receivable: json['receivable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales': sales,
      'amount': amount,
      'receivable': receivable,
    };
  }
}

class TransactionOverview {
  String? cash;
  String? stockPrice;
  String? receivable;
  String? payable;
  String? capital;

  TransactionOverview({
    this.cash,
    this.stockPrice,
    this.receivable,
    this.payable,
    this.capital,
  });

  factory TransactionOverview.fromJson(Map<String, dynamic> json) {
    return TransactionOverview(
      cash: json['cash'],
      stockPrice: json['stock_price'],
      receivable: json['receivable'],
      payable: json['payable'],
      capital: json['capital'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cash': cash,
      'stock_price': stockPrice,
      'receivable': receivable,
      'payable': payable,
      'capital': capital,
    };
  }
}
