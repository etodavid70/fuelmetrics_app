import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customer.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'create_order_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;
  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final hasBalance = customer.outstandingBalance > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppTheme.seed.withOpacity(0.12),
                    child: Text(
                      customer.initials,
                      style: const TextStyle(color: AppTheme.seed, fontWeight: FontWeight.w800, fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
                  const SizedBox(height: 4),
                  Text(customer.location, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: customer.phone),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: customer.location),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text('Outstanding balance', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      StatusBadge(
                        label: hasBalance ? formatNaira(customer.outstandingBalance) : 'Settled',
                        color: hasBalance ? AppTheme.warning : AppTheme.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AppState>().startOrder(customer);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CreateOrderScreen(customer: customer)),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Create New Order'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${customer.phone}...')),
              );
            },
            icon: const Icon(Icons.call_outlined),
            label: const Text('Call Customer'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(value, style: TextStyle(color: Colors.grey.shade800)),
      ],
    );
  }
}
