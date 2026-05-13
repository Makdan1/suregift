import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../data/product_models.dart';
import '../../cart/presentation/cart_providers.dart';
import '../../cart/presentation/cart_screen.dart';
import 'product_controller.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/utils/currency_formatter.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final SuregiftsProductResponse product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  double? _selectedAmount;
  int _quantity = 1;
  late List<double> _availableAmounts;

  @override
  void initState() {
    super.initState();
    // Use the business logic defined in the model
    _availableAmounts = widget.product.validAmounts;
    if (_availableAmounts.isNotEmpty) {
      _selectedAmount = _availableAmounts[0];
    }
  }

  Future<void> _handleAddToCart() async {
    if (_selectedAmount == null) return;

    final success = await ref.read(productControllerProvider.notifier).addToCart(
          productCode: widget.product.code!,
          amount: _selectedAmount!,
          quantity: _quantity,
        );
    
    if (success && mounted) {
      TopSnackbar.show(context, 'Added ${widget.product.name} to cart!', isError: false);
      Navigator.pop(context);
    } else if (mounted) {
      final error = ref.read(productControllerProvider).error;
      TopSnackbar.show(context, error?.toString() ?? 'Failed to add to cart', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final cartAsync = ref.watch(cartProvider);
    final isAdding = ref.watch(productControllerProvider).isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final itemCount = cartAsync.maybeWhen(
      data: (cart) => cart.items?.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0)) ?? 0,
      orElse: () => 0,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: Badge(
                  label: Text(itemCount.toString()),
                  isLabelVisible: itemCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              const SizedBox(width: 8),
            ],
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
                _buildHeader(context, p),
                const SizedBox(height: 8),
                _buildCategories(context, p),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Description'),
                const SizedBox(height: 8),
                _buildDescription(context, p),
                const SizedBox(height: 32),
                
                if (_availableAmounts.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Select Amount'),
                  const SizedBox(height: 16),
                  _buildAmountChips(context, isDark),
                ] else ...[
                   _buildNoAmountsMessage(),
                ],
                
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Quantity'),
                const SizedBox(height: 12),
                _buildQuantitySelector(isDark),
                
                const SizedBox(height: 48),
                AppButton(
                  text: 'Add to Cart',
                  isLoading: isAdding,
                  onPressed: _selectedAmount != null ? _handleAddToCart : null,
                ).animate(target: _selectedAmount != null ? 1 : 0.8).scale(duration: 200.ms),
                
                const SizedBox(height: 48),
                const Divider(),
                const SizedBox(height: 32),
                
                if (p.redemptionDetails?.isNotEmpty == true) ...[
                  _buildSectionTitle(context, 'Redemption Instructions'),
                  const SizedBox(height: 12),
                  ...p.redemptionDetails!.map((r) => _buildInstructionRow(context, r)),
                ],
                
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Terms & Conditions'),
                const SizedBox(height: 12),
                _buildTerms(),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SuregiftsProductResponse p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            p.name ?? '',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            p.currency ?? '',
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context, SuregiftsProductResponse p) {
    return Text(
      p.categories?.join(' • ') ?? '',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
    );
  }

  Widget _buildDescription(BuildContext context, SuregiftsProductResponse p) {
    return Text(
      p.description ?? 'No description available.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
    );
  }

  Widget _buildAmountChips(BuildContext context, bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _availableAmounts.map((d) {
        final isSelected = _selectedAmount == d;
        return InkWell(
          onTap: () => setState(() => _selectedAmount = d),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : (isDark ? const Color(0xFF25262B) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : (isDark ? Colors.transparent : Colors.grey[300]!),
              ),
            ),
            child: Text(
              CurrencyFormatter.format(d),
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoAmountsMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'No valid amounts available for this product.',
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildQuantitySelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF25262B) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _quantity.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _quantity++),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(BuildContext context, String r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(r, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildTerms() {
    return const Text(
      '• Valid for 12 months from date of purchase.\n'
      '• Cannot be exchanged for cash.\n'
      '• Can be used multiple times until balance is zero.\n'
      '• Subject to SureGifts global terms of service.',
      style: TextStyle(height: 1.6, color: Colors.grey),
    );
  }
}
