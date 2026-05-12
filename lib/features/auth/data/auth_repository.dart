import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider), const FlutterSecureStorage());
});

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository(this._dio, this._storage);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.loginUrl,
        data: {
          'email': email,
          'password': password,
        },
      );
      final loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.accessToken != null) {
        await _storage.write(key: AppConstants.tokenKey, value: loginResponse.accessToken);
      }
      return loginResponse;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final error = ErrorResponse.fromJson(e.response?.data);
        throw Exception(error.message ?? 'Login failed');
      }
      throw Exception('Network error');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null;
  }
}
