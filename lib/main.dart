import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/theme.dart';

void main() {
  runApp(const FreshFarmApp());
}

class FreshFarmApp extends StatelessWidget {
  const FreshFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
