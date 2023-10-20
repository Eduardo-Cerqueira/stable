import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/login_page.dart';
import '../database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mongo_dart/mongo_dart.dart'
    show GridFS; // Importation de la classe Db et GridFS

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  File? _selectedImage;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _db;
  GridFS? bucket;
  var flag = false;
  late ImageProvider provider;
  var _image;

  @override
  void initState() {
    super.initState();
    // Appel de la fonction connection pour obtenir la connexion à la base de données
    connection().then((db) {
      bucket = GridFS(db, "image");
      setState(() {
        _db = db;
      });
    });
  }

  void _submit() async {
    if (_db != null) {
      final String username = _usernameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      insertUsers(_db, {
        "username": username,
        "email": email,
        "password": password,
        "image": _image
      });
    } else {
      print("noDB");
    }
  }

  Future pickImageFromGallery() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (returnedImage != null) {
        Uint8List? cmpressedImage;
        try {
          cmpressedImage = await FlutterImageCompress.compressWithFile(
              returnedImage.path,
              format: CompressFormat.heic,
              quality: 70);
        } catch (e) {
          cmpressedImage = await FlutterImageCompress.compressWithFile(
              returnedImage.path,
              format: CompressFormat.jpeg,
              quality: 70);
        }
        Map<String, dynamic> image = {
          "_id": returnedImage.path.split("/").last,
          "data": base64Encode(cmpressedImage!)
        };

        await bucket?.chunks.insert(image);
        setState(() {
          _image = returnedImage.path.split("/").last;
          _selectedImage = File(returnedImage.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Register"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration:
                      const InputDecoration(labelText: "Username"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration:
                      const InputDecoration(labelText: "E-mail Address"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your e-mail address.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password.';
                    }
                    return null;
                  },
                ),
                MaterialButton(
                    color: Colors.blue,
                    child: const Text("Pick Image from Gallery",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      pickImageFromGallery();
                    }),
                MaterialButton(
                    color: Colors.blue,
                    child: const Text("Pick Image from Camera",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      pickImageFromCamera();
                    }),
                _selectedImage != null
                    ? Image.file(_selectedImage!,
                        width: 150, height: 150, fit: BoxFit.cover)
                    : const Text("Please pick an image"),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submit();
                      Get.to(const LoginPage());
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
