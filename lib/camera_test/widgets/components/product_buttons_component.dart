import 'package:app_camara/camera_test/models/product.dart';
import 'package:app_camara/camera_test/models/product_item.dart';
import 'package:app_camara/camera_test/providers/products_provider.dart';
import 'package:app_camara/camera_test/services/firebase_transactions.dart';
import 'package:app_camara/camera_test/services/shoping_cart.transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductButtonsComponent extends StatelessWidget {
  const ProductButtonsComponent({super.key, required this.idProduct});
  final String idProduct;

  @override
  Widget build(BuildContext context) {
    //String idProduct = context.watch<ProductsProvider>().idProduct;
    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushNamed(context, '/product-info');
            context.read<ProductsProvider>().selectedProduct(idProduct);
          },
          child: Icon(
            Icons.edit_outlined,
            color: Colors.blue.shade300,
            size: 25,
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Icon(Icons.delete_sharp, color: Colors.red, size: 25),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            Product? product = await getProductById(idProduct);
            if (product != null) {
              if (product.stock > 0) {
                ProductItem item = ProductItem(
                  id: product.id as String,
                  name: product.name,
                  price: product.price,
                  quantity: 1,
                );
                await decrementProductStock(product.id as String);
                await addProductToShoppingCart(item).then((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Producto agregado al carrito')),
                    );
                  }
                });
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El producto no tiene stock disponible'),
                    ),
                  );
                }
              }
            }
          },
          child: Icon(Icons.production_quantity_limits),
        ),
      ],
    );
  }
}
