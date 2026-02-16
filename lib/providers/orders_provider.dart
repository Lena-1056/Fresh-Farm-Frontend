import 'package:flutter/material.dart';
import '../models/order_api_model.dart';
import '../services/api_service.dart';

class OrdersProvider extends ChangeNotifier {
  List<OrderApiModel> _orders = [];
  bool _loading = false;
  String? _error;

  List<OrderApiModel> get orders => _orders;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchMyOrders() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _orders = await ApiService.getMyOrders();
    } catch (e) {
      _error = e.toString();
      _orders = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> completeOrder(int orderId) async {
    _error = null;
    try {
      await ApiService.completeOrder(orderId);
      await fetchMyOrders();
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
