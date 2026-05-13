import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import 'order_models.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(dioProvider));
});

final ordersProvider = FutureProvider<List<OrderResponse>>((ref) {
  return ref.watch(orderRepositoryProvider).getOrders();
});

class OrderRepository {
  final Dio _dio;

  OrderRepository(this._dio);

  Future<List<OrderResponse>> getOrders() async {
    try {
      final response = await _dio.get(AppConstants.ordersUrl);
      return (response.data as List)
          .map((e) => OrderResponse.fromJson(e))
          .toList();
    } catch (e) {
      // Fallback: If orders endpoint doesn't exist, we might need another way
      // For now, rethrow or return empty
      rethrow;
    }
  }
}
