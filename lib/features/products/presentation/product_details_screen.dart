import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../data/product_models.dart';
import '../../cart/data/cart_repository.dart';
import '../../cart/presentation/cart_providers.dart';
import '../../../core/widgets/common_widgets.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final SuregiftsProductResponse product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  double? _selectedAmount;
  final _amountController = TextEditingController();
  int _quantity = 1;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.denominations?.isNotEmpty == true) {
      _selectedAmount = widget.product.denominations![0];
    }
  }

  Future<void> _addToCart() async {
    final amount = widget.product.denominations?.isNotEmpty == true
        ? _selectedAmount
        : double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a valid amount')),
      );
      return;
    }

    setState(() => _isAdding = true);
    try {
      await ref.read(cartRepositoryProvider).addToCart(
            widget.product.code!,
            amount,
            _quantity,
          );
      ref.invalidate(cartProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${p.code}',
                child: CachedNetworkImage(
                  imageUrl: p.imageUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  p.name ?? '',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  p.categories?.join(', ') ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  p.description ?? 'No description available.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                if (p.denominations?.isNotEmpty == true) ...[
                  Text(
                    'Select Amount (${p.currency})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: p.denominations!.map((d) {
                      final isSelected = _selectedAmount == d;
                      return ChoiceChip(
                        label: Text(d.toInt().toString()),
                        selected: isSelected,
                        onSelected: (val) => setState(() => _selectedAmount = d),
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ] else ...[
                  Text(
                    'Enter Amount (${p.currency})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    hintText: 'Min: ${p.minValue}, Max: ${p.maxValue}',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Quantity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _quantity.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                AppButton(
                  text: 'Add to Cart',
                  isLoading: _isAdding,
                  onPressed: _addToCart,
                ),
                const SizedBox(height: 24),
                if (p.redemptionDetails?.isNotEmpty == true) ...[
                  Text(
                    'Redemption Instructions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...p.redemptionDetails!.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• $r', style: Theme.of(context).textTheme.bodyMedium),
                      )),
                ],
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
