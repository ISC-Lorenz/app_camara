import 'package:app_camara/camera_test/models/product.dart';
import 'package:app_camara/camera_test/services/firebase_transactions.dart';
import 'package:app_camara/camera_test/widgets/product_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/view-shopping-cart');
            },
            icon: Row(
              children: [Text('Ver productos'), Icon(Icons.shopify_rounded)],
            ),
          ),
        ],
        title: const Text("Home Screen"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProductWidget(products: snapshot.data as List<Product>);
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
