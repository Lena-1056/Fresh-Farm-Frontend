import 'package:flutter/material.dart';
import '../../core/routes.dart';

enum OrderStatus { pending, inProgress, completed }

class Order {
  final String customer;
  final String id;
  final List<String> items;
  OrderStatus status;

  Order({
    required this.customer,
    required this.id,
    required this.items,
    required this.status,
  });
}

class FarmerOrdersScreen extends StatefulWidget {
  const FarmerOrdersScreen({super.key});

  @override
  State<FarmerOrdersScreen> createState() => _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
  int selectedIndex = 1;
  final Color primaryColor = const Color(0xFF0DF20D);

  String selectedFilter = "All";

  final List<Order> orders = [
    Order(
      customer: "Marcus Richardson",
      id: "#ORD-9921",
      items: [
        "Organic Heirloom Carrots - 5kg",
        "Grass-fed Jersey Milk - 2L",
        "Farm Fresh Eggs - 2 Dozen",
      ],
      status: OrderStatus.pending,
    ),
  ];

  List<Order> get filteredOrders {
    if (selectedFilter == "Pending") {
      return orders.where((o) => o.status == OrderStatus.pending).toList();
    } else if (selectedFilter == "In Progress") {
      return orders.where((o) => o.status == OrderStatus.inProgress).toList();
    } else if (selectedFilter == "Completed") {
      return orders.where((o) => o.status == OrderStatus.completed).toList();
    }
    return orders;
  }

  void _onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.farmerDashboard);
    }
  }

  void _handleFilter(String value) {
    setState(() {
      selectedFilter = value;
    });
  }

  void _updateOrderStatus(Order order) {
    setState(() {
      if (order.status == OrderStatus.pending) {
        order.status = OrderStatus.inProgress;
      } else if (order.status == OrderStatus.inProgress) {
        order.status = OrderStatus.completed;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8F6),

      bottomNavigationBar: _buildBottomNav(),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Orders",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSearchAndFilter(),
            const SizedBox(height: 25),

            if (filteredOrders.isEmpty)
              const Center(child: Text("No orders found")),

            ...filteredOrders.map((order) => _orderCard(order)).toList(),
          ],
        ),
      ),
    );
  }

  /// ================= SEARCH + FILTER =================

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(blurRadius: 6, color: Colors.black12),
              ],
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

        /// FILTER BUTTON WITH CURSOR
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PopupMenuButton<String>(
            onSelected: _handleFilter,
            itemBuilder: (context) => const [
              PopupMenuItem(value: "All", child: Text("All")),
              PopupMenuItem(value: "Pending", child: Text("Pending")),
              PopupMenuItem(value: "In Progress", child: Text("In Progress")),
              PopupMenuItem(value: "Completed", child: Text("Completed")),
            ],
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black12),
                ],
              ),
              child: const Icon(Icons.filter_list),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= ORDER CARD =================

  Widget _orderCard(Order order) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
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
                      order.customer,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("ID: ${order.id}"),
                  ],
                ),
                _statusBadge(order.status),
              ],
            ),
            const SizedBox(height: 16),
            ...order.items.map((e) => Text(e)).toList(),
            const SizedBox(height: 20),

            if (order.status != OrderStatus.completed)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  onPressed: () => _updateOrderStatus(order),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    order.status == OrderStatus.pending
                        ? "Mark as Ready"
                        : "Mark as Delivered",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ================= STATUS BADGE =================

  Widget _statusBadge(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = "Pending";
        break;
      case OrderStatus.inProgress:
        color = Colors.blue;
        text = "In Progress";
        break;
      case OrderStatus.completed:
        color = Colors.green;
        text = "Completed";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ================= BOTTOM NAV =================

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
          _bottomNavItem(icon: Icons.dashboard, label: "Dashboard", index: 0),
          _bottomNavItem(icon: Icons.receipt_long, label: "Orders", index: 1),
          _bottomNavItem(icon: Icons.storefront, label: "Market", index: 2),
          _bottomNavItem(icon: Icons.settings, label: "Settings", index: 3),
        ],
      ),
    );
  }

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = selectedIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
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
      ),
    );
  }
}
