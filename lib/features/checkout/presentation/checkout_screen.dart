import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/checkout_repository.dart';
import '../../cart/presentation/cart_providers.dart';
import '../../main/presentation/main_screen.dart';
import '../../main/presentation/main_providers.dart';
import '../../vouchers/data/voucher_repository.dart';
import '../../orders/data/order_repository.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/utils/currency_formatter.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processCheckout() async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(checkoutRepositoryProvider).checkout();
      await ref.read(cartProvider.notifier).clearCart();
      
      // Invalidate history providers to ensure fresh data
      ref.invalidate(ordersProvider);
      ref.invalidate(vouchersProvider);
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64)
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.bounceOut),
                const SizedBox(height: 16),
                const Text('Payment Successful!', textAlign: TextAlign.center),
              ],
            ),
            content: const Text(
              'Your gift card vouchers have been generated and are ready for use.',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              AppButton(
                text: 'View My Vouchers',
                onPressed: () {
                  ref.read(mainTabIndexProvider.notifier).state = 1;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (route) => false,
                  );
                },
                width: 220,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        TopSnackbar.show(context, e.toString(), isError: true);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: cartAsync.when(
        data: (cart) {
          final subtotal = cart.subtotal ?? 0;
          const fees = 0.0;
          final total = subtotal + fees;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Order',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please review your items and total before proceeding.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      
                      // Order Items
                      ...cart.items!.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.card_giftcard, color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Quantity: ${item.quantity}',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(item.subtotal, currency: item.currency),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                      
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      // Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                          Text(CurrencyFormatter.formatWithDecimals(subtotal, currency: cart.currency)),
                        ],
                      ),
                      if (fees > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Fees', style: TextStyle(color: Colors.grey)),
                            const Text('NGN 0.00', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Grand Total',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            CurrencyFormatter.formatWithDecimals(total, currency: cart.currency),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: AppButton(
                  text: 'Confirm & Pay',
                  isLoading: _isProcessing,
                  onPressed: _processCheckout,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => NiceErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(cartProvider),
        ),
      ),
    );
  }
}
