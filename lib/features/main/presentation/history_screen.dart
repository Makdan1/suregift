import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../orders/data/order_repository.dart';
import '../../orders/data/order_models.dart';
import '../../vouchers/data/voucher_repository.dart';
import '../../vouchers/data/voucher_models.dart';
import '../../vouchers/presentation/voucher_details_screen.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/common_widgets.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My History'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF25262B) : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? Theme.of(context).primaryColor : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: isDark ? Colors.white : Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Vouchers'),
                Tab(text: 'Orders'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VoucherHistoryList(),
          OrderHistoryList(),
        ],
      ),
    );
  }
}

class OrderHistoryList extends ConsumerWidget {
  const OrderHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(ordersProvider.future),
      child: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              message: 'You haven\'t placed any orders yet.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(order: order)
                  .animate()
                  .fadeIn(delay: (index * 50).ms)
                  .slideX(begin: 0.1, end: 0, delay: (index * 50).ms);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          if (err.toString().contains('404')) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              message: 'You haven\'t placed any orders yet.',
            );
          }
          return NiceErrorWidget(
            message: err.toString(),
            onRetry: () => ref.refresh(ordersProvider),
          );
        },
      ),
    );
  }
}

class VoucherHistoryList extends ConsumerWidget {
  const VoucherHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersAsync = ref.watch(vouchersProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vouchersProvider.future),
      child: vouchersAsync.when(
        data: (vouchers) {
          if (vouchers.isEmpty) {
            return const EmptyState(
              icon: Icons.card_giftcard_outlined,
              message: 'No vouchers found in your history.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              final voucher = vouchers[index];
              return VoucherHistoryCard(voucher: voucher)
                  .animate()
                  .fadeIn(delay: (index * 50).ms)
                  .slideX(begin: 0.1, end: 0, delay: (index * 50).ms);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          if (err.toString().contains('404')) {
            return const EmptyState(
              icon: Icons.card_giftcard_outlined,
              message: 'No vouchers found in your history.',
            );
          }
          return NiceErrorWidget(
            message: err.toString(),
            onRetry: () => ref.refresh(vouchersProvider),
          );
        },
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Theme.of(context).dividerColor),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderResponse order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderNumber ?? order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.createdAtUtc?.split('T')[0] ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                StatusBadge(status: order.status ?? 'Pending'),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF25262B) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.card_giftcard, size: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${order.voucherCount ?? 0} Items',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  CurrencyFormatter.format(order.totalAmount, currency: order.currency),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherHistoryCard extends StatelessWidget {
  final VoucherHistoryResponse voucher;

  const VoucherHistoryCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VoucherDetailsScreen(voucher: voucher),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 60,
                  height: 60,
                  color: isDark ? const Color(0xFF25262B) : Colors.grey[100],
                  child: voucher.productImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: voucher.productImageUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.card_giftcard, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            voucher.productName ?? 'Voucher',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const StatusBadge(status: 'Active'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Purchased: ${voucher.createdAtUtc?.split('T')[0] ?? ''}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    if (voucher.expiryDate != null)
                      Text(
                        'Expires: ${voucher.expiryDate!.split('T')[0]}',
                        style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormatter.format(voucher.amount, currency: voucher.currency),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
      case 'active':
      case 'success':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
