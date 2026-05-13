import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/data/cart_repository.dart';
import '../../cart/presentation/cart_providers.dart';

final productControllerProvider = StateNotifierProvider<ProductController, AsyncValue<void>>((ref) {
  return ProductController(ref.read(cartRepositoryProvider), ref);
});

class ProductController extends StateNotifier<AsyncValue<void>> {
  final CartRepository _cartRepository;
  final Ref _ref;

  ProductController(this._cartRepository, this._ref) : super(const AsyncValue.data(null));

  Future<bool> addToCart({
    required String productCode,
    required double amount,
    required int quantity,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _cartRepository.addToCart(productCode, amount, quantity);
      _ref.invalidate(cartProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
