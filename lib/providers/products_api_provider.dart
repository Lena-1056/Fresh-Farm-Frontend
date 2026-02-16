import 'package:flutter/material.dart';
import '../models/product_api_model.dart';
import '../services/api_service.dart';

class ProductsApiProvider extends ChangeNotifier {
  List<ProductApiModel> _products = [];
  bool _loading = false;
  String? _error;

  List<ProductApiModel> get products => _products;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchAllProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await ApiService.getAllProducts();
    } catch (e) {
      _error = e.toString();
      _products = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFarmerProducts(int farmerId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await ApiService.getProductsByFarmer(farmerId);
    } catch (e) {
      _error = e.toString();
      _products = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // DISCOUNT --------------
  Future<void> updateProduct(ProductApiModel product) async {
    _error = null;
    try {
      final updated = await ApiService.updateProduct(product.id, product);

      final index = _products.indexWhere((element) => element.id == product.id);

      if (index != -1) {
        _products[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addProduct(ProductApiModel product) async {
    _error = null;
    try {
      await ApiService.addProduct(product);
      await fetchAllProducts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(int productId) async {
    _error = null;
    try {
      await ApiService.deleteProduct(productId);
      _products.removeWhere((e) => e.id == productId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
