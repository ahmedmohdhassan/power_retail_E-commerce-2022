class CartItem {
  final String id;
  final String? title;
  final int quantity;
  final double? price;
  final double? unitPrice;
  final double? packPrice;
  final String? imageUrl;
  final String? unitType;
  final String? productId;
  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.unitPrice,
    required this.quantity,
    this.packPrice,
    this.unitType,
    this.imageUrl,
    this.productId,
  });
}
