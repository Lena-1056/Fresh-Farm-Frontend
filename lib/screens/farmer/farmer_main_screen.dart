import 'package:flutter/material.dart';
import 'farmer_dashboard.dart';
import 'add_product_screen.dart';
import 'farmer_orders_screen.dart';

class FarmerMainScreen extends StatefulWidget {
  const FarmerMainScreen({super.key});

  @override
  State<FarmerMainScreen> createState() => _FarmerMainScreenState();
}

class _FarmerMainScreenState extends State<FarmerMainScreen> {

  int currentIndex = 0;

  final List<Widget> screens = const [
    FarmerDashboard(),
    AddProductScreen(),
    FarmerOrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF0DF20D),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Add Product",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Orders",
          ),
        ],
      ),
    );
  }
}
