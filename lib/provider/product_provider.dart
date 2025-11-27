import 'package:flutter/material.dart';

import '../model/product_model.dart';

class ProductProvider with ChangeNotifier{
   bool _isLoading = false;
  late List<Product> _products = [];
  List<Product> get products => _products;
   bool get isLoading => _isLoading;

  void setProducts(List<Product> products){
    _products = products;
    notifyListeners();
  }
}