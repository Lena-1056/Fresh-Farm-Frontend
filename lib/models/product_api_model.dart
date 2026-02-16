class ProductApiModel {
  final int id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double? discount;
  final double? discountedPrice;
  final int quantity;
  final String? unit;
  final String? imageUrl;
  final int? farmerId;
  final String? farmerName; // ✅ IMPORTANT
  final String? createdAt;

  ProductApiModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.quantity,
    this.discount,
    this.discountedPrice,
    this.unit,
    this.imageUrl,
    this.farmerId,
    this.farmerName,
    this.createdAt,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      quantity: json['quantity'] ?? 0,
      unit: json['unit'],
      imageUrl: json['imageUrl'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'], // ✅ MUST MAP THIS
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "description": description,
      "price": price,
      "quantity": quantity,
      "unit": unit,
      "discount": discount,
      "imageUrl": imageUrl,
    };
  }
}
