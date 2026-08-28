import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

enum _SubmitState { idle, submitting }

class OrderReviewScreen extends StatefulWidget {
  final Customer customer;
  const OrderReviewScreen({super.key, required this.customer});

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  _SubmitState _state = _SubmitState.idle;

      


  Future<void> _submit() async {


    setState(() => _state = _SubmitState.submitting);
    final appState = context.read<AppState>();
    final success = await appState.submitCurrentOrder();
    if (!mounted) return;

    setState(() => _state = _SubmitState.idle);

    if (success) {
      await showDialog(
        context: context,
        builder: (_) => _ResultDialog(
          icon: Icons.check_circle,
          color: AppTheme.success,
          title: 'Order Submitted',
          message: 'The order was sent to the server successfully.',
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (_) => _ResultDialog(
          icon: Icons.cloud_off,
          color: AppTheme.warning,
          title: 'Saved as Pending',
          message:
              "We couldn't reach the server, so this order was saved on your device as Pending. "
              "You can retry it any time from the Pending Orders tab.",
        ),
      );
    }
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final items = appState.cartItems;
    final submitting = _state == _SubmitState.submitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Review Order')),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Go back and add some products first.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.seed.withOpacity(0.12),
                          child: Text(widget.customer.initials, style: const TextStyle(color: AppTheme.seed, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.customer.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text(widget.customer.location, style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Items (${items.length})', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.quantity} x ${formatNaira(item.unitPrice)}',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                              Text(formatNaira(item.lineTotal), style: const TextStyle(fontWeight: FontWeight.w800)),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppTheme.danger),
                                onPressed: () => appState.removeFromCart(item.productId),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 8),
                Card(
                  color: AppTheme.seed.withOpacity(0.06),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('Order Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const Spacer(),
                        Text(
                          formatNaira(appState.cartTotal),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppTheme.seed),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.seed,
                  foregroundColor: Colors.white
                ),
                  onPressed: submitting ? null : _submit,
                  child: submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                        )
                      : const Text('Submit Order'),
                ),
              ),
            ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  const _ResultDialog({required this.icon, required this.color, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700, fontSize: 13.5)),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }
}
