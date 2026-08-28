import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/customer.dart';
import '../../models/product.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'order_review_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  final Customer customer;
  const CreateOrderScreen({super.key, required this.customer});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final q = _query.trim().toLowerCase();
    final filtered = appState.products.where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order for ${widget.customer.name}', overflow: TextOverflow.ellipsis),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No products found',
                    subtitle: 'Try a different search term.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _ProductTile(product: filtered[i]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: appState.cartItemCount == 0
          ? null
          : SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1D29),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 6)),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${appState.cartItemCount} item${appState.cartItemCount == 1 ? '' : 's'}',
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          formatNaira(appState.cartTotal),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.seed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => OrderReviewScreen(customer: widget.customer)),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Review Order'),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final qty = appState.quantityInCart(product.id);
    final outOfStock = product.availableQty == 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.seed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: AppTheme.seed),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(formatNaira(product.price), style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    outOfStock ? 'Out of stock' : '${product.availableQty} available',
                    style: TextStyle(
                      color: outOfStock ? AppTheme.danger : Colors.grey.shade500,
                      fontSize: 11.5,
                      fontWeight: outOfStock ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (outOfStock)
              const SizedBox.shrink()
            else if (qty == 0)
              OutlinedButton(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                onPressed: () => appState.addToCart(product),
                child: const Text('Add'),
              )
            else
              _QuantityStepper(product: product, quantity: qty),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final Product product;
  final int quantity;
  const _QuantityStepper({required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.seed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove, size: 18),
            color: AppTheme.seed,
            onPressed: () => appState.addToCart(product, quantity: -1),
          ),
          SizedBox(
            width: 22,
            child: Text('$quantity', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 18),
            color: AppTheme.seed,
            onPressed: quantity >= product.availableQty ? null : () => appState.addToCart(product, quantity: 1),
          ),
        ],
      ),
    );
  }
}
