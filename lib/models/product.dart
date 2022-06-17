class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final  lastUpload;
  final image;  
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.image,
      required this.lastUpload});
  factory Product.fromJson(json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      image: json['image'],
      lastUpload: json['last_upload'],
    );
  }
}

class Products {
  final List<Product> products;
  Products({required this.products});
  factory Products.fromJson(List<dynamic> json) {
    var procutsList = json.map((json) => Product.fromJson(json)).toList();
    return Products(products: procutsList);
  }
}
