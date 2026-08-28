import 'dart:math';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'mock_data.dart';

///eto david: Exception is thrown when the mock API rejects or fails to receive a submission.
class SubmissionException implements Exception {
  final String message;
  SubmissionException(this.message);
  @override
  String toString() => message;
}

/// eto david: this simulates a remote sales API. No real backend is used as instructed
abstract class SalesRepository {
  Future<List<Customer>> fetchCustomers();
  Future<List<Product>> fetchProducts();
  Future<void> submitOrder(SalesOrder order);
}

class MockSalesRepository implements SalesRepository {
  
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

    // eto david: this simulate an unreliable connection / occasional server rejection:
    final roll = _random.nextDouble();
    if (roll < 0.25) {
      throw SubmissionException(
        'Could not reach server. The order has been saved and will retry automatically.',
      );
    }
    return;
  }
}
