import 'package:app_camara/camera_test/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDataComponent extends StatelessWidget {
  const ProductDataComponent({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            product.name,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Precio: \$${product.price}",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('products')
                        .doc(product.id)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var productData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    int stock = productData['stock'];

                    return Text(
                      'Stock: $stock',
                      style: TextStyle(fontSize: 16),
                    );
                  }

                  return Text('0', style: TextStyle(color: Colors.red));
                },
              ),
              // Text("Stock: ${product.stock}"),
            ],
          ),
        ],
      ),
    );
  }
}
