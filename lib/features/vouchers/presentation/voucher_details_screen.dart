import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/voucher_models.dart';
import '../data/voucher_repository.dart';
import '../data/voucher_operation_models.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/common_widgets.dart';

final voucherOperationsProvider = FutureProvider.family<List<VoucherOperationResponse>, int>((ref, id) {
  return ref.watch(voucherRepositoryProvider).getVoucherOperations(id);
});

class VoucherDetailsScreen extends ConsumerWidget {
  final VoucherHistoryResponse voucher;

  const VoucherDetailsScreen({super.key, required this.voucher});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationsAsync = ref.watch(voucherOperationsProvider(voucher.id!));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Center(
              child: Column(
                children: [
                  Text(
                    voucher.productName ?? 'Voucher',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(voucher.amount, currency: voucher.currency),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Voucher Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Voucher Code',
                    value: voucher.voucherCode ?? 'N/A',
                    isCode: true,
                  ),
                  if (voucher.pin != null) ...[
                    const Divider(height: 32),
                    _InfoRow(
                      label: 'PIN',
                      value: voucher.pin!,
                      isCode: true,
                    ),
                  ],
                  if (voucher.serialNumber != null) ...[
                    const Divider(height: 32),
                    _InfoRow(
                      label: 'Serial Number',
                      value: voucher.serialNumber!,
                    ),
                  ],
                  const Divider(height: 32),
                  _InfoRow(
                    label: 'Expiry Date',
                    value: voucher.expiryDate?.split('T')[0] ?? 'No Expiry',
                    valueColor: Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Instructions
            Text(
              'Instructions & Terms',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              '• Present this code at the merchant location or use it online.\n'
              '• Ensure the PIN is kept confidential.\n'
              '• Vouchers are subject to merchant terms and conditions.',
              style: TextStyle(height: 1.6, color: isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(height: 40),

            // Operations History
            Text(
              'Operational History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            operationsAsync.when(
              data: (ops) {
                if (ops.isEmpty) return const Text('No history available', style: TextStyle(color: Colors.grey));
                return Column(
                  children: ops.map((op) => _OperationItem(operation: op)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) {
                if (err.toString().contains('404')) {
                  return const Text('No history available', style: TextStyle(color: Colors.grey));
                }
                return NiceErrorWidget(
                  message: err.toString(),
                  onRetry: () => ref.refresh(voucherOperationsProvider(voucher.id!)),
                );
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCode;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isCode = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: isCode ? 1.5 : 0,
                color: valueColor,
              ),
            ),
          ],
        ),
        if (isCode)
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              TopSnackbar.show(context, '$label copied to clipboard', isError: false);
            },
          ),
      ],
    );
  }
}

class _OperationItem extends StatelessWidget {
  final VoucherOperationResponse operation;

  const _OperationItem({required this.operation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(operation.status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  operation.status ?? 'Status',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  operation.message ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            operation.createdAtUtc?.split('T')[0] ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'purchased':
      case 'delivered':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
