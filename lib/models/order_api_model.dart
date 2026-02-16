class OrderApiModel {
  final int id;
  final int? productId;
  final String? productName;
  final int quantity;
  final double totalPrice;
  final String status;
  final String? createdAt;
  final String? buyerName;

  OrderApiModel({
    required this.id,
    this.productId,
    this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    this.createdAt,
    this.buyerName,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    return OrderApiModel(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: json['productId'] is int ? json['productId'] : int.tryParse(json['productId']?.toString() ?? ''),
      productName: json['productName'] as String?,
      quantity: (json['quantity'] is int) ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      totalPrice: (json['totalPrice'] is num) ? (json['totalPrice'] as num).toDouble() : double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0,
      status: json['status'] as String? ?? 'IN_PROGRESS',
      createdAt: json['createdAt'] as String?,
      buyerName: json['buyerName'] as String?,
    );
  }
}
