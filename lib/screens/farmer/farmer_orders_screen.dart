import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../models/order_api_model.dart';
import '../../providers/orders_provider.dart';

class FarmerOrdersScreen extends StatefulWidget {
  const FarmerOrdersScreen({super.key});

  @override
  State<FarmerOrdersScreen> createState() => _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
  int selectedIndex = 1;
  final Color primaryColor = const Color(0xFF0DF20D);
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchMyOrders();
    });
  }

  List<OrderApiModel> filteredOrders(List<OrderApiModel> orders) {
    if (selectedFilter == "In Progress") {
      return orders.where((o) => o.status == "IN_PROGRESS").toList();
    } else if (selectedFilter == "Completed") {
      return orders.where((o) => o.status == "COMPLETED").toList();
    }
    return orders;
  }

  void _onNavTap(int index) {
    setState(() => selectedIndex = index);
    if (index == 0) Navigator.pushNamed(context, AppRoutes.farmerDashboard);
    if (index == 2) Navigator.pushNamed(context, AppRoutes.farmerInventory);
    if (index == 3) Navigator.pushNamed(context, AppRoutes.farmerProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8F6),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: Consumer<OrdersProvider>(
          builder: (context, provider, _) {
            if (provider.loading && provider.orders.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null && provider.orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
                ),
              );
            }
            final orders = filteredOrders(provider.orders);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Orders",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildSearchAndFilter(),
                const SizedBox(height: 25),
                if (orders.isEmpty)
                  const Center(child: Text("No orders found"))
                else
                  ...orders.map((order) => _orderCard(context, order, provider)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search orders...",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        PopupMenuButton<String>(
          onSelected: (value) => setState(() => selectedFilter = value),
          itemBuilder: (context) => const [
            PopupMenuItem(value: "All", child: Text("All")),
            PopupMenuItem(value: "In Progress", child: Text("In Progress")),
            PopupMenuItem(value: "Completed", child: Text("Completed")),
          ],
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
            ),
            child: const Icon(Icons.filter_list),
          ),
        ),
      ],
    );
  }

  Widget _orderCard(BuildContext context, OrderApiModel order, OrdersProvider provider) {
    final isInProgress = order.status == "IN_PROGRESS";
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.buyerName ?? "Customer",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text("ID: #${order.id}"),
                ],
              ),
              _statusBadge(order.status),
            ],
          ),
          const SizedBox(height: 16),
          Text("${order.productName ?? 'Product'} × ${order.quantity}"),
          Text("₹${order.totalPrice.toStringAsFixed(2)}"),
          const SizedBox(height: 20),
          if (isInProgress)
            ElevatedButton(
              onPressed: () async {
                try {
                  await provider.completeOrder(order.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order completed")));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.black),
              child: const Text("Mark as Delivered"),
            ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = status == "COMPLETED" ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status.replaceAll('_', ' '), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomNavItem(Icons.dashboard, "Dashboard", 0),
          _bottomNavItem(Icons.receipt_long, "Orders", 1),
          _bottomNavItem(Icons.inventory_2_outlined, "Inventory", 2),
          _bottomNavItem(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label, int index) {
    final bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? primaryColor : Colors.grey),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
