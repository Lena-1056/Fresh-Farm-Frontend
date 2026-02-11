import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            CustomTextField(hint: "Product Name"),
            SizedBox(height: 15),
            CustomTextField(hint: "Price per Kg"),
            SizedBox(height: 15),
            CustomTextField(hint: "Quantity Available"),
          ],
        ),
      ),
    );
  }
}
