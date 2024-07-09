import 'dart:convert';

import 'package:getx_template/app/core/db_helper/db_tables.dart';
import 'package:number_to_character/number_to_character.dart';

import '/app/core/utils/parser_functions.dart';
import '/app/entity/vendor.dart';
import 'entity_manager.dart';
import 'purchase_item.dart';
import 'transaction_methods.dart';

class PurchaseManager extends EntityManager<Purchase> {
  PurchaseManager()
      : super(
          DbTables().tablePurchase,
          Purchase.fromJson,
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
  int? deliveryCharge;
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

  List<PurchaseItem>? purchaseItem;

  int? isOnline;

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
      vendorName: json['vendor_name'],
      vendorMobile: json['vendor_mobile'],
      vendorAddress: json['vendor_address'],
      methodId: json['method_id'],
      methodName: json['method_name'],
      methodMode: json['method_mode'],
      comment: json['comment'],
      tokenNo: json['token_no'],
      couponCode: json['coupon_code'],
      purchaseItem: json['purchase_item'] == null
          ? []
          : json['purchase_item'] is String
              ? List<PurchaseItem>.from(
                  jsonDecode(json['purchase_item']).map(
                    PurchaseItem.fromJson,
                  ),
                )
              : List<PurchaseItem>.from(
                  json['purchase_item']!.map(
                    PurchaseItem.fromJson,
                  ),
                ),
      isOnline: json['is_online'],
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
      'vendor_name': vendorName,
      'vendor_mobile': vendorMobile,
      'vendor_address': vendorAddress,
      'method_id': methodId,
      'method_name': methodName,
      'method_mode': methodMode,
      'comment': comment,
      'token_no': tokenNo,
      'coupon_code': couponCode,
      'purchase_item': purchaseItem == null || purchaseItem!.isEmpty
          ? null
          : jsonEncode(purchaseItem),
      'is_online': isOnline,
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
