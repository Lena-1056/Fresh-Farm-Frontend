import 'package:flutter/material.dart';
import '../core/routes.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String role = "buyer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text("Farmer"),
            value: "farmer",
            groupValue: role,
            onChanged: (val) {
              setState(() {
                role = val!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text("Buyer"),
            value: "buyer",
            groupValue: role,
            onChanged: (val) {
              setState(() {
                role = val!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (role == "farmer") {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.farmerDashboard);
              } else {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.buyerDashboard);
              }
            },
            child: const Text("Continue"),
          )
        ],
      ),
    );
  }
}
