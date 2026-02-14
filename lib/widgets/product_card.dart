import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: buildImage(),

        title: Text(product.name),
        subtitle: Text(
          "${product.quantity} ${product.quantityType} • ₹${product.price}\n${product.location}",
        ),
      ),
    );
  }

  Widget buildImage() {
    if (kIsWeb && product.webImage != null) {
      return Image.memory(
        product.webImage!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    if (!kIsWeb && product.imagePath != null) {
      return Image.file(
        File(product.imagePath!),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    return const Icon(Icons.image);
  }
}
