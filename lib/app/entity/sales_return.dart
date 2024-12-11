class SalesReturn {
  int? salesReturnId;
  String? salesReturnInvoice;
  num? salesId;
  String? salesInvoice;
  String? createdAt;
  String? updatedAt;
  num? subTotal;
  num? payment;
  num? adjustment;
  String? createdBy;
  String? approvedBy;
  num? customerId;
  String? customerName;
  String? customerMobile;
  String? customerAddress;
  String? comment;
  List<SalesReturnItem>? items;

  SalesReturn({
    this.salesReturnId,
    this.salesReturnInvoice,
    this.salesId,
    this.salesInvoice,
    this.createdAt,
    this.updatedAt,
    this.subTotal,
    this.payment,
    this.adjustment,
    this.createdBy,
    this.approvedBy,
    this.customerId,
    this.customerName,
    this.customerMobile,
    this.customerAddress,
    this.comment,
    this.items,
  });

  factory SalesReturn.fromJson(Map<String, dynamic> json) {
    return SalesReturn(
      salesReturnId: json['sales_return_id'],
      salesReturnInvoice: json['sales_return_invoice'],
      salesId: json['sales_id'],
      salesInvoice: json['sales_invoice'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subTotal: json['sub_total'],
      payment: json['payment'],
      adjustment: json['adjustment'],
      createdBy: json['created_by'],
      approvedBy: json['approved_by'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerMobile: json['customer_mobile'],
      customerAddress: json['customer_address'],
      comment: json['comment'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => SalesReturnItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales_return_id': salesReturnId,
      'sales_return_invoice': salesReturnInvoice,
      'sales_id': salesId,
      'sales_invoice': salesInvoice,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sub_total': subTotal,
      'payment': payment,
      'adjustment': adjustment,
      'created_by': createdBy,
      'approved_by': approvedBy,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_mobile': customerMobile,
      'customer_address': customerAddress,
      'comment': comment,
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }
}

class SalesReturnItem {
  num? id;
  num? stockId;
  String? stockName;
  String? brandName;
  String? unit;
  num? salesPrice;
  num? quantity;
  num? subTotal;

  SalesReturnItem({
    this.id,
    this.stockId,
    this.stockName,
    this.brandName,
    this.unit,
    this.salesPrice,
    this.quantity,
    this.subTotal,
  });

  factory SalesReturnItem.fromJson(Map<String, dynamic> json) {
    return SalesReturnItem(
      id: json['id'],
      stockId: json['stock_id'],
      stockName: json['stock_name'],
      brandName: json['brand_name'],
      unit: json['unit'],
      salesPrice: json['sales_price'],
      quantity: json['quantity'],
      subTotal: json['sub_total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_id': stockId,
      'stock_name': stockName,
      'brand_name': brandName,
      'unit': unit,
      'sales_price': salesPrice,
      'quantity': quantity,
      'sub_total': subTotal,
    };
  }
}
