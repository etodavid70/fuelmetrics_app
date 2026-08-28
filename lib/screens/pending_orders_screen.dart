import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  final Set<String> _retrying = {};

  Future<void> _retry(SalesOrder order) async {
    setState(() => _retrying.add(order.id));
    final appState = context.read<AppState>();
    final success = await appState.retryOrder(order);
    if (!mounted) return;
    setState(() => _retrying.remove(order.id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? AppTheme.success : AppTheme.danger,
        content: Text(success ? 'Order for ${order.customerName} submitted.' : 'Still failing: ${order.lastError}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final orders = appState.pendingOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
        actions: [
          if (orders.isNotEmpty)
            TextButton.icon(
              onPressed: () async {
                for (final o in List<SalesOrder>.from(orders)) {
                  await _retry(o);
                }
              },
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Retry all'),
            ),
        ],
      ),
      body: orders.isEmpty
          ? const EmptyState(
              icon: Icons.check_circle_outline,
              title: 'Nothing pending',
              subtitle: 'Orders saved while offline will show up here for retry.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final order = orders[i];
                final isRetrying = _retrying.contains(order.id);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                            ),
                            const StatusBadge(label: 'Pending', color: AppTheme.warning, icon: Icons.schedule),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM d, y • h:mm a').format(order.createdAt),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${order.itemCount} item${order.itemCount == 1 ? '' : 's'} • ${formatNaira(order.total)}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                        if (order.lastError != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.danger.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              order.lastError!,
                              style: const TextStyle(color: AppTheme.danger, fontSize: 12),
                            ),
                          ),
                        ],
                        if (order.retryCount > 0) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Retry attempts: ${order.retryCount}',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => appState.discardPendingOrder(order.id),
                                icon: const Icon(Icons.delete_outline, size: 18),
                                label: const Text('Discard'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isRetrying ? null : () => _retry(order),
                                icon: isRetrying
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(Icons.sync, size: 18),
                                label: Text(isRetrying ? 'Retrying...' : 'Retry'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
