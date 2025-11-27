import 'package:flutter/foundation.dart';

import '../model/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
  double get subtotal => product.price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get itemCount => _items.values.fold(0, (s, it) => s + it.quantity);
  double get totalPrice => _items.values.fold(0.0, (s, it) => s + it.subtotal);

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void changeQuantity(int productId, int delta) {
    if (!_items.containsKey(productId)) return;
    _items[productId]!.quantity += delta;
    if (_items[productId]!.quantity <= 0) _items.remove(productId);
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
