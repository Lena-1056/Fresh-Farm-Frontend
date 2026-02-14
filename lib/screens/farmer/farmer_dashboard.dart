import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int selectedIndex = 0;
  String role = "farmer";

  final Color primaryColor = const Color(0xFF0DF20D);

  void _onNavTap(int index) {
    if (index == 0) return;

    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.farmerOrders);
    }

    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.farmerInventory);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always keep dashboard highlighted when this screen loads
    selectedIndex = 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),

      /// FLOATING ADD BUTTON
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
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
            _bottomNavItem(Icons.dashboard, "Dashboard", 0),
            _bottomNavItem(Icons.receipt_long, "Orders", 1),
            _bottomNavItem(Icons.inventory_2_outlined, "Inventory", 2),
            _bottomNavItem(Icons.person, "Profile", 3),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// ================= ROLE SWITCH WITH ICONS =================
            Align(
              alignment: Alignment.centerRight,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(30),
                  fillColor: primaryColor,
                  selectedColor: Colors.white,
                  color: Colors.grey,
                  isSelected: [role == "farmer", role == "buyer"],
                  onPressed: (index) {
                    if (index == 0) {
                      setState(() => role = "farmer");
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.buyerDashboard,
                      );
                    }
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Icon(Icons.agriculture, size: 18),
                          SizedBox(width: 6),
                          Text("Farmer"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Icon(Icons.shopping_bag, size: 18),
                          SizedBox(width: 6),
                          Text("Buyer"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Farmer Joe",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            /// ================= STATS =================
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
                        provider.products
                            .where((p) => p.isOnline)
                            .length
                            .toString(),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 25),

            /// ================= MY PRODUCTS =================
            const Text(
              "My Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.products.isEmpty) {
                  return const Text("No products yet");
                }

                return Column(
                  children: provider.products.map((product) {
                    return _productCard(product);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= PRODUCT CARD =================
  Widget _productCard(ProductModel product) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 60,
                width: 60,
                child: product.webImage != null
                    ? Image.memory(product.webImage!, fit: BoxFit.cover)
                    : product.imagePath != null
                    ? Image.file(File(product.imagePath!), fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${product.price.toStringAsFixed(0)} per ${product.quantityType}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _bottomNavItem(IconData icon, String label, int index) {
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
