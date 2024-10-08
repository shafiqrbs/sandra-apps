import 'dart:convert';

import 'package:sandra/app/entity/stock.dart';

import '/app/core/utils/parser_functions.dart';

class TableInvoice {
  int? tableId;
  String? process;
  String? orderTime;
  String? orderBy;
  String? additionalTable;
  num? amount;
  String? discountType;
  num? discount;
  num? totalDiscount;
  String? couponCode;
  num? couponDiscount;
  num? vat;
  num? sd;
  num? subTotal;
  num? total;
  String? tokenNo;
  int? customerId;
  List<Stock>? items;

  TableInvoice({
    this.tableId,
    this.process,
    this.orderTime,
    this.orderBy,
    this.additionalTable,
    this.amount,
    this.discountType,
    this.discount,
    this.totalDiscount,
    this.couponCode,
    this.couponDiscount,
    this.vat,
    this.sd,
    this.subTotal,
    this.total,
    this.tokenNo,
    this.customerId,
    this.items,
  });

  factory TableInvoice.fromJson(Map<String, dynamic> json) {
    return TableInvoice(
      tableId: json['table_id'],
      process: json['process'],
      orderTime: json['order_time'],
      orderBy: json['order_by'],
      additionalTable: json['additional_table'],
      amount: parseDouble(json['amount']),
      discountType: json['discount_type'],
      discount: parseDouble(json['discount']),
      totalDiscount: parseDouble(json['total_discount']),
      couponCode: json['coupon_code'],
      couponDiscount: parseDouble(json['coupon_discount']),
      vat: parseDouble(json['vat']),
      sd: parseDouble(json['sd']),
      subTotal: parseDouble(json['subtotal']),
      total: parseDouble(json['total']),
      tokenNo: json['token_no'],
      customerId: json['customer_id'],
      items: json['items'] == null
          ? []
          : json['items'] is String
              ? List<Stock>.from(
                  jsonDecode(json['items']).map(
                    (x) => Stock.fromJson(x),
                  ),
                )
              : List<Stock>.from(
                  json['items']!.map(
                    (x) => Stock.fromJson(x),
                  ),
                ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table_id': tableId,
      'process': process,
      'order_time': orderTime,
      'order_by': orderBy,
      'additional_table': additionalTable,
      'amount': amount,
      'discount_type': discountType,
      'discount': discount,
      'total_discount': totalDiscount,
      'coupon_code': couponCode,
      'coupon_discount': couponDiscount,
      'vat': vat,
      'sd': sd,
      'subtotal': subTotal,
      'total': total,
      'token_no': tokenNo,
      'customer_id': customerId,
      'items': items == null
          ? null
          : jsonEncode(
              items!.map((x) => x.toJson()).toList(),
            ),
    };
  }
}
