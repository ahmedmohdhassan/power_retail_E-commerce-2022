class Product {
  Product({
    this.id,
    this.name,
    this.imageUrl,
    this.details,
    this.newPrice,
    this.oldPrice,
    this.packagePrice,
    this.packageunits,
    this.productPoints,
  });

  int? id;
  String? name;
  String? imageUrl;
  String? details;
  double? oldPrice;
  double? newPrice;
  double? packagePrice;
  double? packageunits;
  double? productPoints;
}
