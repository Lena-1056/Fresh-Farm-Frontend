import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_api_model.dart';
import '../../providers/products_api_provider.dart';

class EditProductScreen extends StatefulWidget {
  final ProductApiModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  late TextEditingController discountController;

  String category = "Vegetables";
  String unit = "kg";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    descriptionController = TextEditingController(
      text: widget.product.description,
    );

    discountController = TextEditingController(
      text: widget.product.discount?.toString() ?? "",
    );

    category = widget.product.category;
    unit = widget.product.unit ?? "kg";
  }

  void updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final updatedProduct = ProductApiModel(
      id: widget.product.id,
      name: nameController.text,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? 0,
      quantity: int.tryParse(quantityController.text) ?? 0,
      imageUrl: widget.product.imageUrl,
      category: category,
      unit: unit,
      discount: discountController.text.isNotEmpty
          ? double.tryParse(discountController.text)
          : null, // ✅ Remove discount if empty
    );

    try {
      await context.read<ProductsApiProvider>().updateProduct(updatedProduct);

      if (!mounted) return;

      setState(() => isLoading = false);
      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }
  }

  InputDecoration input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: input("Product Name"),
                validator: (v) => v!.isEmpty ? "Enter product name" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField(
                value: category,
                items: ["Vegetables", "Fruits", "Grains", "Herbs"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => category = v!),
                decoration: input("Category"),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: input("Quantity"),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField(
                value: unit,
                items: ["kg", "g", "box", "ton"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => unit = v!),
                decoration: input("Unit"),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: input("Price"),
              ),
              const SizedBox(height: 16),

              // ✅ DISCOUNT FIELD (ONLY HERE)
              TextFormField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: input("Discount % (Optional)"),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final d = double.tryParse(value);
                    if (d == null || d < 0 || d > 90) {
                      return "Enter valid discount (0-90%)";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: input("Description"),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: isLoading ? null : updateProduct,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Update Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
