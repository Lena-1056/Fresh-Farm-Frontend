import 'dart:typed_data';

class ProductModel {
  final String name;
  final String category;
  final double price;
  final int quantity;
  final String quantityType;
  final String location;

  final String description;
  final bool isOrganic;
  final String harvestDate;

  final Uint8List? webImage;
  final String? imagePath;

  bool isOnline;

  ProductModel({
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.quantityType,
    required this.location,
    required this.description,
    required this.isOrganic,
    required this.harvestDate,
    this.webImage,
    this.imagePath,
    this.isOnline = true,
  });
}
