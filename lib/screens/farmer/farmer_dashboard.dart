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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      body: SafeArea(
        child: Stack(
          children: [
            /// MAIN CONTENT
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// ROLE SWITCH
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildRoleButton("farmer", Icons.agriculture),
                          buildRoleButton("buyer", Icons.shopping_bag),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1500937386664-56d1dfef3854",
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Farmer Joe",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.notifications),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// PRODUCT STATS
                  Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: statCard(
                              "Products",
                              provider.products.length.toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: statCard(
                              "Active",
                              provider.products.length.toString(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "My Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      if (provider.products.isEmpty) {
                        return const Text(
                          "No products added yet",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      return Column(
                        children: provider.products
                            .map((product) => productCard(product))
                            .toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            /// ✅ ADD BUTTON ABOVE BOTTOM NAV
            Positioned(
              bottom: 85,
              right: 20,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.addProduct);
                  },
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0DF20D),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(blurRadius: 10, color: Colors.black26),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),

            /// BOTTOM NAV
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    BottomNav(Icons.dashboard, "Dashboard", true),
                    BottomNav(Icons.receipt_long, "Orders", false),
                    BottomNav(Icons.storefront, "Market", false),
                    BottomNav(Icons.settings, "Settings", false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoleButton(String value, IconData icon) {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFF0DF20D) : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget productCard(ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: product.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(product.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${product.quantity} ${product.quantityType} • ₹${product.price}",
                  style: const TextStyle(
                    color: Color(0xFF0DF20D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNav(this.icon, this.label, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? const Color(0xFF0DF20D) : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: active ? const Color(0xFF0DF20D) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
