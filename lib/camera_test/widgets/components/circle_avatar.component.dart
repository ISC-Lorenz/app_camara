import 'package:app_camara/camera_test/models/product.dart';
import 'package:flutter/material.dart';

class CircleAvatarComponent extends StatelessWidget {
  const CircleAvatarComponent({
    super.key,
    required this.sizeCircle,
    required this.product,
  });
  final double sizeCircle;
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        CircleAvatar(
          radius: sizeCircle,
          child: ClipOval(
            // child: Icon(Icons.shopping_cart_sharp, size: sizeCircle + 10),
            child: Image.network(
              product.getImage(),
              width: sizeCircle + 40,
              height: sizeCircle + 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
