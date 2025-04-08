import 'package:app_camara/camera_test/models/product.dart';
import 'package:app_camara/camera_test/widgets/components/circle_avatar.component.dart';
import 'package:app_camara/camera_test/widgets/components/product_buttons_component.dart';
import 'package:app_camara/camera_test/widgets/components/product_data_component.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(9),
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              children: [
                CircleAvatarComponent(sizeCircle: 35, product: product),
                ProductDataComponent(product: product),
                ProductButtonsComponent(idProduct: product.id as String),
              ],
            ),
          ),
        );
      },
    );
  }
}
