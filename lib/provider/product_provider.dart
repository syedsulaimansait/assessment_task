import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Product> _products = [];
  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.fetchProducts();
    } catch (e) {
      print("Error fetching products: $e");
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }
}
