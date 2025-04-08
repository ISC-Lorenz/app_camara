import 'dart:convert';
import 'dart:io';

import 'package:app_camara/camera_test/models/product.dart';
import 'package:app_camara/camera_test/providers/products_provider.dart';
import 'package:app_camara/camera_test/services/firebase_transactions.dart';
import 'package:app_camara/camera_test/widgets/components/circle_avatar.component.dart';
import 'package:app_camara/camera_test/widgets/components/product_data_component.dart';
import 'package:app_camara/camera_test/widgets/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductInfoScreen extends StatefulWidget {
  const ProductInfoScreen({super.key});

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  final txtProductName = TextEditingController();
  final txtProductPrice = TextEditingController();
  final txtProductStock = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? _image;
  String url = 'Sin URL';
  @override
  Widget build(BuildContext context) {
    final String idProduct = context.watch<ProductsProvider>().idProduct;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: getProductById(idProduct),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product product = snapshot.data as Product;
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Estas editando: ${product.id}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            children: [
                              CircleAvatarComponent(
                                sizeCircle: 40,
                                product: product,
                              ),
                              ProductDataComponent(product: product),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextBoxWidget(
                        field: 'nombre del producto',
                        txtcontroller: txtProductName,
                        iconText: Icons.shopping_cart,
                        inputType: TextInputType.text,
                        isPassword: false,
                        txtTitle: 'Nombre del producto',
                      ),
                      TextBoxWidget(
                        field: 'precio del producto',
                        txtcontroller: txtProductPrice,
                        iconText: Icons.attach_money_outlined,
                        inputType: TextInputType.text,
                        isPassword: false,
                        txtTitle: 'Precio del producto',
                      ),
                      TextBoxWidget(
                        field: 'stock del producto',
                        txtcontroller: txtProductStock,
                        iconText: Icons.add_business,
                        inputType: TextInputType.text,
                        isPassword: false,
                        txtTitle: 'Stock del producto',
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Column(
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                await selectImageFromGalery();
                              },
                              child: Text('Seleccionar Imagen'),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 100,
                                    child: ClipOval(
                                      child:
                                          _image != null
                                              ? Image.file(
                                                _image!,
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              )
                                              : Icon(Icons.add_a_photo),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      MaterialButton(
                        color: Colors.green.shade100,
                        elevation: 4,

                        child: const Text("Actualizar"),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            SmartDialog.showLoading(
                              msg: 'Subiendo producto...',
                            );
                            final urlCloudinary = Uri.parse(
                              'https://api.cloudinary.com/v1_1/dfoqhww2b/upload',
                            );
                            final request =
                                http.MultipartRequest('POST', urlCloudinary)
                                  ..fields['upload_preset'] = 'jq7b2025'
                                  ..files.add(
                                    await http.MultipartFile.fromPath(
                                      'file',
                                      _image!.path,
                                    ),
                                  );
                            final response = await request.send();
                            if (response.statusCode == 200) {
                              final responseData =
                                  await response.stream.bytesToString();
                              final json = jsonDecode(responseData);
                              setState(() {
                                url = json['url'];
                                SmartDialog.dismiss();
                              });
                            } else {
                              url = 'Error al subir imagen';
                            }
                            Product updatedProduct = Product(
                              id: product.id,
                              name: txtProductName.text,
                              price: double.parse(txtProductPrice.text),
                              stock: int.parse(txtProductStock.text),
                              img: url,
                            );
                            updateProduct(updatedProduct).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Producto actualizado')),
                              );
                              // Navigator.pop(context, '/');
                              Navigator.of(
                                context,
                              ).pushNamedAndRemoveUntil('/', (route) => false);
                              // Navigator.pop(context, true);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: const CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }

  Future selectImageFromGalery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture == null) return;
    setState(() {
      _image = File(picture.path);
    });
  }
}
