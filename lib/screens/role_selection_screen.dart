import 'package:flutter/material.dart';
import '../core/routes.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String role = "farmer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              /// 🔹 Progress Bar
              const SizedBox(height: 20),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.33,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0DF20D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 🔹 Header
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "How will you use the app?",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select your primary role to customize your experience in the marketplace.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 🔹 Role Cards
              _buildRoleCard(
                value: "farmer",
                title: "I am a Farmer",
                description:
                    "Sell your fresh produce directly to local customers and grow your business.",
                icon: Icons.agriculture,
              ),

              const SizedBox(height: 20),

              _buildRoleCard(
                value: "buyer",
                title: "I am a Buyer",
                description:
                    "Shop farm-fresh goods delivered from local growers directly to your door.",
                icon: Icons.shopping_basket,
              ),

              const Spacer(),

              /// 🔹 Decorative Image
              Opacity(
                opacity: 0.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    "https://images.unsplash.com/photo-1500937386664-56d1dfef3854",
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// 🔹 Continue Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0DF20D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    if (role == "farmer") {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.farmerDashboard);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.buyerDashboard);
                    }
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "You can change your role later in account settings.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Custom Role Card
  Widget _buildRoleCard({
    required String value,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final bool isSelected = role == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          role = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0DF20D)
                : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF0DF20D).withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Icon Box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0DF20D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0DF20D),
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            /// Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            /// Selection Circle
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0DF20D)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xFF0DF20D),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
