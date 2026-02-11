import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  Widget buildStep(String title, bool completed) {
    return ListTile(
      leading: Icon(
        completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: completed ? Colors.green : Colors.grey,
      ),
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Tracking")),
      body: Column(
        children: [
          buildStep("Order Placed", true),
          buildStep("Confirmed by Farmer", true),
          buildStep("Packed", false),
          buildStep("Out for Delivery", false),
          buildStep("Delivered", false),
        ],
      ),
    );
  }
}
