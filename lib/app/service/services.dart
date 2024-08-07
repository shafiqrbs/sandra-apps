import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/app/core/core_model/setup.dart';
import '/app/core/session_manager/session_manager.dart';
import '/app/entity/customer.dart';
import '/app/entity/customer_ledger.dart';
import '/app/entity/purchase.dart';
import '/app/entity/sales.dart';
import '/app/entity/vendor_ledger.dart';
import 'client/api_options.dart';
import 'client/rest_client.dart';

Future<List<T>?> parseList<T>({
  required List<dynamic>? list,
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  if (list == null) {
    return null;
  }

  try {
    if (kDebugMode) {
      print('\x1B[31m Parsing List $T ${list.length} \x1B[0m\n');
    }
    return await compute(
      _parseListInIsolate,
      _ParseListParams<T>(
        list,
        fromJson,
      ),
    );
  } on Exception catch (e) {
    if (kDebugMode) {
      print('Error parsing list: $e');
    }
  }
  return null;
}

class _ParseListParams<T> {
  final List<dynamic> list;
  final T Function(Map<String, dynamic>) fromJson;

  _ParseListParams(this.list, this.fromJson);
}

List<T> _parseListInIsolate<T>(_ParseListParams<T> params) {
  return params.list.map((e) => params.fromJson(e)).toList();
}

class Services {
  factory Services() {
    return instance;
  }
  Services._privateConstructor();

  static final Services instance = Services._privateConstructor();

  final pref = SessionManager();
  final dio = RestClient(
    baseUrl: 'https://poskeeper.com/flutter-api/',
    token: '',
  );

  Map<String, dynamic> _buildHeader() {
    return {
      'X-API-KEY': 'terminalbd',
      'X-API-VALUE': 'terminalbd@aps',
      'X-API-SECRET': SetUp().uniqueCode ?? '',
    };
  }

  Future<bool> validateResponse(Response<dynamic> response) async {
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>?> submitLicense({
    required String license,
    required String activeKey,
  }) async {
    final response = await dio.post(
      APIType.public,
      'poskeeper-splash',
      {
        'mobile': license,
        'uniqueCode': activeKey,
        'deviceId': '',
      },
      headers: _buildHeader(),
    );
    return response.data;
  }

  Future<Customer?> addCustomer({
    required String name,
    required String mobile,
    required String address,
    required String email,
    required String openingBalance,
  }) async {
    try {
      final data = {
        'name': name,
        'mobile': mobile,
        'address': address,
        'email': email,
        'openingBalance': openingBalance,
      };

      final response = await dio.post(
        APIType.public,
        'poskeeper-customer-create',
        data,
        query: data,
        headers: _buildHeader(),
      );

      return response.data == null ? null : Customer.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?>? addStock({
    required String productName,
    required String category,
    required String brand,
    required String modelNumber,
    required String unit,
    required String purchasePrice,
    required String salesPrice,
    required String discountPrice,
    required String minimumQty,
    required String openingQty,
    required String description,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-add-stock',
        {
          'productName': productName,
          'category': category,
          'brand': brand,
          'modelNumber': modelNumber,
          'unit': unit,
          'purchasePrice': purchasePrice,
          'salesPrice': salesPrice,
          'discountPrice': discountPrice,
          'minimumQty': minimumQty,
          'openingQty': openingQty,
          'description': description,
        },
        headers: _buildHeader(),
      );

      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<List<Sales>?> getSalesList({
    required String? startDate,
    required String? endDate,
    required String? customerId,
    required String? keyword,
  }) async {
    final query = <String, dynamic>{};
    if (startDate != null) query['start_date'] = startDate;
    if (endDate != null) query['end_date'] = endDate;
    if (customerId != null) query['customer_id'] = customerId;
    if (keyword != null) query['keyword'] = keyword;

    if (query.isEmpty) {
      query['start_date'] = '01-01-2023';
      query['end_date'] = '02-01-2023';
    }

    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-online-sales',
        query,
        // query: query,
        headers: _buildHeader(),
      );
      return parseList(
        list: response.data,
        fromJson: Sales.fromJson,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Purchase>?> getPurchaseList({
    required String? startDate,
    required String? endDate,
    required String? vendorId,
    required String? keyword,
  }) async {
    final query = <String, dynamic>{};
    if (startDate != null) query['start_date'] = startDate;
    if (endDate != null) query['end_date'] = endDate;
    if (vendorId != null) query['vendor_id'] = vendorId;
    if (keyword != null) query['keyword'] = keyword;

    if (query.isEmpty) {
      query['start_date'] = '01-01-2023';
      query['end_date'] = '02-01-2023';
    }

    final response = await dio.post(
      APIType.public,
      'poskeeper-online-purchase',
      query,
      query: query,
      headers: _buildHeader(),
    );

    return parseList(
      list: response.data,
      fromJson: Purchase.fromJson,
    );
  }

  Future<Sales?> getOnlineSalesDetails({
    required String id,
  }) async {
    try {
      final response = await dio.get(
        APIType.public,
        'poskeeper-online-sales-details',
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );
      return Sales.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Purchase?> getOnlinePurchaseDetails({
    required String id,
  }) async {
    final response = await dio.get(
      APIType.public,
      'poskeeper-online-sales-details',
      query: {
        'id': id,
      },
      headers: _buildHeader(),
    );
    final responseData = response.data as Map<String, dynamic>?;
    if (responseData == null) return null;
    return Purchase.fromJson(response.data);
  }

  Future<bool> postCustomerReceive({
    required String customer,
    required String method,
    required String mode,
    required String amount,
    required String userId,
    required String? remark,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-account-receive',
        {
          'customer_id': customer,
          'method_id': method,
          'mode': mode,
          'amount': amount,
          'user_id': userId,
          'remark': remark,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null || responseData['status'] == null) return false;
      return responseData['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> postVendorPayment({
    required String vendor,
    required String method,
    required String mode,
    required String amount,
    required String userId,
    required String? remark,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-account-payment',
        {
          'vendor_id': vendor,
          'method_id': method,
          'mode': mode,
          'amount': amount,
          'user_id': userId,
          'remark': remark,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null || responseData['status'] == null) return false;
      return responseData['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> postSales({
    required List salesList,
    required String mode,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-sales',
        {
          'sales': jsonEncode(salesList),
          'mode': mode,
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> postPurchase({
    required List purchaseList,
    required String mode,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-purchase',
        {
          'sales': jsonEncode(purchaseList),
          'mode': mode,
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSales({
    required List salesList,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-sales-update',
        {
          'sales': jsonEncode(salesList),
          'mode': 'online',
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSales({
    required String id,
  }) async {
    try {
      final response = await dio.get(
        APIType.public,
        'poskeeper-sales-delete',
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<List<CustomerLedger>?> getCustomerLedgerReport({
    required String? customerId,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-customer-ledger',
        {
          'customer_id': customerId,
        },
        query: {
          'customer_id': customerId,
        },
        headers: _buildHeader(),
      );

      return parseList(
        list: response.data,
        fromJson: CustomerLedger.fromJson,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<VendorLedger>?> getVendorLedgerReport({
    required String? vendorId,
  }) async {
    try {
      final response = await dio.post(
        APIType.public,
        'poskeeper-vendor-ledger',
        {
          'vendor_id': vendorId,
        },
        query: {
          'vendor_id': vendorId,
        },
        headers: _buildHeader(),
      );

      return parseList(
        list: response.data,
        fromJson: VendorLedger.fromJson,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<CustomerLedger>?> getAccountSalesList({
    required String? customerId,
    required String? startDate,
    required String? endDate,
    required String? keyword,
  }) async {
    try {
      final data = {
        'customer_id': customerId,
        'start_date': startDate,
        'end_date': endDate,
        'keyword': keyword,
      }..removeWhere(
          (key, value) => value == null,
        );

      final response = await dio.post(
        APIType.public,
        'poskeeper-account-sales',
        data,
        query: data,
        headers: _buildHeader(),
      );

      return parseList(
        list: response.data,
        fromJson: CustomerLedger.fromJson,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<VendorLedger>?> getAccountPurchaseList({
    required String? vendorId,
    required String? startDate,
    required String? endDate,
    required String? keyword,
  }) async {
    try {
      final data = {
        'vendor_id': vendorId,
        'start_date': startDate,
        'end_date': endDate,
        'keyword': keyword,
      }..removeWhere(
          (key, value) => value == null,
        );

      final response = await dio.post(
        APIType.public,
        'poskeeper-account-purchase',
        data,
        query: data,
        headers: _buildHeader(),
      );

      return parseList(
        list: response.data,
        fromJson: VendorLedger.fromJson,
      );
    } catch (e) {
      return null;
    }
  }
}
