import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/core_model/logged_user.dart';
import '/app/core/session_manager/session_manager.dart';
import '/app/service/endpoints.dart';
import '/flavors/build_config.dart';
import 'client/api_options.dart';
import 'client/rest_client.dart';

class Services {
  final pref = SessionManager();
  final dio = RestClient(
    baseUrl: BuildConfig.instance.config.baseUrl,
    token: '',
  );

  Future<Map<String, dynamic>> _buildHeader() async {
    return {};
  }

  Future<bool> validateResponse(Response<dynamic> response) async {
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final data = {
      'username': username,
      'email': email,
      'password': password,
    };

    final response = await dio.post(
      APIType.public,
      endpointRegister,
      data,
    );
    if (response.statusCode == 200) {
      final responseMap = response.data as Map<String, dynamic>;
      if (responseMap['code'] is int && responseMap['code'] == 200) {
        return true;
      }
    }
    return false;
  }

  Future<bool> authenticateUser({
    required String username,
    required String password,
  }) async {
    final data = {
      'username': username,
      'password': password,
    };

    final response = await dio.post(
      APIType.public,
      endpointLogin,
      data,
    );
    if (response.statusCode == 200) {
      final responseMap = response.data as Map<String, dynamic>;
      final token = responseMap['token'] as String;
      final decodedJWT = JwtDecoder.decode(token);

      if (decodedJWT?['data']?['user']?['id'] == null) {
        return false;
      }

      responseMap['user_id'] = decodedJWT!['data']['user']['id'];
      pref
        ..setIsLogin(isLogin: true)
        ..setUser(responseMap)
        ..setLoggedUserName(username)
        ..setLoggedUserPassword(password);

      LoggedUser.fromJson(responseMap);
      return true;
    }
    return false;
  }
}
