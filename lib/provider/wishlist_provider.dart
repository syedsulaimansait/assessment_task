import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<dynamic> _items = [];

  List get items => _items;

  bool isInWishlist(product) {
    return _items.any((e) => e.id == product.id);
  }

  void toggleWishlist(product) {
    if (isInWishlist(product)) {
      _items.removeWhere((e) => e.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}
