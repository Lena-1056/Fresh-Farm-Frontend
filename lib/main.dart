import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes.dart';
import 'core/theme.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const FreshFarmApp(),
    ),
  );
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
