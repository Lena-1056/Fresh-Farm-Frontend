import 'package:flutter/material.dart';
import '../models/cart_api_model.dart';
import '../models/order_api_model.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartApiModel> _items = [];
  bool _loading = false;
  String? _error;

  List<CartApiModel> get items => _items;
  bool get loading => _loading;
  String? get error => _error;
  int get count => _items.fold(0, (sum, e) => sum + e.quantity);
  double get total => _items.fold(0.0, (sum, e) => sum + e.subtotal);

  Future<void> fetchCart() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await ApiService.getMyCart();
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    _error = null;
    try {
      await ApiService.addToCart(productId, quantity: quantity);
      await fetchCart();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeFromCart(int cartId) async {
    _error = null;
    try {
      await ApiService.removeFromCart(cartId);
      _items.removeWhere((e) => e.id == cartId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<List<OrderApiModel>> placeOrder() async {
    if (_items.isEmpty) throw Exception('Cart is empty');
    final ids = _items.map((e) => e.id).toList();
    final orders = await ApiService.placeOrder(ids);
    await fetchCart();
    return orders;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
