import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../models/product_api_model.dart';
import '../../providers/products_api_provider.dart';
import 'product_detail_screen.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  String role = "buyer";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsApiProvider>().fetchAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildRoleSwitch("buyer", "Buyer", Icons.shopping_basket),
                      const SizedBox(width: 20),
                      buildRoleSwitch("farmer", "Farmer", Icons.agriculture),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good Morning", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text("Fresh Explorer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search fresh produce...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Freshly Picked",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Consumer<ProductsApiProvider>(
                    builder: (context, provider, _) {
                      if (provider.loading && provider.products.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
                      }
                      if (provider.error != null && provider.products.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
                        );
                      }
                      if (provider.products.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("No products yet"),
                        );
                      }
                      return Column(
                        children: provider.products
                            .map((p) => productRow(context, p))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
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
                  children: [
                    BottomNavItem(Icons.home, "Home", true),
                    BottomNavItem(Icons.explore, "Explore", false),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                      child: BottomNavItem(Icons.shopping_cart, "Cart", false),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.tracking),
                      child: BottomNavItem(Icons.receipt_long, "Orders", false),
                    ),
                    BottomNavItem(Icons.person, "Profile", false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoleSwitch(String value, String label, IconData icon) {
    final bool isSelected = role == value;
    return GestureDetector(
      onTap: () {
        if (value == "farmer") {
          Navigator.pushReplacementNamed(context, AppRoutes.farmerDashboard);
        } else {
          setState(() => role = "buyer");
        }
      },
      child: Row(
        children: [
          Icon(icon, size: 20, color: isSelected ? const Color(0xFF0DF20D) : Colors.grey),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF0DF20D) : Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF0DF20D) : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Center(child: CircleAvatar(radius: 5, backgroundColor: Color(0xFF0DF20D)))
                : null,
          ),
        ],
      ),
    );
  }

  Widget productRow(BuildContext context, ProductApiModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(product.imageUrl!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.agriculture, color: Color(0xFF0DF20D), size: 35),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "₹${product.price.toStringAsFixed(0)}/unit",
                    style: const TextStyle(color: Color(0xFF0DF20D), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.add_circle, color: Color(0xFF0DF20D)),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNavItem(this.icon, this.label, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? const Color(0xFF0DF20D) : Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: active ? const Color(0xFF0DF20D) : Colors.grey),
        ),
      ],
    );
  }
}
