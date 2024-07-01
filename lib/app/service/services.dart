import 'package:dio/dio.dart';

import '/app/core/core_model/setup.dart';
import '/app/core/session_manager/session_manager.dart';
import 'client/api_options.dart';
import 'client/rest_client.dart';

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
}
