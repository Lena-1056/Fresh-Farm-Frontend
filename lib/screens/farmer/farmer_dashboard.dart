import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  String role = "farmer";
  int selectedIndex = 0;

  final Color primaryColor = const Color(0xFF0DF20D);

  void _onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.farmerOrders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),

      /// FLOATING ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      /// BOTTOM NAVIGATION (No Hover)
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(icon: Icons.dashboard, label: "Dashboard", index: 0),
            _bottomNavItem(icon: Icons.receipt_long, label: "Orders", index: 1),
            _bottomNavItem(icon: Icons.storefront, label: "Market", index: 2),
            _bottomNavItem(icon: Icons.settings, label: "Settings", index: 3),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// ROLE SWITCH
            Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _roleIconButton(value: "farmer", icon: Icons.agriculture),
                    const SizedBox(width: 10),
                    _roleIconButton(value: "buyer", icon: Icons.shopping_bag),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Farmer Joe",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications),
              ],
            ),

            const SizedBox(height: 25),

            /// STATS
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "Products",
                        provider.products.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        "Active",
                        provider.products.length.toString(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ROLE BUTTON (No Hover)
  Widget _roleIconButton({required String value, required IconData icon}) {
    final bool isSelected = role == value;

    return GestureDetector(
      onTap: () {
        if (value == "buyer") {
          Navigator.pushReplacementNamed(context, AppRoutes.buyerDashboard);
        } else {
          setState(() {
            role = "farmer";
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Icon(icon, color: isSelected ? primaryColor : Colors.grey),
      ),
    );
  }

  /// STATS CARD
  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// SIMPLE BOTTOM NAV ITEM (No Hover Widget)
  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: isActive ? primaryColor : Colors.grey),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  String role = "farmer";
  int selectedIndex = 0;

  final Color primaryColor = const Color(0xFF0DF20D);

  void _onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.farmerOrders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),

      /// FLOATING ADD BUTTON WITH CURSOR
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addProduct);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(icon: Icons.dashboard, label: "Dashboard", index: 0),
            _bottomNavItem(icon: Icons.receipt_long, label: "Orders", index: 1),
            _bottomNavItem(icon: Icons.storefront, label: "Market", index: 2),
            _bottomNavItem(icon: Icons.settings, label: "Settings", index: 3),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// ROLE SWITCH
            Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _roleIconButton(value: "farmer", icon: Icons.agriculture),
                    const SizedBox(width: 10),
                    _roleIconButton(value: "buyer", icon: Icons.shopping_bag),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Farmer Joe",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications),
              ],
            ),

            const SizedBox(height: 25),

            /// STATS
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "Products",
                        provider.products.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        "Active",
                        provider.products.length.toString(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ROLE BUTTON WITH CURSOR ONLY
  Widget _roleIconButton({required String value, required IconData icon}) {
    final bool isSelected = role == value;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (value == "buyer") {
            Navigator.pushReplacementNamed(context, AppRoutes.buyerDashboard);
          } else {
            setState(() {
              role = "farmer";
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
          child: Icon(icon, color: isSelected ? primaryColor : Colors.grey),
        ),
      ),
    );
  }

  /// STATS CARD
  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// BOTTOM NAV ITEM WITH CURSOR ONLY (No Hover Effect)
  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = selectedIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onNavTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: isActive ? primaryColor : Colors.grey),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
