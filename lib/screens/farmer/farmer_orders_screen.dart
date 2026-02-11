import 'package:flutter/material.dart';

class FarmerOrdersScreen extends StatelessWidget {
  const FarmerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Farmer Orders")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Tomatoes - 2kg"),
            subtitle: Text("Status: Pending"),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Carrots - 1kg"),
            subtitle: Text("Status: Delivered"),
          ),
        ],
      ),
    );
  }
}
