import 'dart:convert';

import 'package:number_to_character/number_to_character.dart';

import '/app/core/utils/parser_functions.dart';
import 'customer.dart';
import 'entity_manager.dart';
import 'sales_item.dart';
import 'transaction_methods.dart';

class SalesManager extends EntityManager<Purchase> {
  SalesManager()
      : super(
          'sales',
          (json) => Purchase.fromJson(json),
          (e) => e.toJson(),
        );
}

class Purchase {
  String? salesId;
  int? deviceSalesId;
  String? invoice;

  String? createdAt;
  String? updatedAt;

  double? subTotal;
  double? discount;
  double? discountCalculation;
  double? vat;
  double? sd;
  double? netTotal;
  double? purchasePrice;
  double? received;
  double? due;
  int? deliveryCharge;
  String? paymentInWord;
  String? process;
  String? discountType;
  int? revised;
  int? printWithoutDiscount;
  int? isHold;
  int? createdById;
  String? createdBy;
  int? salesById;
  String? salesBy;
  int? approvedById;
  String? approvedBy;

  int? customerId;
  String? customerName;
  String? customerMobile;
  String? customerAddress;

  int? methodId;
  String? methodName;
  String? methodMode;

  String? comment;
  String? tokenNo;
  String? couponCode;

  List<SalesItem>? salesItem;

  int? isOnline;

  Purchase({
    this.salesId,
    this.deviceSalesId,
    this.invoice,
    this.createdAt,
    this.updatedAt,
    this.subTotal,
    this.discount,
    this.discountCalculation,
    this.vat,
    this.sd,
    this.netTotal,
    this.purchasePrice,
    this.received,
    this.due,
    this.deliveryCharge,
    this.paymentInWord,
    this.process,
    this.discountType,
    this.revised,
    this.printWithoutDiscount,
    this.isHold,
    this.createdById,
    this.createdBy,
    this.salesById,
    this.salesBy,
    this.approvedById,
    this.approvedBy,
    this.customerId,
    this.customerName,
    this.customerMobile,
    this.customerAddress,
    this.methodId,
    this.methodName,
    this.methodMode,
    this.comment,
    this.tokenNo,
    this.couponCode,
    this.salesItem,
    this.isOnline,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    final converter = NumberToCharacterConverter('en');

    return Purchase(
      salesId: json['sales_id'],
      deviceSalesId: json['device_sales_id'],
      invoice: json['invoice'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subTotal: parseDouble(json['sub_total']),
      discount: parseDouble(json['discount']),
      discountCalculation: parseDouble(json['discount_calculation']),
      vat: parseDouble(json['vat']),
      sd: parseDouble(json['sd']),
      netTotal: parseDouble(json['net_total']),
      purchasePrice: parseDouble(json['purchase_price']),
      received: parseDouble(json['received']),
      due: parseDouble(json['due']),
      deliveryCharge: json['delivery_charge'],
      paymentInWord: json['payment_in_word'] == null
          ? null
          : converter.convertInt(json['payment_in_word']),
      process: json['process'],
      discountType: json['discount_type'],
      revised: json['revised'],
      printWithoutDiscount: json['print_without_discount'],
      isHold: json['is_hold'],
      createdById: json['created_by_id'],
      createdBy: json['created_by'],
      salesById: json['sales_by_id'],
      salesBy: json['sales_by'],
      approvedById: json['approved_by_id'],
      approvedBy: json['approved_by'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerMobile: json['customer_mobile'],
      customerAddress: json['customer_address'],
      methodId: json['method_id'],
      methodName: json['method_name'],
      methodMode: json['method_mode'],
      comment: json['comment'],
      tokenNo: json['token_no'],
      couponCode: json['coupon_code'],
      salesItem: json['sales_item'] == null
          ? []
          : json['sales_item'] is String
              ? List<SalesItem>.from(
                  jsonDecode(json['sales_item']).map(
                    (x) => SalesItem.fromJson(x),
                  ),
                )
              : List<SalesItem>.from(
                  json['sales_item']!.map(
                    (x) => SalesItem.fromJson(x),
                  ),
                ),
      isOnline: json['is_online'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales_id': salesId,
      'device_sales_id': deviceSalesId,
      'invoice': invoice,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sub_total': subTotal,
      'discount': discount,
      'discount_calculation': discountCalculation,
      'vat': vat,
      'sd': sd,
      'net_total': netTotal,
      'purchase_price': purchasePrice,
      'received': received,
      'due': due,
      'delivery_charge': deliveryCharge,
      'payment_in_word': paymentInWord,
      'process': process,
      'discount_type': discountType,
      'revised': revised,
      'print_without_discount': printWithoutDiscount,
      'is_hold': isHold,
      'created_by_id': createdById,
      'created_by': createdBy,
      'sales_by_id': salesById,
      'sales_by': salesBy,
      'approved_by_id': approvedById,
      'approved_by': approvedBy,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_mobile': customerMobile,
      'customer_address': customerAddress,
      'method_id': methodId,
      'method_name': methodName,
      'method_mode': methodMode,
      'comment': comment,
      'token_no': tokenNo,
      'coupon_code': couponCode,
      'sales_item': salesItem == null || salesItem!.isEmpty
          ? null
          : jsonEncode(salesItem),
      'is_online': isOnline,
    };
  }

  void setCustomerData(Customer customer) {
    customerId = customer.customerId;
    customerName = customer.name;
    customerMobile = customer.mobile;
    customerAddress = customer.address;
  }

  void setTransactionMethodData(TransactionMethods transactionMethod) {
    methodId = transactionMethod.methodId;
    methodName = transactionMethod.methodName;
  }
}
