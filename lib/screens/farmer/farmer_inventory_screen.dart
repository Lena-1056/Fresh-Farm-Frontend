import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../models/product_api_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/products_api_provider.dart';

class FarmerInventoryScreen extends StatefulWidget {
  const FarmerInventoryScreen({super.key});

  @override
  State<FarmerInventoryScreen> createState() => _FarmerInventoryScreenState();
}

class _FarmerInventoryScreenState extends State<FarmerInventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final userId = auth.userId;

      if (userId != null) {
        context.read<ProductsApiProvider>().fetchFarmerProducts(
          int.parse(userId),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F8F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: Colors.black),
            SizedBox(width: 8),
            Text(
              "Inventory",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0DF20D),
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProduct),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<ProductsApiProvider>(
        builder: (context, provider, child) {
          if (provider.loading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text("No products added yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];

              return InventoryCard(
                product: product,
                onDelete: () async {
                  try {
                    await provider.deleteProduct(product.id); // ✅ Direct use
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  final ProductApiModel product;
  final VoidCallback onDelete;

  const InventoryCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = product.quantity <= 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 80,
              width: 80,
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "${product.quantity} ${product.unit ?? ''} remaining",
                  style: TextStyle(
                    fontSize: 16,
                    color: isLowStock ? Colors.red : Colors.black,
                  ),
                ),
                // Text(
                //   "₹${product.price.toStringAsFixed(2)} / ${product.unit ?? ''}",
                //   style: const TextStyle(
                //     color: Colors.green,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                if (product.discount != null && product.discount! > 0) ...[
                  Row(
                    children: [
                      Text(
                        "-${product.discount!.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹${product.discountedPrice!.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "₹${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ] else
                  Text(
                    "₹${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.editProduct,
                    arguments: product,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
