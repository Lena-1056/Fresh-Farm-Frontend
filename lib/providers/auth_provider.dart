import 'package:flutter/material.dart';
import '../models/auth_response.dart';
import '../services/api_service.dart';
import '../services/auth_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userRole;

  String? get token => _token;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userRole => _userRole;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<void> loadStoredAuth() async {
    _token = await AuthStorageService.getToken();
    _userId = await AuthStorageService.getUserId();
    _userName = await AuthStorageService.getUserName();
    _userEmail = await AuthStorageService.getUserEmail();
    _userRole = await AuthStorageService.getUserRole();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final res = await ApiService.login(email, password);
    await AuthStorageService.saveAuth(
      token: res.token,
      userId: res.id.toString(),
      name: res.name,
      email: res.email,
      role: res.role,
    );
    _token = res.token;
    _userId = res.id.toString();
    _userName = res.name;
    _userEmail = res.email;
    _userRole = res.role;
    notifyListeners();
  }

  Future<void> signup(AuthResponse res) async {
    await AuthStorageService.saveAuth(
      token: res.token,
      userId: res.id.toString(),
      name: res.name,
      email: res.email,
      role: res.role,
    );
    _token = res.token;
    _userId = res.id.toString();
    _userName = res.name;
    _userEmail = res.email;
    _userRole = res.role;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorageService.clearAuth();
    _token = null;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    notifyListeners();
  }
}
