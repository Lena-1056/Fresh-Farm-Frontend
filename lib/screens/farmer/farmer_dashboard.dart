import 'package:flutter/material.dart';
import '../../core/routes.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  String role = "farmer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0DF20D),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SafeArea(
        child: Stack(
          children: [

            /// MAIN CONTENT
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  /// ROLE SWITCH PILL
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildRoleButton("farmer", Icons.agriculture),
                          buildRoleButton("buyer", Icons.shopping_bag),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// PROFILE HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1500937386664-56d1dfef3854"),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                              Text(
                                "Farmer Joe",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: const Icon(Icons.notifications),
                      )
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// STATS GRID
                  Row(
                    children: [
                      Expanded(child: statCard("Products", "24")),
                      const SizedBox(width: 12),
                      Expanded(child: statCard("Active", "12")),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// REVENUE CARD
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Total Revenue",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "₹2,48,000",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        /// SIMPLE BAR CHART
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            double height = (index + 2) * 12;
                            return Container(
                              width: 12,
                              height: height,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0DF20D)
                                    .withOpacity(0.7),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// RECENT ORDERS
                  const Text(
                    "Recent Orders",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  orderTile("Sarah Miller", "₹4500", "Pending"),
                  orderTile("Robert Chen", "₹1250", "Shipped"),
                  orderTile("Emily Watson", "₹3800", "Shipped"),
                ],
              ),
            ),

            /// BOTTOM NAVIGATION
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
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: const [
                    BottomNav(Icons.dashboard, "Dashboard", true),
                    BottomNav(Icons.receipt_long, "Orders", false),
                    BottomNav(Icons.storefront, "Market", false),
                    BottomNav(Icons.settings, "Settings", false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ROLE BUTTON
  Widget buildRoleButton(String value, IconData icon) {
    final bool isSelected = role == value;

    return GestureDetector(
      onTap: () {
        if (value == "buyer") {
          Navigator.pushReplacementNamed(
              context, AppRoutes.buyerDashboard);
        } else {
          setState(() {
            role = "farmer";
          });
        }
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFF0DF20D)
              : Colors.grey,
        ),
      ),
    );
  }

  /// STAT CARD
  Widget statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black12)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// ORDER TILE
  Widget orderTile(String name, String price, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(price,
                  style: const TextStyle(
                      color: Color(0xFF0DF20D),
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: status == "Pending"
                  ? Colors.orange.shade100
                  : const Color(0xFF0DF20D).withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: status == "Pending"
                      ? Colors.orange
                      : const Color(0xFF0DF20D)),
            ),
          )
        ],
      ),
    );
  }
}

/// BOTTOM NAV ITEM
class BottomNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNav(this.icon, this.label, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(icon,
            color: active
                ? const Color(0xFF0DF20D)
                : Colors.grey),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? const Color(0xFF0DF20D)
                    : Colors.grey))
      ],
    );
  }
}
