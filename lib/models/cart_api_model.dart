class CartApiModel {
  final int id;
  final int productId;
  final String productName;
  final double productPrice;
  final String? productImageUrl;
  final int quantity;
  final double subtotal;

  CartApiModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    this.productImageUrl,
    required this.quantity,
    required this.subtotal,
  });

  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: (json['productId'] is int) ? json['productId'] : int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
      productName: json['productName'] as String? ?? '',
      productPrice: (json['productPrice'] is num) ? (json['productPrice'] as num).toDouble() : double.tryParse(json['productPrice']?.toString() ?? '0') ?? 0,
      productImageUrl: json['productImageUrl'] as String?,
      quantity: (json['quantity'] is int) ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      subtotal: (json['subtotal'] is num) ? (json['subtotal'] as num).toDouble() : double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
    );
  }
}
