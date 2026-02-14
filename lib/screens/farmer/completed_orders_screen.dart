import 'package:flutter/material.dart';

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Completed Orders")),
      body: const Center(
        child: Text("All Completed Orders", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
