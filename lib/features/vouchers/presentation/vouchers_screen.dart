import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/voucher_repository.dart';
import '../data/voucher_models.dart';
import 'voucher_details_screen.dart';

final vouchersProvider = FutureProvider<List<VoucherHistoryResponse>>((ref) async {
  return ref.watch(voucherRepositoryProvider).getVouchers();
});

class VouchersScreen extends ConsumerWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersAsync = ref.watch(vouchersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vouchers'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(vouchersProvider.future),
        child: vouchersAsync.when(
          data: (vouchers) {
            if (vouchers.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.confirmation_number_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No vouchers found'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                final voucher = vouchers[index];
                return VoucherCard(voucher: voucher)
                    .animate()
                    .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                    .slideX(begin: -0.2, end: 0);
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
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: voucher.productImageUrl ?? '',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image_outlined),
            ),
          ),
        ),
        title: Text(
          voucher.productName ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${voucher.currency} ${voucher.amount}'),
            const SizedBox(height: 4),
            Text(
              'Date: ${voucher.createdAtUtc?.split('T')[0] ?? ''}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
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
