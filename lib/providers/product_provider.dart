import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }

  /// TOGGLE VISIBILITY
  void toggleVisibility(int index, bool value) {
    _products[index].isOnline = value;
    notifyListeners();
  }

  /// DELETE (Optional future)
  void removeProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }
}
