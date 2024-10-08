import 'dart:convert';

import 'package:number_to_character/number_to_character.dart';

import '/app/core/db_helper/db_tables.dart';
import '/app/core/utils/parser_functions.dart';
import '/app/entity/vendor.dart';
import 'entity_manager.dart';
import 'purchase_item.dart';
import 'transaction_methods.dart';

class PurchaseManager extends EntityManager<Purchase> {
  PurchaseManager()
      : super(
          DbTables().tablePurchase,
          (json) => Purchase.fromJson(json),
          (e) => e.toJson(),
        );
}

class Purchase {
  String? purchaseId;
  int? deviceSalesId;
  String? invoice;

  String? createdAt;
  String? updatedAt;

  double? subTotal;
  double? netTotal;
  double? purchasePrice;
  double? received;
  double? due;
  num? deliveryCharge;
  String? paymentInWord;
  String? process;
  int? revised;
  int? printWithoutDiscount;
  int? isHold;
  int? createdById;
  String? createdBy;
  int? salesById;
  String? salesBy;
  int? approvedById;
  String? approvedBy;

  int? vendorId;
  String? vendorName;
  String? vendorMobile;
  String? vendorAddress;

  int? methodId;
  String? methodName;
  String? methodMode;

  String? comment;
  String? tokenNo;
  String? couponCode;

  num? discountCalculation;
  num? discount;

  List<PurchaseItem>? purchaseItem;

  int? isOnline;

  String? purchaseMode;

  Purchase({
    this.purchaseId,
    this.deviceSalesId,
    this.invoice,
    this.createdAt,
    this.updatedAt,
    this.subTotal,
    this.netTotal,
    this.purchasePrice,
    this.received,
    this.due,
    this.deliveryCharge,
    this.paymentInWord,
    this.process,
    this.revised,
    this.printWithoutDiscount,
    this.isHold,
    this.createdById,
    this.createdBy,
    this.salesById,
    this.salesBy,
    this.approvedById,
    this.approvedBy,
    this.vendorId,
    this.vendorName,
    this.vendorMobile,
    this.vendorAddress,
    this.methodId,
    this.methodName,
    this.methodMode,
    this.comment,
    this.tokenNo,
    this.couponCode,
    this.purchaseItem,
    this.isOnline,
    this.discountCalculation,
    this.discount,
    this.purchaseMode,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    final converter = NumberToCharacterConverter('en');

    return Purchase(
      purchaseId: json['purchase_id'],
      deviceSalesId: json['device_sales_id'],
      invoice: json['invoice'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subTotal: parseDouble(json['sub_total']),
      netTotal: parseDouble(json['net_total']),
      purchasePrice: parseDouble(json['purchase_price']),
      received: parseDouble(json['received']),
      due: parseDouble(json['due']),
      deliveryCharge: json['delivery_charge'],
      paymentInWord: json['payment_in_word'] == null
          ? null
          : converter.convertInt(json['payment_in_word']),
      process: json['process'],
      revised: json['revised'],
      printWithoutDiscount: json['print_without_discount'],
      isHold: json['is_hold'],
      createdById: json['created_by_id'],
      createdBy: json['created_by'],
      salesById: json['sales_by_id'],
      salesBy: json['sales_by'],
      approvedById: json['approved_by_id'],
      approvedBy: json['approved_by'],
      vendorId: json['vendor_id'],
      vendorName: json['name'],
      vendorMobile: json['mobile'],
      vendorAddress: json['address'],
      methodId: json['method_id'],
      methodName: json['method_name'],
      methodMode: json['method_mode'],
      comment: json['comment'],
      tokenNo: json['token_no'],
      couponCode: json['coupon_code'],
      purchaseItem: json['items'] == null
          ? []
          : json['items'] is String
              ? List<PurchaseItem>.from(
                  jsonDecode(json['items']).map(
                    (x) => PurchaseItem.fromJson(x),
                  ),
                )
              : List<PurchaseItem>.from(
                  json['items']!.map(
                    (x) => PurchaseItem.fromJson(x),
                  ),
                ),
      isOnline: json['is_online'],
      discountCalculation: parseDouble(json['discount_calculation']),
      discount: parseDouble(json['discount']),
      purchaseMode: json['purchase_mode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'device_sales_id': deviceSalesId,
      'invoice': invoice,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sub_total': subTotal,
      'net_total': netTotal,
      'purchase_price': purchasePrice,
      'received': received,
      'due': due,
      'delivery_charge': deliveryCharge,
      'payment_in_word': paymentInWord,
      'process': process,
      'revised': revised,
      'print_without_discount': printWithoutDiscount,
      'is_hold': isHold,
      'created_by_id': createdById,
      'created_by': createdBy,
      'sales_by_id': salesById,
      'sales_by': salesBy,
      'approved_by_id': approvedById,
      'approved_by': approvedBy,
      'vendor_id': vendorId,
      'name': vendorName,
      'mobile': vendorMobile,
      'address': vendorAddress,
      'method_id': methodId,
      'method_name': methodName,
      'method_mode': methodMode,
      'comment': comment,
      'token_no': tokenNo,
      'coupon_code': couponCode,
      'items': purchaseItem == null
          ? null
          : jsonEncode(
              List<dynamic>.from(
                purchaseItem!.map(
                  (x) => x.toJson(),
                ),
              ),
            ),
      'is_online': isOnline,
      'discount_calculation': discountCalculation,
      'discount': discount,
      'purchase_mode': purchaseMode,
    };
  }

  void setVendorData(Vendor vendor) {
    vendorId = vendor.vendorId;
    vendorName = vendor.name;
    vendorMobile = vendor.mobile;
    vendorAddress = vendor.address;
  }

  void setTransactionMethodData(TransactionMethods transactionMethod) {
    methodId = transactionMethod.methodId;
    methodName = transactionMethod.methodName;
  }
}
