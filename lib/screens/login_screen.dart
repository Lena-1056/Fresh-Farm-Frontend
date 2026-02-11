import 'package:flutter/material.dart';
import '../core/routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CustomTextField(hint: "Email"),
            const SizedBox(height: 15),
            const CustomTextField(hint: "Password", isPassword: true),
            const SizedBox(height: 20),
            CustomButton(
              text: "Login",
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.role);
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signup);
              },
              child: const Text("Create Account"),
            )
          ],
        ),
      ),
    );
  }
}
