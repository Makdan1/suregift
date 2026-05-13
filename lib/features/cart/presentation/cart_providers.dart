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

  Future<void> updateQuantity(int itemId, int quantity, {double? amount}) async {
    final previousState = state;
    try {
      final updatedCart = await _repository.updateCartItem(itemId, quantity, amount: amount);
      state = AsyncValue.data(updatedCart);
    } catch (e, st) {
      state = previousState; // Revert to previous state
      // Optionally notify UI
    }
  }

  Future<void> removeItem(int itemId) async {
    final previousState = state;
    try {
      final updatedCart = await _repository.removeFromCart(itemId);
      state = AsyncValue.data(updatedCart);
    } catch (e, st) {
      state = previousState;
    }
  }

  Future<void> clearCart() async {
    final previousState = state;
    // Optimistically clear the state for immediate UI feedback
    if (state.hasValue) {
      final currentCart = state.value!;
      state = AsyncValue.data(CartResponse(
        cartId: currentCart.cartId,
        items: [],
        subtotal: 0,
        currency: currentCart.currency,
      ));
    }

    try {
      await _repository.clearCart();
      // Refetch to stay in sync with server
      await fetchCart();
    } catch (e, st) {
      // If server clear fails, revert to previous state
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }
}
