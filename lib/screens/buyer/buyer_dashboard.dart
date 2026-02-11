import 'package:flutter/material.dart';
import '../../core/routes.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fresh Farm"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search fresh products...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Product List
            Expanded(
              child: ListView(
                children: [
                  productCard(
                    context,
                    "Fresh Tomatoes",
                    "₹40/kg",
                  ),
                  productCard(
                    context,
                    "Organic Carrots",
                    "₹50/kg",
                  ),
                  productCard(
                    context,
                    "Green Spinach",
                    "₹30/bundle",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productCard(BuildContext context, String title, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: const Icon(Icons.agriculture, size: 40, color: Colors.green),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.productDetail);
        },
      ),
    );
  }
}
