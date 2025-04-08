import 'package:app_camara/camera_test/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Future<List<Product>> getProducts() async {
//   CollectionReference colecction = db.collection("products");
//   QuerySnapshot queryProducts = await colecction.get();
//   List<Product> products =
//       queryProducts.docs
//           .map(
//             (product) =>
//                 Product.getFromFirebase(product.data() as Map<String, dynamic>),
//           )
//           .toList();
//   return products;
// }
Future<List<Product>> getProducts() async {
  CollectionReference colecction = db.collection("products");
  QuerySnapshot queryProducts = await colecction.get();
  List<Product> products =
      queryProducts.docs.map((product) {
        return Product.getFromFirebase({
          ...product.data() as Map<String, dynamic>,
          'id': product.id,
        });
      }).toList();
  return products;
}

Future<void> addProduct(Product product) async {
  CollectionReference colecction = db.collection("products");
  await colecction.add(product);
}

Future<void> addProductToFirestore(Product product) async {
  final collection = FirebaseFirestore.instance.collection('products');
  await collection.add(product.toMap());
}

Future<Product?> getProductByName(String name) async {
  CollectionReference collection = db.collection("products");
  QuerySnapshot querySnapshot =
      await collection.where('name', isEqualTo: name).get();
  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot productDoc = querySnapshot.docs.first;
    return Product.getFromFirebase({
      ...productDoc.data() as Map<String, dynamic>, // Datos del documento
      'id': productDoc.id, // Agrega el ID del documento
    });
  }
  return null;
}

Future<Product?> getProductById(String id) async {
  CollectionReference collection = db.collection("products");
  DocumentSnapshot productDoc = await collection.doc(id).get();
  if (productDoc.exists) {
    return Product.getFromFirebase({
      ...productDoc.data() as Map<String, dynamic>,
      'id': productDoc.id,
    });
  }
  return null;
}

Future<void> updateProduct(Product product) async {
  CollectionReference collection = db.collection("products");
  if (product.id != null) {
    DocumentReference docRef = collection.doc(product.id);
    await docRef.update(product.toMap());
  } else {
    throw Exception("El producto no tiene un ID válido para actualizar.");
  }
}

Future<void> addToCart(Product product, String oldProduct) async {
  CollectionReference colecction = db.collection("products");
  QuerySnapshot queryProducts =
      await colecction.where('name', isEqualTo: oldProduct).get();
  if (queryProducts.docs.isNotEmpty) {
    DocumentReference docRef = queryProducts.docs.first.reference;
    await docRef.update(product.toMap());
  }
}

Future<void> decrementProductStock(String productId) async {
  CollectionReference products = db.collection("products");
  DocumentSnapshot productDoc = await products.doc(productId).get();
  if (productDoc.exists) {
    int currentQuantity = productDoc['stock'];

    if (currentQuantity > 0) {
      await products.doc(productId).update({'stock': FieldValue.increment(-1)});
    }
  }
}

Future<void> incrementProductStock(String productName) async {
  CollectionReference products = db.collection("products");

  // Busca el producto por su nombre
  QuerySnapshot querySnapshot =
      await products.where('name', isEqualTo: productName).get();

  if (querySnapshot.docs.isNotEmpty) {
    // Obtén el primer documento que coincida con el nombre
    DocumentReference productDoc = querySnapshot.docs.first.reference;

    // Incrementa el stock en 1
    await productDoc.update({'stock': FieldValue.increment(1)});
  } else {
    throw Exception("No se encontró un producto con el nombre $productName.");
  }
}
