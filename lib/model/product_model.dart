class Product {
  final int id;
  final String name;
  final String imageurl;
  final String description;
  final double price;
  int quantity;

  final double saleprice;
  final int sku;
  final int weight;
  final double costprice;
  final int barcode;

  Product({
    required this.id,
    required this.name,
    required this.imageurl,
    required this.description,
    required this.price,
    this.quantity = 1,
    required this.saleprice,
    required this.sku,
    required this.weight,
    required this.costprice,
    required this.barcode,
  });
}
