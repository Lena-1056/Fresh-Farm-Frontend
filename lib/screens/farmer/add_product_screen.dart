import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/product_api_model.dart';
import '../../providers/products_api_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();

  String category = "Vegetables";
  String quantityType = "kg";
  String location = "Detecting location...";
  String harvestDate = "Select Date";
  bool isOrganic = false;

  List<Uint8List> webImages = [];
  String? _imageUrlBase64;

  final greenColor = const Color(0xFF0DF20D);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    detectLocation();
  }

  Future<void> detectLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => location = "Location Disabled");
      return;
    }
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() => location = "Permission Denied");
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        location =
            "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
      });
    } catch (_) {
      setState(() => location = "Unavailable");
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isEmpty) return;
    for (var picked in pickedFiles) {
      if (webImages.length >= 5) break;
      webImages.add(await picked.readAsBytes());
    }
    if (webImages.isNotEmpty) {
      final b64 = base64Encode(webImages.first);
      _imageUrlBase64 = b64.length <= 100000
          ? "data:image/jpeg;base64,$b64"
          : null;
    }
    setState(() {});
  }

  Future<void> pickDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(
        () =>
            harvestDate = "${selected.day}/${selected.month}/${selected.year}",
      );
    }
  }

  void submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // ✅ FIXED: Only description text
    final desc = descriptionController.text;

    final product = ProductApiModel(
      id: 0,
      name: nameController.text,
      description: desc,
      price: double.tryParse(priceController.text) ?? 0,
      quantity: int.tryParse(quantityController.text) ?? 0,
      unit: quantityType,
      imageUrl: _imageUrlBase64,
      category: category,
    );

    try {
      await context.read<ProductsApiProvider>().addProduct(product);
      if (!mounted) return;
      setState(() => isLoading = false);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: ${e.toString().replaceFirst('Exception: ', '')}",
            ),
          ),
        );
      }
    }
  }

  InputDecoration modernInput(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Add product", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Produce Photos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...webImages.asMap().entries.map(
                  (e) =>
                      buildImageBox(Image.memory(e.value, fit: BoxFit.cover)),
                ),
                if (webImages.length < 5)
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: greenColor, width: 1.5),
                      ),
                      child: Icon(Icons.add, color: greenColor, size: 30),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: nameController,
              decoration: modernInput("Product Name"),
              validator: (value) =>
                  value!.isEmpty ? "Enter product name" : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: category,
              items: [
                "Vegetables",
                "Fruits",
                "Grains",
                "Herbs",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => category = value!),
              decoration: modernInput("Category"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: modernInput("Quantity"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter quantity" : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: modernInput("Price"),
                    validator: (value) => value!.isEmpty ? "Enter price" : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: quantityType,
              items: [
                "kg",
                "g",
                "box",
                "ton",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => quantityType = value!),
              decoration: modernInput("Unit"),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: modernInput("Description"),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Organic Product"),
                      const Spacer(),
                      Switch(
                        value: isOrganic,
                        activeColor: greenColor,
                        onChanged: (value) => setState(() => isOrganic = value),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text("Harvest Date"),
                      const Spacer(),
                      Text(
                        harvestDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: pickDate,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text("Location"),
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                ),
                onPressed: isLoading ? null : submitProduct,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Post Product 🚀",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageBox(Widget image) {
    return Container(
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: image),
    );
  }
}
