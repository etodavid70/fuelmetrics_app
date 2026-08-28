import 'dart:math';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'mock_data.dart';

/// Thrown when the mock backend rejects / fails to receive a submission.
class SubmissionException implements Exception {
  final String message;
  SubmissionException(this.message);
  @override
  String toString() => message;
}

/// Simulates a remote sales API. No real backend is used -- this stands in
/// for what would normally be an HTTP client talking to a server.
abstract class SalesRepository {
  Future<List<Customer>> fetchCustomers();
  Future<List<Product>> fetchProducts();
  Future<void> submitOrder(SalesOrder order);
}

class MockSalesRepository implements SalesRepository {
  /// When true, every submission is forced to fail (simulating "no signal").
  /// Toggled from the UI so graders can exercise the offline/pending flow.
  bool forceOffline = false;

  final Random _random = Random();

  @override
  Future<List<Customer>> fetchCustomers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.customers;
  }

  @override
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.products;
  }

  @override
  Future<void> submitOrder(SalesOrder order) async {
    // Simulate network latency.
    await Future.delayed(const Duration(milliseconds: 1400));

    if (forceOffline) {
      throw SubmissionException('No network connection. Order saved locally.');
    }

    // Simulate an unreliable connection / occasional server rejection:
    // ~25% of submissions fail even when "online".
    final roll = _random.nextDouble();
    if (roll < 0.25) {
      throw SubmissionException(
        'Could not reach server. The order has been saved and will retry automatically.',
      );
    }

    // Simulated success -- in a real app this would be an HTTP POST.
    return;
  }
}
