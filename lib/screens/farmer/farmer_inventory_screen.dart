import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';

class FarmerInventoryScreen extends StatelessWidget {
  const FarmerInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),

      /// ================= APP BAR =================
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

        /// ✅ SEARCH + FILTER ICONS ADDED
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Future search logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              // Future filter logic
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      /// ================= ADD BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0DF20D),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      /// ================= PRODUCT LIST =================
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            return const Center(child: Text("No products added yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              return InventoryCard(
                product: provider.products[index],
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  final ProductModel product;
  final int index;

  const InventoryCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final bool isLowStock = product.quantity <= 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Column(
        children: [
          /// ================= TOP ROW =================
          Row(
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 80,
                  width: 80,
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

              const SizedBox(width: 16),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        /// ✅ EDIT ICON (Styled)
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            // future edit screen
                          },
                        ),
                      ],
                    ),

                    Text(
                      product.category,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 8),

                    /// QUANTITY
                    Row(
                      children: [
                        Text(
                          "${product.quantity}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isLowStock ? Colors.red : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text("${product.quantityType} remaining"),
                      ],
                    ),

                    if (isLowStock)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "LOW STOCK",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),

                    const SizedBox(height: 6),

                    /// PRICE
                    Text(
                      "\$${product.price.toStringAsFixed(2)} / ${product.quantityType}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 25),

          /// ================= VISIBILITY =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ✅ PUBLIC ICON ADDED
              Row(
                children: [
                  Icon(
                    product.isOnline ? Icons.public : Icons.public_off,
                    size: 18,
                    color: product.isOnline ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    product.isOnline
                        ? "Visibility: ONLINE"
                        : "Visibility: OFFLINE",
                    style: TextStyle(
                      color: product.isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),

              Switch(
                value: product.isOnline,
                activeColor: const Color(0xFF0DF20D),
                onChanged: (value) {
                  provider.toggleVisibility(index, value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
