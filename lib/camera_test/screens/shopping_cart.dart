import 'package:app_camara/camera_test/models/product_item.dart';
import 'package:app_camara/camera_test/services/firebase_transactions.dart';
import 'package:app_camara/camera_test/services/shoping_cart.transactions.dart';
import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos en el carrito'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: getShoppingCartItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductItem> items = snapshot.data as List<ProductItem>;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                ProductItem item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Cantidad: ${item.quantity}'),
                  trailing: IconButton(
                    icon: Column(
                      children: [
                        Icon(Icons.shopping_cart_checkout_outlined, size: 20),
                      ],
                    ),
                    onPressed: () async {
                      await incrementProductStock(item.name);
                      await decrementProductFromShoppingCart(item.id).then((_) {
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/', (route) => false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Producto devuelto al inventario'),
                            ),
                          );
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
