import '/app/core/utils/parser_functions.dart';

class PurchaseItem {
  int? stockId;
  String? purchaseId;
  String? barcode;
  String? stockName;
  String? brandName;
  String? unit;
  num? quantity;
  num? price;
  num? subTotal;

  PurchaseItem({
    this.stockId,
    this.purchaseId,
    this.barcode,
    this.stockName,
    this.brandName,
    this.unit,
    this.quantity,
    this.price,
    this.subTotal,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      stockId: json['stock_id'],
      purchaseId: json['purchase_id'],
      barcode: json['barcode'],
      stockName: json['stock_name'],
      brandName: json['brand_name'],
      unit: json['unit'],
      quantity: json['quantity'],
      price: parseDouble(
        json['price'],
      ),
      subTotal: parseDouble(
        json['sub_total'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stock_id': stockId,
      'purchase_id': purchaseId,
      'barcode': barcode,
      'stock_name': stockName,
      'brand_name': brandName,
      'unit': unit,
      'quantity': quantity,
      'price': price,
      'sub_total': subTotal,
    };
  }
}
