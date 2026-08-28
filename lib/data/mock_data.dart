import '../models/customer.dart';
import '../models/product.dart';

class MockData {
  static const List<Customer> customers = [
    Customer(
      id: 'c1',
      name: 'Eto David',
      location: 'Garki, Abuja',
      phone: '+234 803 111 2233',
      outstandingBalance: 45000,
    ),
    Customer(
      id: 'c2',
      name: 'Eto Samuel',
      location: 'Wuse II, Abuja',
      phone: '+234 806 222 3344',
      outstandingBalance: 0,
    ),
    Customer(
      id: 'c3',
      name: 'Aisha Musa',
      location: 'Maitama, Abuja',
      phone: '+234 809 333 4455',
      outstandingBalance: 128500,
    ),
    Customer(
      id: 'c4',
      name: 'Fatima Bello',
      location: 'Kubwa, Abuja',
      phone: '+234 812 444 5566',
      outstandingBalance: 9800,
    ),
    Customer(
      id: 'c5',
      name: 'Emeka Nwosu',
      location: 'Jabi, Abuja',
      phone: '+234 815 555 6677',
      outstandingBalance: 0,
    ),
    Customer(
      id: 'c6',
      name: 'Grace Danjuma',
      location: 'Asokoro, Abuja',
      phone: '+234 818 666 7788',
      outstandingBalance: 62000,
    ),
    Customer(
      id: 'c7',
      name: 'Tunde Adeyemi',
      location: 'Life Camp, Abuja',
      phone: '+234 821 777 8899',
      outstandingBalance: 15300,
    ),
    Customer(
      id: 'c8',
      name: 'Blessing Okon',
      location: 'Gwarinpa, Abuja',
      phone: '+234 803 888 9900',
      outstandingBalance: 0,
    ),
  ];

  static const List<Product> products = [
    Product(id: 'p1', name: 'Premium Rice 50kg', category: 'Grains', price: 45000, availableQty: 32),
    Product(id: 'p2', name: 'Vegetable Oil 25L', category: 'Cooking', price: 38000, availableQty: 18),
    Product(id: 'p3', name: 'Granulated Sugar 50kg', category: 'Grains', price: 41000, availableQty: 25),
    Product(id: 'p4', name: 'Spaghetti (Carton)', category: 'Pasta', price: 12500, availableQty: 60),
    Product(id: 'p5', name: 'Tomato Paste (Carton)', category: 'Canned', price: 15800, availableQty: 40),
    Product(id: 'p6', name: 'Powdered Milk 400g (Carton)', category: 'Dairy', price: 28500, availableQty: 22),
    Product(id: 'p7', name: 'Detergent Powder 1kg (Carton)', category: 'Household', price: 19500, availableQty: 15),
    Product(id: 'p8', name: 'Bottled Water 75cl (Pack)', category: 'Beverages', price: 1800, availableQty: 120),
    Product(id: 'p9', name: 'Seasoning Cubes (Carton)', category: 'Seasoning', price: 9500, availableQty: 50),
    Product(id: 'p10', name: 'Instant Noodles (Carton)', category: 'Pasta', price: 8200, availableQty: 0),
    Product(id: 'p11', name: 'Margarine 500g (Carton)', category: 'Dairy', price: 21000, availableQty: 12),
    Product(id: 'p12', name: 'Toilet Tissue (Bale)', category: 'Household', price: 13500, availableQty: 30),
  ];
}
