import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:getx_template/app/model/customer_ledger.dart';
import 'package:getx_template/app/model/sales.dart';

import '/app/core/core_model/setup.dart';
import '/app/core/session_manager/session_manager.dart';
import '/app/model/customer.dart';
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
      print(
        '\x1B[31m Parsing List $T \x1B[0m\n',
      );
    }
    return list.map((e) => fromJson(e)).toList();
  } on Exception catch (e) {
    if (kDebugMode) {
      print('Error parsing list: $e');
    }
  }
  return null;
}

class Services {
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
    required bool shouldShowLoader,
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
    required bool shouldShowLoader,
    required String name,
    required String mobile,
    required String address,
    required String email,
    required String openingBalance,
  }) async {
    final response = await dio.post(
      APIType.public,
      'poskeeper-customer-create',
      {
        'name': name,
        'mobile': mobile,
        'address': address,
        'email': email,
        'openingBalance': openingBalance,
      },
      headers: _buildHeader(),
    );

    return response.data == null ? null : Customer.fromJson(response.data);
  }

  Future<Map<String, dynamic>?>? addStock({
    required bool shouldShowLoader,
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
  }

  Future<List<Sales>?> getSalesList({
    required String? startDate,
    required String? endDate,
    required String? customerId,
    required String? vendorId,
    required String? keyword,
  }) async {
    final query = <String, dynamic>{};
    if (startDate != null) query['start_date'] = startDate;
    if (endDate != null) query['end_date'] = endDate;
    if (customerId != null) query['customer_id'] = customerId;
    if (vendorId != null) query['vendor_id'] = vendorId;
    if (keyword != null) query['keyword'] = keyword;

    final response = await dio.post(
      APIType.public,
      'poskeeper-online-sales-list',
      query,
      query: query,
     // headers: _buildHeader(),
    );

    return parseList(
      list: response.data,
      fromJson: Sales.fromJson,
    );
  }

  Future<Sales?> getOnlineSalesDetails({
    required bool shouldShowLoader,
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
    return Sales.fromJson(response.data);
  }

  Future<bool> postReceive({
    required bool shouldShowLoader,
    required String customer,
    required String method,
    required String mode,
    required String amount,
    required String userId,
    required String? remark,
  }) async {
    final response = await dio.post(
      APIType.public,
      'poskeeper-account-receive',
      {
        'customer': customer,
        'method': method,
        'mode': mode,
        'amount': amount,
        'userId': userId,
        'remark': remark,
      },
      headers: _buildHeader(),
    );
    return false;
  }

  Future<bool> postSales({
    required bool shouldShowLoader,
    required List salesList,
    required String mode,
  }) async {
    final response = await dio.post(
      APIType.public,
      'poskeeper-sales',
      {
        'sales': jsonEncode(salesList),
        'mode': mode,
      },
      headers: _buildHeader(),
    );

    if (response.data == null) return false;
    return response.data['message'] == 'success';
  }

  Future<bool> updateSales({
    required bool shouldShowLoader,
    required List salesList,
  }) async {
    final response = await dio.post(
      APIType.public,
      'poskeeper-sales-update',
      {
        'sales': jsonEncode(salesList),
        'mode': 'online',
      },
      headers: _buildHeader(),
    );

    if (response.data == null) return false;
    return response.data['message'] == 'success';
  }

  Future<bool> deleteSales({
    required bool shouldShowLoader,
    required String id,
  }) async {
    final response = await dio.get(
      APIType.public,
      'poskeeper-sales-delete',
      query: {
        'id': id,
      },
      headers: _buildHeader(),
    );

    if (response.data == null) return false;
    return response.data['message'] == 'success';
  }

  Future<List<CustomerLedger>?> getCustomerLedgerReport({
    required bool shouldShowLoader,
    required String? customerId,
  }) async {
    final response = await dio.post(
      APIType.public,
      'poskeeper-customer-ledger',
      {
        'customerId': customerId,
      },
      query: {
        'customerId': customerId,
      },
      headers: _buildHeader(),
    );

    return parseList(
      list: response.data,
      fromJson: CustomerLedger.fromJson,
    );
  }
}
