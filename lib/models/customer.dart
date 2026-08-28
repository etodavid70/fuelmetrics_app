class Customer {
  final String id;
  final String name;
  final String location;
  final String phone;
  final double outstandingBalance;

  const Customer({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.outstandingBalance,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}
