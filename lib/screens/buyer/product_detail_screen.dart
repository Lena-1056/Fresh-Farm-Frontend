import 'package:flutter/material.dart';
import '../../core/routes.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: Colors.green.shade100,
              child: const Center(child: Icon(Icons.agriculture, size: 80)),
            ),
            const SizedBox(height: 20),
            const Text("Fresh Tomatoes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("₹40/kg"),
            const SizedBox(height: 20),
            const Text(
                "Organic farm fresh tomatoes directly from local farmer."),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              child: const Text("Add to Cart"),
            )
          ],
        ),
      ),
    );
  }
}
