enum OrderStatus { submitted, pendingSync }

class OrderLineItem {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  const OrderLineItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  double get lineTotal => unitPrice * quantity;

  OrderLineItem copyWith({int? quantity}) => OrderLineItem(
        productId: productId,
        productName: productName,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };

  factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        quantity: json['quantity'] as int,
      );
}

class SalesOrder {
  final String id;
  final String customerId;
  final String customerName;
  final List<OrderLineItem> items;
  final DateTime createdAt;
  OrderStatus status;
  String? lastError;
  int retryCount;

  SalesOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.createdAt,
    this.status = OrderStatus.pendingSync,
    this.lastError,
    this.retryCount = 0,
  });

  double get total => items.fold(0.0, (sum, i) => sum + i.lineTotal);
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'customerName': customerName,
        'items': items.map((i) => i.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'lastError': lastError,
        'retryCount': retryCount,
      };

  factory SalesOrder.fromJson(Map<String, dynamic> json) => SalesOrder(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        items: (json['items'] as List)
            .map((i) => OrderLineItem.fromJson(i as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: OrderStatus.values.firstWhere((s) => s.name == json['status']),
        lastError: json['lastError'] as String?,
        retryCount: json['retryCount'] as int? ?? 0,
      );
}
