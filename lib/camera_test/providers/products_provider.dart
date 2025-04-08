import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  final List<String> _cart = [];
  final List<String> _products = [];
  String _idProduct = '';
  final String _url = '';

  List<String> get products => _products;
  String get idProduct => _idProduct;
  List<String> get getShoppingCart => _cart;
  String get url => _url;

  void addShoppingCart(String prudct) {
    _cart.add(prudct);
    notifyListeners();
  }

  void addProduct(String productName) {
    _products.add(productName);
    notifyListeners();
  }

  void selectedProduct(String idProduct) {
    _idProduct = idProduct;
    notifyListeners();
  }

  void deleteProductName(String product) {
    _products.remove(product);
  }
}
