import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/role_selection_screen.dart';

import '../screens/farmer/farmer_dashboard.dart';
import '../screens/farmer/add_product_screen.dart';
import '../screens/farmer/farmer_orders_screen.dart';

import '../screens/buyer/buyer_dashboard.dart';
import '../screens/buyer/product_detail_screen.dart';
import '../screens/buyer/cart_screen.dart';
import '../screens/buyer/order_tracking_screen.dart';

import '../screens/admin/admin_dashboard.dart';

class AppRoutes {
  // Auth
  static const splash = "/";
  static const onboarding = "/onboarding";
  static const login = "/login";
  static const signup = "/signup";
  static const role = "/role";

  // Farmer
  static const farmerDashboard = "/farmerDashboard";
  static const addProduct = "/addProduct";
  static const farmerOrders = "/farmerOrders";

  // Buyer
  static const buyerDashboard = "/buyerDashboard";
  static const productDetail = "/productDetail";
  static const cart = "/cart";
  static const tracking = "/tracking";

  // Admin
  static const adminDashboard = "/adminDashboard";

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    role: (_) => const RoleSelectionScreen(),

    // Farmer
    farmerDashboard: (_) => const FarmerDashboard(),
    addProduct: (_) => const AddProductScreen(),
    farmerOrders: (_) => const FarmerOrdersScreen(),

    // Buyer
    buyerDashboard: (_) => const BuyerDashboard(),
    productDetail: (_) => const ProductDetailScreen(),
    cart: (_) => const CartScreen(),
    tracking: (_) => const OrderTrackingScreen(),

    // Admin
    adminDashboard: (_) => const AdminDashboard(),
  };
}
