class Product {
  String? id;
  String name;
  int stock;
  double price;
  String img;

  Product({
    this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.img,
  });

  factory Product.getFromFirebase(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      stock: int.parse(json['stock'].toString()),
      price: double.parse(json['price'].toString()),
      img: json['img'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'img': img,
    };
  }

  String getImage() {
    return img;
  }

  // factory Product.getById(String iD, Map json) {
  //   return Product(
  //     id: iD,
  //     name: json['name'],
  //     stock: json['stock'],
  //     price: json['price'],
  //   );
  // }
}
