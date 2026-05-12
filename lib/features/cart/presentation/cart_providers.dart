import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cart_repository.dart';
import '../data/cart_models.dart';

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<CartResponse>>((ref) {
  return CartNotifier(ref.watch(cartRepositoryProvider));
});

class CartNotifier extends StateNotifier<AsyncValue<CartResponse>> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchCart();
  }

  Future<void> fetchCart() async {
    state = const AsyncValue.loading();
    try {
      final cart = await _repository.getCart();
      state = AsyncValue.data(cart);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateQuantity(int itemId, int quantity) async {
    try {
      final updatedCart = await _repository.updateCartItem(itemId, quantity);
      state = AsyncValue.data(updatedCart);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removeItem(int itemId) async {
    try {
      final updatedCart = await _repository.removeFromCart(itemId);
      state = AsyncValue.data(updatedCart);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> clearCart() async {
    try {
      await _repository.clearCart();
      await fetchCart();
    } catch (e) {
      // Handle error
    }
  }
}
