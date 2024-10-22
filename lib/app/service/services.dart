import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sandra/app/entity/restaurant/restaurant_table.dart';
import 'package:sandra/app/entity/sync_list.dart';

import '/app/core/core_model/logged_user.dart';
import '/app/core/core_model/setup.dart';
import '/app/core/session_manager/session_manager.dart';
import '/app/entity/customer.dart';
import '/app/entity/customer_ledger.dart';
import '/app/entity/expense.dart';
import '/app/entity/purchase.dart';
import '/app/entity/sales.dart';
import '/app/entity/stock.dart';
import '/app/entity/vendor.dart';
import '/app/entity/vendor_ledger.dart';
import 'client/api_options.dart';
import 'client/rest_client.dart';
import 'parser.dart';

class Services {
  factory Services() {
    return instance;
  }
  Services._privateConstructor();

  static final Services instance = Services._privateConstructor();

  final pref = SessionManager();
  final dio = RestClient(
    baseUrl: 'http://www.terminalbd.com/flutter-api/',
    token: '',
  );

  static const endpointOrderProcess = 'poskeeper-order-process';

  Map<String, dynamic> _buildHeader() {
    return {
      'X-API-KEY': 'terminalbd',
      'X-API-VALUE': 'terminalbd@aps',
      'X-API-SECRET': SetUp().uniqueCode ?? '',
    };
  }

  void printError(
    dynamic e,
    dynamic s,
    String endPoint,
  ) {
    if (kDebugMode) {
      print('Error: $e');
      print('Error: $s');
    }

    const endPoint = 'poskeeper-error-log';

    try {} catch (e) {}
  }

  Future<Map<String, dynamic>?> submitLicense({
    required String license,
    required String activeKey,
  }) async {
    const endPoint = 'poskeeper-splash';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'mobile': license,
          'uniqueCode': activeKey,
          'deviceId': '',
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return null;
      return responseData;
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMasterData() async {
    const endPoint = 'poskeeper-masterdata';
    try {
      final license = await pref.getLicenseKey();
      final activeKey = await pref.getActiveKey();
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'mobile': license,
          'uniqueCode': activeKey,
          'deviceId': '',
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return null;
      return responseData;
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getStockItems() async {
    const endPoint = 'poskeeper-stock-item';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {},
        headers: _buildHeader(),
      );
      final responseData = response.data as List?;
      if (responseData == null) return null;
      return responseData.map((e) => e as Map<String, dynamic>).toList();
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<Customer?> addCustomer({
    required String name,
    required String mobile,
    required String address,
    required String email,
    required String openingBalance,
  }) async {
    const endPoint = 'poskeeper-customer-create';
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
        endPoint,
        data,
        query: data,
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return null;
      return parseObject(
        object: responseData,
        fromJson: Customer.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<Vendor?> addVendor({
    required String name,
    required String mobile,
    required String address,
    required String email,
    required String openingBalance,
  }) async {
    const endPoint = 'poskeeper-vendor-create';
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
        endPoint,
        data,
        query: data,
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return null;
      return parseObject(
        object: responseData,
        fromJson: Vendor.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<Stock?>? addStock({
    required String name,
    required String? categoryId,
    required String? brandId,
    required String modelNumber,
    required String unitId,
    required String purchasePrice,
    required String salesPrice,
    required String discountPrice,
    required String minQty,
    required String openingQty,
    required String description,
  }) async {
    const endPoint = 'poskeeper-stock-create';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'name': name,
          'category_id': categoryId ?? '',
          'brand_id': brandId ?? '',
          'model_no': modelNumber,
          'unit_id': unitId,
          'purchase_price': purchasePrice,
          'sales_price': salesPrice,
          'discount_price': discountPrice,
          'min_quantity': minQty,
          'opening_quantity': openingQty,
          'description': description,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return null;
      return parseObject(
        object: responseData,
        fromJson: Stock.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<List<Sales>?> getSalesList({
    required String? startDate,
    required String? endDate,
    required String? customerId,
    required String? keyword,
    required int page,
  }) async {
    const endPoint = 'poskeeper-online-sales';
    try {
      final query = <String, dynamic>{};
      if (startDate != null) query['start_date'] = startDate;
      if (endDate != null) query['end_date'] = endDate;
      if (customerId != null) query['customer_id'] = customerId;
      if (keyword != null) query['keyword'] = keyword;

      query['page'] = page;
      final response = await dio.post(
        APIType.public,
        endPoint,
        query,
        query: query,
        headers: _buildHeader(),
      );
      final responseData = response.data as List?;
      if (responseData == null) return null;
      return parseList(
        list: response.data,
        fromJson: Sales.fromJson,
      );
    } catch (e, ee) {
      if (kDebugMode) {
        print('Error: $e');
        print('Error: $ee');
      }
      return null;
    }
  }

  Future<List<Purchase>?> getPurchaseList({
    required String? startDate,
    required String? endDate,
    required String? vendorId,
    required String? keyword,
    required int page,
  }) async {
    const endPoint = 'poskeeper-online-purchase';
    try {
      final query = <String, dynamic>{};
      if (startDate != null) query['start_date'] = startDate;
      if (endDate != null) query['end_date'] = endDate;
      if (vendorId != null) query['vendor_id'] = vendorId;
      if (keyword != null) query['keyword'] = keyword;
      query['page'] = page;

      final response = await dio.post(
        APIType.public,
        endPoint,
        query,
        query: query,
        headers: _buildHeader(),
      );

      final responseData = response.data as List?;
      if (responseData == null) return null;

      return parseList(
        list: response.data,
        fromJson: Purchase.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<Sales?> getOnlineSalesDetails({
    required String id,
  }) async {
    const endPoint = 'poskeeper-online-sales-details';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );
      return Sales.fromJson(response.data);
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<Purchase?> getOnlinePurchaseDetails({
    required String id,
  }) async {
    const endPoint = 'poskeeper-online-purchase-details';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return null;
      return parseObject(object: responseData, fromJson: Purchase.fromJson);
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<bool> postCustomerReceive({
    required String customer,
    required String method,
    required String mode,
    required String amount,
    required String userId,
    required String? remark,
    required bool? isSms,
    required bool? isApprove,
  }) async {
    const endPoint = 'poskeeper-account-receive';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'customer_id': customer,
          'method_id': method,
          'mode': mode,
          'amount': amount,
          'user_id': userId,
          'remark': remark,
          'is_sms': isSms,
          'is_approve': isApprove,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null || responseData['status'] == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
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
    required bool? isSms,
    required bool? isApprove,
  }) async {
    const endPoint = 'poskeeper-account-payment';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'vendor_id': vendor,
          'method_id': method,
          'mode': mode,
          'amount': amount,
          'user_id': userId,
          'remark': remark,
          'is_sms': isSms,
          'is_approve': isApprove,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null || responseData['status'] == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> postSales({
    required List salesList,
    required String mode,
  }) async {
    try {
      final autoApprove = await pref.getIsSalesAutoApprove();
      final response = await dio.post(
        APIType.public,
        endpointOrderProcess,
        {
          'content': jsonEncode(salesList),
          'mode': mode,
          'is_approve': autoApprove ? '1' : '0',
          'approved_by': autoApprove ? LoggedUser().userId : '',
          'process': 'sales',
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e, s) {
      printError(e, s, endpointOrderProcess);
      return false;
    }
  }

  Future<bool> postPurchase({
    required List purchaseList,
    required String mode,
  }) async {
    try {
      final autoApprove = await pref.getIsPurchaseAutoApprove();
      final response = await dio.post(
        APIType.public,
        endpointOrderProcess,
        {
          'content': jsonEncode(purchaseList),
          'mode': mode,
          'is_approve': autoApprove ? '1' : '0',
          'approved_by': autoApprove ? LoggedUser().userId : '',
          'process': 'purchase',
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e, s) {
      printError(e, s, endpointOrderProcess);
      return false;
    }
  }

  Future<bool> updateSales({
    required List salesList,
  }) async {
    const endPoint = 'poskeeper-sales-update';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'sales': jsonEncode(salesList),
          'mode': 'online',
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> updatePurchase({
    required List purchaseList,
  }) async {
    const endPoint = 'poskeeper-purchase-update';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'sales': jsonEncode(purchaseList),
          'mode': 'online',
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> deleteSales({
    required String id,
  }) async {
    const endPoint = 'poskeeper-sales-delete';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> deletePurchase({
    required String id,
  }) async {
    const endPoint = 'poskeeper-online-purchase-delete';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) return false;

      return responseData['message'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<List<CustomerLedger>?> getCustomerLedgerReport({
    required String? customerId,
  }) async {
    const endPoint = 'poskeeper-customer-ledger';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
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
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<List<VendorLedger>?> getVendorLedgerReport({
    required String? vendorId,
  }) async {
    const endPoint = 'poskeeper-vendor-ledger';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
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
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<List<CustomerLedger>?> getAccountSalesList({
    required String? customerId,
    required String? startDate,
    required String? endDate,
    required String? keyword,
    required int page,
  }) async {
    const endPoint = 'poskeeper-account-sales';
    try {
      final data = {
        'customer_id': customerId,
        'start_date': startDate,
        'end_date': endDate,
        'keyword': keyword,
        'page': page,
      }..removeWhere(
          (key, value) => value == null,
        );

      log('page: $page');

      final response = await dio.post(
        APIType.public,
        endPoint,
        data,
        query: data,
        headers: _buildHeader(),
      );

      return parseList(
        list: response.data,
        fromJson: CustomerLedger.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<List<VendorLedger>?> getAccountPurchaseList({
    required String? vendorId,
    required String? startDate,
    required String? endDate,
    required String? keyword,
    required int page,
  }) async {
    const endPoint = 'poskeeper-account-purchase';
    try {
      final data = {
        'vendor_id': vendorId,
        'start_date': startDate,
        'end_date': endDate,
        'keyword': keyword,
        'page': page,
      }..removeWhere(
          (key, value) => value == null,
        );

      final response = await dio.post(
        APIType.public,
        endPoint,
        data,
        query: data,
        headers: _buildHeader(),
      );

      return parseList(
        list: response.data,
        fromJson: VendorLedger.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<bool?> addExpense({
    required amount,
    required String remark,
    required expenseCategoryId,
    required userId,
    required transactionMethodId,
  }) async {
    const endPoint = 'poskeeper-expense-create';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'amount': amount,
          'remark': remark,
          'category_id': expenseCategoryId,
          'to_user_id': userId,
          'method_id': transactionMethodId,
          'created_by_id': LoggedUser().userId,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<List<Expense>?> getExpenseList({
    required String? startDate,
    required String? endDate,
    required String? keyword,
    required int page,
  }) async {
    const endPoint = 'poskeeper-account-expense';

    try {
      final query = <String, dynamic>{};
      if (startDate != null) query['start_date'] = startDate;
      if (endDate != null) query['end_date'] = endDate;
      if (keyword != null) query['keyword'] = keyword;
      query['page'] = page;
      final response = await dio.post(
        APIType.public,
        endPoint,
        query,
        headers: _buildHeader(),
      );
      final responseData = response.data as List?;
      if (responseData == null) return null;
      return parseList(
        list: responseData,
        fromJson: Expense.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<bool> deleteExpense({
    required String id,
  }) async {
    const endPoint = 'poskeeper-expense-delete';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> approveExpense({
    required String id,
  }) async {
    const endPoint = 'poskeeper-expense-approve';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        query: {
          'id': id,
          'user_id': LoggedUser().userId,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> approveAccountSale({
    required String id,
  }) async {
    const endPoint = 'poskeeper-account-sales-approve';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'id': id,
          'user_id': LoggedUser().userId,
        },
        query: {
          'id': id,
          'user_id': LoggedUser().userId,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> approveAccountPurchase({
    required String id,
  }) async {
    const endPoint = 'poskeeper-account-purchase-approve';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'id': id,
          'user_id': LoggedUser().userId,
        },
        query: {
          'id': id,
          'user_id': LoggedUser().userId,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> deleteAccountSale({
    required String id,
  }) async {
    const endPoint = 'poskeeper-account-sales-delete';
    try {
      final response = await dio.get(
        APIType.public,
        'poskeeper-account-sales-delete',
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<bool> deleteAccountPurchase({
    required String id,
  }) async {
    const endPoint = 'poskeeper-account-purchase-delete';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        query: {
          'id': id,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  Future<List<SyncList>?> getSyncList() async {
    const endPoint = 'poskeeper-sync-list';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {},
        headers: _buildHeader(),
      );
      final responseData = response.data as List;
      if (responseData.isEmpty) return null;
      return parseList(
        list: responseData,
        fromJson: SyncList.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }

  Future<bool> approveSyncList({
    required SyncList element,
  }) async {
    const endPoint = 'poskeeper-sync-process';
    try {
      final response = await dio.post(
        APIType.public,
        endPoint,
        {
          'id': element.id.toString(),
        },
        query: {
          'id': element.id,
        },
        headers: _buildHeader(),
      );
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData == null) return false;
      return responseData['status'] == 'success';
    } catch (e, s) {
      printError(e, s, endPoint);
      return false;
    }
  }

  // Restaurant module
  Future<List<RestaurantTable>?> getRestaurantTableList() async {
    const endPoint = 'poskeeper-restaurant-table';
    try {
      final response = await dio.get(
        APIType.public,
        endPoint,
        headers: _buildHeader(),
      );
      final responseData = response.data as List;
      print('restaurant table list : $responseData');
      if (responseData.isEmpty) return null;
      return parseList(
        list: responseData,
        fromJson: RestaurantTable.fromJson,
      );
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }
}
