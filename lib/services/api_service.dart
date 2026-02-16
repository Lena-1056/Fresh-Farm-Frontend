import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/auth_response.dart';
import '../models/cart_api_model.dart';
import '../models/profile_response.dart';
import '../models/order_api_model.dart';
import '../models/product_api_model.dart';
import 'auth_storage_service.dart';

class ApiService {
  /// Use baseUrl for Android emulator (10.0.2.2). Use baseUrlLocal for Chrome/desktop.
  static const String baseUrl = "http://10.0.2.2:8080/api";
  static const String baseUrlLocal = "http://localhost:8080/api";

  static String get apiBase => baseUrlLocal;

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthStorageService.getToken();
    return {
      "Content-Type": "application/json",
      if (token?.isNotEmpty ?? false) "Authorization": "Bearer $token",
    };
  }

  // --------------- AUTH ---------------
  static Future<AuthResponse> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse("$apiBase/auth/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        if (phone != null) "phone": phone,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final err = jsonDecode(response.body);
    throw Exception(err["error"] ?? response.body);
  }

  static Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$apiBase/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final body = response.body;
    try {
      final err = jsonDecode(body);
      throw Exception(err["error"] ?? body);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(body);
    }
  }

  // --------------- PROFILE ---------------
  static Future<ProfileResponse> getProfile() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse("$apiBase/users/me"),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception(response.body);
    return ProfileResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  static Future<ProfileResponse> updateProfile(
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders();
    final response = await http.put(
      Uri.parse("$apiBase/users/me"),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) throw Exception(response.body);
    return ProfileResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // --------------- PRODUCTS ---------------
  static Future<List<ProductApiModel>> getAllProducts() async {
    final response = await http.get(Uri.parse("$apiBase/products/all"));
    if (response.statusCode != 200) throw Exception(response.body);
    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => ProductApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<ProductApiModel>> getProductsByFarmer(int farmerId) async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse("$apiBase/products/farmer/$farmerId"),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => ProductApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<ProductApiModel> addProduct(ProductApiModel product) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse("$apiBase/products/add"),
      headers: headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body.trim();
      if (body.isEmpty) {
        throw Exception(
          "Server returned empty response. Check if you are logged in as a farmer.",
        );
      }
      try {
        return ProductApiModel.fromJson(
          jsonDecode(body) as Map<String, dynamic>,
        );
      } catch (e) {
        throw Exception("Invalid response from server: $e");
      }
    }
    final body = response.body.trim();
    if (body.isEmpty) {
      if (response.statusCode == 401) {
        throw Exception(
          "Not logged in or session expired. Please log in again as a farmer.",
        );
      }
      throw Exception(
        "Request failed (${response.statusCode}). Please try again.",
      );
    }
    try {
      final err = jsonDecode(body) as Map<String, dynamic>?;
      throw Exception(err?["error"] ?? body);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(body);
    }
  }

  static Future<void> deleteProduct(int productId) async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse("$apiBase/products/$productId"),
      headers: headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      final body = response.body;
      try {
        final err = jsonDecode(body);
        throw Exception(err["error"] ?? body);
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception(body);
      }
    }
  }

  // static Future<ProductApiModel> updateProduct(
  //   int id,
  //   ProductApiModel product,
  // ) async {
  //   final headers = await _authHeaders();

  //   final response = await http.put(
  //     Uri.parse("$apiBase/products/update/$id"),
  //     headers: headers,
  //     body: jsonEncode(product.toJson()),
  //   );

  //   if (response.statusCode == 200) {
  //     return ProductApiModel.fromJson(
  //       jsonDecode(response.body) as Map<String, dynamic>,
  //     );
  //   }

  //   throw Exception(response.body);
  // }

  // --------------- DISCOUNT ---------------
  static Future<ProductApiModel> updateProduct(
    int id,
    ProductApiModel product,
  ) async {
    final headers = await _authHeaders();

    final response = await http.put(
      Uri.parse("$apiBase/products/update/$id"),
      headers: headers,
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return ProductApiModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    try {
      final err = jsonDecode(response.body);
      throw Exception(err["error"] ?? response.body);
    } catch (_) {
      throw Exception(response.body);
    }
  }

  // --------------- CART ---------------
  static Future<CartApiModel> addToCart(
    int productId, {
    int quantity = 1,
  }) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse("$apiBase/cart/add"),
      headers: headers,
      body: jsonEncode({"productId": productId, "quantity": quantity}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CartApiModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final err = jsonDecode(response.body);
    throw Exception(err["error"] ?? response.body);
  }

  static Future<List<CartApiModel>> getMyCart() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse("$apiBase/cart/my"),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => CartApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> removeFromCart(int cartId) async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse("$apiBase/cart/$cartId"),
      headers: headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      final err = jsonDecode(response.body);
      throw Exception(err["error"] ?? response.body);
    }
  }

  // --------------- ORDERS ---------------
  static Future<List<OrderApiModel>> placeOrder(List<int> cartItemIds) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse("$apiBase/orders/place"),
      headers: headers,
      body: jsonEncode({"cartItemIds": cartItemIds}),
    );
    if (response.statusCode != 200) {
      final err = jsonDecode(response.body);
      throw Exception(err["error"] ?? response.body);
    }
    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<OrderApiModel>> getMyOrders() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse("$apiBase/orders/my"),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<OrderApiModel> completeOrder(int orderId) async {
    final headers = await _authHeaders();
    final response = await http.put(
      Uri.parse("$apiBase/orders/$orderId/complete"),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception(response.body);
    return OrderApiModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
