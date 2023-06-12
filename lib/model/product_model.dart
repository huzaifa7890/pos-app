class Product {
  final int id;
  final String name;
  final description;
  final double price;
  final double saleprice;
  final int sku;
  final int weight;
  final costprice;
  final barcode;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.saleprice,
    required this.sku,
    required this.weight,
    this.costprice,
    this.barcode,
  });
}
