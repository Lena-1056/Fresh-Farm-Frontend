import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            CustomTextField(hint: "Name"),
            SizedBox(height: 15),
            CustomTextField(hint: "Email"),
            SizedBox(height: 15),
            CustomTextField(hint: "Password", isPassword: true),
          ],
        ),
      ),
    );
  }
}
