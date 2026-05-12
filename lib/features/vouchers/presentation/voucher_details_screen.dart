import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/voucher_models.dart';
import '../data/voucher_repository.dart';
import '../data/voucher_operation_models.dart';

class VoucherDetailsScreen extends ConsumerWidget {
  final VoucherHistoryResponse voucher;

  const VoucherDetailsScreen({super.key, required this.voucher});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voucher Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.confirmation_num, size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 16),
                  Text(
                    voucher.productName ?? '',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${voucher.currency} ${voucher.amount}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            _buildDetailItem(
              context,
              'Voucher Code',
              voucher.voucherCode ?? 'Processing...',
              canCopy: voucher.voucherCode != null,
            ),
            if (voucher.pin != null)
              _buildDetailItem(
                context,
                'PIN',
                voucher.pin!,
                canCopy: true,
              ),
            if (voucher.serialNumber != null)
              _buildDetailItem(
                context,
                'Serial Number',
                voucher.serialNumber!,
                canCopy: true,
              ),
            _buildDetailItem(
              context,
              'Expiry Date',
              voucher.expiryDate?.split('T')[0] ?? 'No expiry',
            ),
            _buildDetailItem(
              context,
              'Purchase Date',
              voucher.createdAtUtc?.split('T')[0] ?? '',
            ),
            const SizedBox(height: 24),
            const Text(
              'Operational History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _VoucherOperationsList(voucherId: voucher.id!),
            const SizedBox(height: 40),
            const Card(
              color: Color(0xFFFFF3E0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'How to Redeem',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. Visit the store or website.\n2. Present this code at checkout.\n3. Your discount will be applied immediately.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (canCopy)
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}

final voucherOperationsProvider = FutureProvider.family<List<VoucherOperationResponse>, int>((ref, id) async {
  return ref.watch(voucherRepositoryProvider).getVoucherOperations(id);
});

class _VoucherOperationsList extends ConsumerWidget {
  final int voucherId;

  const _VoucherOperationsList({required this.voucherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opsAsync = ref.watch(voucherOperationsProvider(voucherId));

    return opsAsync.when(
      data: (ops) => Column(
        children: ops.isEmpty 
            ? [const Text('No history found')] 
            : ops.map((op) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(op.status ?? ''),
                subtitle: Text(op.message ?? ''),
                trailing: Text(op.createdAtUtc?.split('T')[0] ?? ''),
                leading: const Icon(Icons.history_edu, size: 20),
              )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Text('Could not load history'),
    );
  }
}
