import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../providers/farmer_provider.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  final Color primaryColor = const Color(0xFF0DF20D);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FarmerProvider>();
    final farmer = provider.farmer;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 8, color: Colors.black12),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    farmer.ownerName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    farmer.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// FARM DETAILS
            _cardSection("Farm Details", [
              _infoRow("Farm Name", farmer.farmName),
              _infoRow("Location", farmer.location),
              _infoRow("Farming Type", farmer.farmingType),
              _infoRow("Farm Size", farmer.farmSize),
              _infoRow("Irrigation", farmer.irrigation),
              _infoRow("Main Crops", farmer.mainCrops),
              _infoRow("Harvest Frequency", farmer.harvestFrequency),
            ]),

            const SizedBox(height: 20),

            /// CONTACT
            _cardSection("Contact", [
              _infoRow("Phone", farmer.phone),
              _infoRow("Email", farmer.email),
            ]),

            const SizedBox(height: 20),

            /// BUSINESS SETTINGS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: SwitchListTile(
                title: const Text("Farm Availability"),
                value: farmer.isAvailable,
                activeColor: primaryColor,
                onChanged: (value) {
                  context.read<FarmerProvider>().toggleAvailability(value);
                },
              ),
            ),

            const SizedBox(height: 30),

            /// EDIT BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.editFarmerProfile);
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
            ),

            const SizedBox(height: 15),

            /// LOGOUT BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                context.read<FarmerProvider>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.onboarding,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
