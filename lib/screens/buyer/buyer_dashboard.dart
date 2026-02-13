import 'package:flutter/material.dart';
import '../../core/routes.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  String role = "buyer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      body: SafeArea(
        child: Stack(
          children: [

            /// MAIN CONTENT
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  /// 🔹 ROLE SWITCH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildRoleSwitch("buyer", "Buyer", Icons.shopping_basket),
                      const SizedBox(width: 20),
                      buildRoleSwitch("farmer", "Farmer", Icons.agriculture),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "Fresh Explorer",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.cart);
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// SEARCH
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search fresh produce...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// CATEGORIES
                  const Text(
                    "Categories",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryItem("🍎", "Fruits"),
                        CategoryItem("🥦", "Veggies"),
                        CategoryItem("🥛", "Dairy"),
                        CategoryItem("🌾", "Grains"),
                        CategoryItem("🍯", "Honey"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// DEALS
                  const Text(
                    "Deals Near You",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        dealCard("Green Harvest Box"),
                        dealCard("Summer Berry Mix"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// PRODUCTS
                  const Text(
                    "Freshly Picked",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  productRow(context, "Organic Carrots", "₹50/kg"),
                  productRow(context, "Honey Crisp Apples", "₹70/kg"),
                  productRow(context, "Whole Raw Milk", "₹60/L"),
                ],
              ),
            ),

            /// BOTTOM NAV
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BottomNavItem(Icons.home, "Home", true),
                    BottomNavItem(Icons.explore, "Explore", false),
                    BottomNavItem(Icons.shopping_cart, "Cart", false),
                    BottomNavItem(Icons.receipt_long, "Orders", false),
                    BottomNavItem(Icons.person, "Profile", false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ROLE SWITCH BUILDER
  Widget buildRoleSwitch(String value, String label, IconData icon) {
    final bool isSelected = role == value;

    return GestureDetector(
      onTap: () {
        if (value == "farmer") {
          Navigator.pushReplacementNamed(
              context, AppRoutes.farmerDashboard);
        } else {
          setState(() {
            role = "buyer";
          });
        }
      },
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: isSelected
                  ? const Color(0xFF0DF20D)
                  : Colors.grey),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF0DF20D)
                  : Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0DF20D)
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Center(
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Color(0xFF0DF20D),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget dealCard(String title) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
              "https://images.unsplash.com/photo-1500937386664-56d1dfef3854"),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    );
  }

  Widget productRow(BuildContext context, String title, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.productDetail);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.agriculture,
                  color: Color(0xFF0DF20D), size: 35),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(price,
                      style: const TextStyle(
                          color: Color(0xFF0DF20D),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.add_circle,
                color: Color(0xFF0DF20D))
          ],
        ),
      ),
    );
  }
}

/// CATEGORY WIDGET
class CategoryItem extends StatelessWidget {
  final String emoji;
  final String title;

  const CategoryItem(this.emoji, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF0DF20D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}

/// BOTTOM NAV ITEM
class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNavItem(this.icon, this.label, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            color: active
                ? const Color(0xFF0DF20D)
                : Colors.grey),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: active
                    ? const Color(0xFF0DF20D)
                    : Colors.grey))
      ],
    );
  }
}
