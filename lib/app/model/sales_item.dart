import 'package:terminalbd/utils/parser_functions.dart';

class SalesItem {
  int? stockId;
  String? salesId;
  String? barcode;
  String? stockName;
  String? brandName;
  String? unit;
  num? mrpPrice;
  num? salesPrice;
  num? discountPrice;
  num? purchasePrice;
  int? itemPercent;
  num? customPrice;
  num? quantity;
  num? subTotal;
  num? discountPercent;

  SalesItem({
    this.stockId,
    this.salesId,
    this.barcode,
    this.stockName,
    this.brandName,
    this.unit,
    this.mrpPrice,
    this.salesPrice,
    this.discountPrice,
    this.purchasePrice,
    this.itemPercent,
    this.customPrice,
    this.quantity,
    this.subTotal,
    this.discountPercent,
  });

  factory SalesItem.fromJson(Map<String, dynamic> json) {
    return SalesItem(
      stockId: json['stock_id'],
      salesId: json['sales_id'],
      barcode: json['barcode'],
      stockName: json['stock_name'],
      brandName: json['brand_name'],
      unit: json['unit'],
      mrpPrice: parseDouble(json['mrp_price']),
      salesPrice: parseDouble(json['sales_price']),
      discountPrice: parseDouble(json['discount_price']),
      purchasePrice: parseDouble(json['purchase_price']),
      itemPercent: json['item_percent'],
      customPrice: json['custom_price'],
      quantity: json['quantity'],
      subTotal: parseDouble(json['sub_total']),
      discountPercent: parseDouble(json['discount_percent']),
    );
  }

  Map<String, dynamic> toJson() => {
        'stock_id': stockId,
        'sales_id': salesId,
        'barcode': barcode,
        'stock_name': stockName,
        'brand_name': brandName,
        'unit': unit,
        'mrp_price': mrpPrice,
        'sales_price': salesPrice,
        'discount_price': discountPrice,
        'purchase_price': purchasePrice,
        'item_percent': itemPercent,
        'custom_price': customPrice,
        'quantity': quantity,
        'sub_total': subTotal,
        'discount_percent': discountPercent,
      };
}
