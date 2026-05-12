import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import 'cart_models.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.watch(dioProvider));
});

class CartRepository {
  final Dio _dio;

  CartRepository(this._dio);

  Future<CartResponse> getCart() async {
    try {
      final response = await _dio.get(AppConstants.cartUrl);
      return CartResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartResponse> addToCart(String productCode, double amount, int quantity) async {
    try {
      final response = await _dio.post(
        AppConstants.cartItemsUrl,
        data: {
          'productCode': productCode,
          'amount': amount,
          'quantity': quantity,
        },
      );
      return CartResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartResponse> updateCartItem(int cartItemId, int quantity, {double? amount}) async {
    try {
      final response = await _dio.put(
        '${AppConstants.cartItemsUrl}/$cartItemId',
        data: {
          'cartItemId': cartItemId,
          'quantity': quantity,
          if (amount != null) 'amount': amount,
        },
      );
      return CartResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartResponse> removeFromCart(int cartItemId) async {
    try {
      final response = await _dio.delete('${AppConstants.cartItemsUrl}/$cartItemId');
      return CartResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartTotalResponse> getCartTotal() async {
    try {
      final response = await _dio.get(AppConstants.cartTotalUrl);
      return CartTotalResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _dio.delete(AppConstants.cartUrl);
    } catch (e) {
      rethrow;
    }
  }
}
