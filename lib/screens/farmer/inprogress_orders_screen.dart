import 'package:flutter/material.dart';

class InProgressOrdersScreen extends StatelessWidget {
  const InProgressOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("In Progress Orders")),
      body: const Center(
        child: Text("All In Progress Orders", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
