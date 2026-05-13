import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import 'product_models.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(dioProvider));
});

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<SuregiftsProductResponse>> getProducts() async {
    try {
      final response = await _dio.get(AppConstants.productsUrl);
      return (response.data as List)
          .map((e) => SuregiftsProductResponse.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<SuregiftsProductResponse> getProductById(String productId) async {
    try {
      final response = await _dio.get('${AppConstants.productsUrl}/$productId');
      return SuregiftsProductResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
