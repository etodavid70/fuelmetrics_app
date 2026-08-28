import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../data/repository.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/product.dart';

const _pendingOrdersKey = 'pending_orders_v1';
const _uuid = Uuid();

class AppState extends ChangeNotifier {
  AppState({SalesRepository? repository}) : repository = repository ?? MockSalesRepository();

  final SalesRepository repository;

  List<Customer> customers = [];
  List<Product> products = [];
  List<SalesOrder> pendingOrders = [];

  bool isLoading = true;

  /// Cart is keyed by productId so each product appears once with a quantity.
  final Map<String, OrderLineItem> _cart = {};
  Customer? cartCustomer;

  bool get simulateOffline =>
      repository is MockSalesRepository && (repository as MockSalesRepository).forceOffline;

  set simulateOffline(bool value) {
    if (repository is MockSalesRepository) {
      (repository as MockSalesRepository).forceOffline = value;
      notifyListeners();
    }
  }

  List<OrderLineItem> get cartItems => _cart.values.toList();
  int get cartItemCount => _cart.values.fold(0, (sum, i) => sum + i.quantity);
  double get cartTotal => _cart.values.fold(0.0, (sum, i) => sum + i.lineTotal);

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      repository.fetchCustomers(),
      repository.fetchProducts(),
    ]);
    customers = results[0] as List<Customer>;
    products = results[1] as List<Product>;

    await _loadPendingOrders();

    isLoading = false;
    notifyListeners();
  }

  // ---------------- Cart management ----------------

  void startOrder(Customer customer) {
    cartCustomer = customer;
    _cart.clear();
  }

  int quantityInCart(String productId) => _cart[productId]?.quantity ?? 0;

  void addToCart(Product product, {int quantity = 1}) {
    final existing = _cart[product.id];
    final newQty = (existing?.quantity ?? 0) + quantity;
    if (newQty > product.availableQty || newQty < 0) return;
    if (newQty == 0) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = OrderLineItem(
        productId: product.id,
        productName: product.name,
        unitPrice: product.price,
        quantity: newQty,
      );
    }
    notifyListeners();
  }

  void setQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      _cart.remove(product.id);
    } else {
      final capped = quantity > product.availableQty ? product.availableQty : quantity;
      _cart[product.id] = OrderLineItem(
        productId: product.id,
        productName: product.name,
        unitPrice: product.price,
        quantity: capped,
      );
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    cartCustomer = null;
  }

  // ---------------- Order submission ----------------

  /// Attempts to submit the current cart as an order for [cartCustomer].
  /// On failure, the order is persisted locally as "pendingSync".
  /// Returns true if the order reached the server successfully.
  Future<bool> submitCurrentOrder() async {
    if (cartCustomer == null || _cart.isEmpty) return false;

    final order = SalesOrder(
      id: _uuid.v4(),
      customerId: cartCustomer!.id,
      customerName: cartCustomer!.name,
      items: cartItems,
      createdAt: DateTime.now(),
    );

    final success = await _trySubmit(order);
    clearCart();
    notifyListeners();
    return success;
  }

  /// Retries an already-pending order. Returns true if it now succeeded.
  Future<bool> retryOrder(SalesOrder order) async {
    final success = await _trySubmit(order, isRetry: true);
    notifyListeners();
    return success;
  }

  Future<bool> _trySubmit(SalesOrder order, {bool isRetry = false}) async {
    try {
      await repository.submitOrder(order);
      order.status = OrderStatus.submitted;
      order.lastError = null;
      if (isRetry) {
        pendingOrders.removeWhere((o) => o.id == order.id);
        await _savePendingOrders();
      }
      return true;
    } on SubmissionException catch (e) {
      order.status = OrderStatus.pendingSync;
      order.lastError = e.message;
      order.retryCount += 1;
      if (!pendingOrders.any((o) => o.id == order.id)) {
        pendingOrders.insert(0, order);
      }
      await _savePendingOrders();
      return false;
    } catch (e) {
      order.status = OrderStatus.pendingSync;
      order.lastError = 'Unexpected error: $e';
      order.retryCount += 1;
      if (!pendingOrders.any((o) => o.id == order.id)) {
        pendingOrders.insert(0, order);
      }
      await _savePendingOrders();
      return false;
    }
  }

  void discardPendingOrder(String orderId) {
    pendingOrders.removeWhere((o) => o.id == orderId);
    _savePendingOrders();
    notifyListeners();
  }

  // ---------------- Local persistence ----------------

  Future<void> _loadPendingOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pendingOrdersKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List;
      pendingOrders = list
          .map((e) => SalesOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      pendingOrders = [];
    }
  }

  Future<void> _savePendingOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(pendingOrders.map((o) => o.toJson()).toList());
    await prefs.setString(_pendingOrdersKey, raw);
  }
}
