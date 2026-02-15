import 'package:flutter/material.dart';
import 'package:fresh_farm/providers/farmer_provider.dart';
import 'package:provider/provider.dart';

import 'core/routes.dart';
import 'core/theme.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(const FreshFarmRoot());
}

class FreshFarmRoot extends StatelessWidget {
  const FreshFarmRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FarmerProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const FreshFarmApp(),
    );
  }
}

class FreshFarmApp extends StatelessWidget {
  const FreshFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fresh Farm",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
