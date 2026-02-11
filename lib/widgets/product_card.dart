import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;

  const ProductCard({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: const Icon(Icons.agriculture),
        title: Text(title),
        subtitle: Text(price),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
