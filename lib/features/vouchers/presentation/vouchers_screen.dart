import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/voucher_repository.dart';
import '../data/voucher_models.dart';
import 'voucher_details_screen.dart';
import '../../../core/utils/currency_formatter.dart';

class VouchersScreen extends ConsumerWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersAsync = ref.watch(vouchersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchased Vouchers'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(vouchersProvider.future),
        child: vouchersAsync.when(
          data: (vouchers) {
            if (vouchers.isEmpty) {
              return const Center(child: Text('No purchases yet'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                final voucher = vouchers[index];
                return VoucherCard(voucher: voucher)
                    .animate()
                    .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                    .slideX(begin: 0.1, end: 0);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  final VoucherHistoryResponse voucher;

  const VoucherCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(voucher.productName ?? 'Voucher'),
        subtitle: Text(
          'Date: ${voucher.createdAtUtc?.split('T')[0] ?? ''}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(voucher.amount, currency: voucher.currency),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Icon(Icons.chevron_right, size: 16),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VoucherDetailsScreen(voucher: voucher),
            ),
          );
        },
      ),
    );
  }
}
