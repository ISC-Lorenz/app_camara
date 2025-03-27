import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String url = 'Sin URL';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo camera'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              MaterialButton(
                onPressed: () async {
                  await selectImageFromCamera();
                },
                color: Colors.green.shade500,
                child: const Text(
                  'Agregar foto',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 15),
              _image != null
                  ? Image.file(_image!)
                  : const Text('Imagen no seleccionada'),
              const SizedBox(height: 10),
              Text(
                'URL de la imagen: $url',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
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
                    final responseData = await response.stream.bytesToString();
                    final json = jsonDecode(responseData);
                    setState(() {
                      url = json['url'];
                    });
                  } else {
                    url = 'Error al subir imagen';
                  }
                },
                child: const Text('Subir imagen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future selectImageFromCamera() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picture == null) return;
    setState(() {
      _image = File(picture.path);
    });
  }

  Future selectImageFromGalery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture == null) return;
    setState(() {
      _image = File(picture.path);
    });
  }
}
