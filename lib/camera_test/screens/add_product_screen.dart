import 'dart:convert';
import 'dart:io';

import 'package:app_camara/camera_test/models/product.dart';
import 'package:app_camara/camera_test/services/firebase_transactions.dart';
import 'package:app_camara/camera_test/widgets/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final txtProductName = TextEditingController();
  final txtProductPrice = TextEditingController();
  final txtProductStock = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String url = 'Sin URL';
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo producto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
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
                color: Colors.green.shade500,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    SmartDialog.showLoading(msg: 'Subiendo producto...');
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

                    Product product = Product(
                      name: txtProductName.text,
                      price: double.parse(txtProductPrice.text),
                      stock: int.parse(txtProductStock.text),

                      img: url,
                    );

                    addProductToFirestore(product).then((_) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Producto agregado')),
                        );
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    });
                  }
                },
                child: Text(
                  'Agregar Producto',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
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
