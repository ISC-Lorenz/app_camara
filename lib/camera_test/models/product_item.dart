class ProductItem {
  String id;
  String name;
  int quantity;
  double price;

  ProductItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory ProductItem.getFromFirebase(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'],
      name: json['name'],
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'quantity': quantity};
  }
}
