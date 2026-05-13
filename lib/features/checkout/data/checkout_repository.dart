import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import 'checkout_models.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository(ref.watch(dioProvider));
});

class CheckoutRepository {
  final Dio _dio;

  CheckoutRepository(this._dio);

  Future<double> calculateTotal() async {
    try {
      final response = await _dio.post(AppConstants.calculateTotalUrl);
      return response.data['total']?.toDouble() ?? 0.0;
    } catch (e) {
      rethrow;
    }
  }

  Future<CheckoutResponse> checkout() async {
    try {
      final response = await _dio.post(AppConstants.checkoutUrl);
      return CheckoutResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
class CheckoutTotalResponse {
  final double total;
  CheckoutTotalResponse(this.total);
}
