import 'package:app_camara/camera_test/models/product_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Future<List<ProductItem>> getShoppingCartItems() async {
//   CollectionReference colecction = db.collection("shoppingcart");
//   QuerySnapshot queryProducts = await colecction.get();
//   List<ProductItem> products =
//       queryProducts.docs.map((product) {
//         return ProductItem.getFromFirebase({
//           ...product.data() as Map<String, dynamic>,
//           'id': product.id,
//         });
//       }).toList();
//   return products;
// }
Future<List<ProductItem>> getShoppingCartItems() async {
  CollectionReference collection = db.collection("shoppingcart");
  QuerySnapshot queryProducts = await collection.get();
  List<ProductItem> products = [];

  for (var product in queryProducts.docs) {
    Map<String, dynamic> productData = {
      ...product.data() as Map<String, dynamic>,
      'id': product.id,
    };
    if (productData['quantity'] == 0) {
      await product.reference.delete();
    } else {
      products.add(ProductItem.getFromFirebase(productData));
    }
  }

  return products;
}

Future<void> addProductToShoppingCart(ProductItem productItem) async {
  CollectionReference shoppingCart = db.collection("shoppingcart");

  QuerySnapshot querySnapshot =
      await shoppingCart.where('id', isEqualTo: productItem.id).get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentReference docRef = querySnapshot.docs.first.reference;
    await docRef.update({'quantity': FieldValue.increment(1)});
  } else {
    await shoppingCart.add(productItem.toMap());
  }
}

Future<void> decrementProductFromShoppingCart(String productId) async {
  CollectionReference products = db.collection("shoppingcart");
  DocumentSnapshot productDoc = await products.doc(productId).get();
  if (productDoc.exists) {
    int currentQuantity = productDoc['quantity'];
    if (currentQuantity > 0) {
      await products.doc(productId).update({
        'quantity': FieldValue.increment(-1),
      });
    }
  }
}
