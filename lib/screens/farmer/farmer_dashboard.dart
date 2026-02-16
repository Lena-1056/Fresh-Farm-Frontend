import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../models/product_api_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farmer_provider.dart';
import '../../providers/products_api_provider.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int selectedIndex = 0;
  String role = "farmer";

  final Color primaryColor = const Color(0xFF0DF20D);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      if (userId != null) {
        context.read<ProductsApiProvider>().fetchFarmerProducts(
          int.parse(userId),
        );
      }
    });
  }

  void _onNavTap(int index) {
    if (index == 0) return;
    if (index == 1) Navigator.pushNamed(context, AppRoutes.farmerOrders);
    if (index == 2) Navigator.pushNamed(context, AppRoutes.farmerInventory);
    if (index == 3) Navigator.pushNamed(context, AppRoutes.farmerProfile);
  }

  @override
  Widget build(BuildContext context) {
    selectedIndex = 0;
    final farmerName = context.watch<FarmerProvider>().farmer.ownerName;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () async {
            await Navigator.pushNamed(context, AppRoutes.addProduct);
            if (!context.mounted) return;
            final userId = context.read<AuthProvider>().userId;
            if (userId != null) {
              context.read<ProductsApiProvider>().fetchFarmerProducts(
                int.parse(userId),
              );
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
            Text(
              farmerName.isEmpty ? "Farmer" : farmerName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Consumer<ProductsApiProvider>(
              builder: (context, provider, child) {
                final products = provider.products;
                return Row(
                  children: [
                    Expanded(
                      child: _statCard("Products", products.length.toString()),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard("Active", products.length.toString()),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 25),
            const Text(
              "My Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Consumer<ProductsApiProvider>(
              builder: (context, provider, child) {
                if (provider.loading && provider.products.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (provider.products.isEmpty) {
                  return const Text(
                    "No products yet. Add one using the + button.",
                  );
                }
                return Column(
                  children: provider.products
                      .map((product) => _productCard(product))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(ProductApiModel product) {
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
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? Image.network(product.imageUrl!, fit: BoxFit.cover)
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
                  // Text(
                  //   "₹${product.price.toStringAsFixed(0)} • Qty: ${product.quantity}",
                  //   style: const TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  if (product.discount != null && product.discount! > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "-${product.discount!.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "₹${product.discountedPrice!.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "M.R.P ₹${product.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      "₹${product.price.toStringAsFixed(0)} • Qty: ${product.quantity}",
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

  Widget _buildBottomNav() {
    return Container(
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
