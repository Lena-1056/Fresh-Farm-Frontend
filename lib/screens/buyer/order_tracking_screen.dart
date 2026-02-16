import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_api_model.dart';
import '../../providers/orders_provider.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: Consumer<OrdersProvider>(
        builder: (context, provider, _) {
          if (provider.loading && provider.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
              ),
            );
          }
          if (provider.orders.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderApiModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(order.productName ?? 'Product'),
        subtitle: Text(
          "Qty: ${order.quantity} • ₹${order.totalPrice.toStringAsFixed(2)} • ${order.status}",
        ),
        trailing: order.status == 'IN_PROGRESS'
            ? const Icon(Icons.hourglass_empty, color: Colors.orange)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
