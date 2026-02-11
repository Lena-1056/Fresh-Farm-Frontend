import 'package:flutter/material.dart';
import '../../core/routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("Fresh Tomatoes"),
            subtitle: const Text("₹40/kg"),
            trailing: const Text("1 kg"),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.tracking);
              },
              child: const Text("Place Order"),
            ),
          )
        ],
      ),
    );
  }
}
