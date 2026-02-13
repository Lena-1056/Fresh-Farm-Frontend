import 'package:flutter/material.dart';

/// 🔹 Auth Screens
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/role_selection_screen.dart';

/// 🔹 Farmer Screens
import '../screens/farmer/farmer_main_screen.dart';
import '../screens/farmer/farmer_dashboard.dart';
import '../screens/farmer/add_product_screen.dart';
import '../screens/farmer/farmer_orders_screen.dart';

/// 🔹 Buyer Screens
import '../screens/buyer/buyer_main_screen.dart';
import '../screens/buyer/buyer_dashboard.dart';
import '../screens/buyer/product_detail_screen.dart';
import '../screens/buyer/cart_screen.dart';
import '../screens/buyer/order_tracking_screen.dart';

/// 🔹 Admin Screen
import '../screens/admin/admin_dashboard.dart';

class AppRoutes {

  // =========================
  // 🔹 AUTH ROUTES
  // =========================
  static const splash = "/";
  static const onboarding = "/onboarding";
  static const login = "/login";
  static const signup = "/signup";
  static const role = "/role";

  // =========================
  // 🔹 MAIN ROLE WRAPPERS
  // =========================
  static const buyerMain = "/buyerMain";
  static const farmerMain = "/farmerMain";

  // =========================
  // 🔹 FARMER ROUTES
  // =========================
  static const farmerDashboard = "/farmerDashboard";
  static const addProduct = "/addProduct";
  static const farmerOrders = "/farmerOrders";

  // =========================
  // 🔹 BUYER ROUTES
  // =========================
  static const buyerDashboard = "/buyerDashboard";
  static const productDetail = "/productDetail";
  static const cart = "/cart";
  static const tracking = "/tracking";

  // =========================
  // 🔹 ADMIN ROUTE
  // =========================
  static const adminDashboard = "/adminDashboard";

  // =========================
  // 🔹 ROUTES MAP
  // =========================
  static Map<String, WidgetBuilder> routes = {

    // Auth
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    role: (_) => const RoleSelectionScreen(),

    // Main Wrapper Screens (IMPORTANT)
    buyerMain: (_) => const BuyerMainScreen(),
    farmerMain: (_) => const FarmerMainScreen(),

    // Farmer Screens (if opened separately)
    farmerDashboard: (_) => const FarmerDashboard(),
    addProduct: (_) => const AddProductScreen(),
    farmerOrders: (_) => const FarmerOrdersScreen(),

    // Buyer Screens (if opened separately)
    buyerDashboard: (_) => const BuyerDashboard(),
    productDetail: (_) => const ProductDetailScreen(),
    cart: (_) => const CartScreen(),
    tracking: (_) => const OrderTrackingScreen(),

    // Admin
    adminDashboard: (_) => const AdminDashboard(),
  };
}
