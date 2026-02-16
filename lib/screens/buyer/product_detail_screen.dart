import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_api_model.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductApiModel? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Product Details")),
        body: const Center(child: Text("Select a product from the list.")),
      );
    }

    final p = product!;

    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: p.imageUrl != null && p.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        p.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : const Center(child: Icon(Icons.agriculture, size: 80)),
            ),
            const SizedBox(height: 20),
            Text(
              p.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            // Text("₹${p.price.toStringAsFixed(2)}"),
            if (p.discount != null && p.discount! > 0) ...[
              Row(
                children: [
                  Text(
                    "-${p.discount!.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "₹${p.discountedPrice!.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "M.R.P ₹${p.price.toStringAsFixed(0)}",
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ] else
              Text(
                "₹${p.price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 20),
            Text(p.description.isNotEmpty ? p.description : "No description."),
            const Spacer(),
            Consumer<CartProvider>(
              builder: (context, cart, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0DF20D),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      try {
                        await cart.addToCart(p.id); // ✅ Directly use id

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to cart")),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error: ${e.toString().replaceFirst('Exception: ', '')}",
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Add to Cart"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
