import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/farmer_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    await auth.loadStoredAuth();
    if (!mounted) return;
      if (auth.isLoggedIn && auth.userRole != null) {
      switch (auth.userRole!) {
        case 'FARMER':
          context.read<FarmerProvider>().initializeFromAuth(
            name: auth.userName ?? '',
            email: auth.userEmail ?? '',
          );
          Navigator.pushReplacementNamed(context, AppRoutes.farmerDashboard);
          break;
        case 'BUYER':
          Navigator.pushReplacementNamed(context, AppRoutes.buyerDashboard);
          break;
        case 'ADMIN':
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
          break;
        default:
          Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Fresh Farm 🌾",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
