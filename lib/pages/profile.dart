import 'dart:typed_data';
import 'package:flutter/material.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
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
      final String name = _nameController.text;
      final String mail = _mailController.text;
      final String password = _passwordController.text;
      insertUsers(_db,
          {"name": name, "mail": mail, "password": password, "image": _image});
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: "Nom d 'utilisateur"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre nom.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mailController,
                  decoration: const InputDecoration(labelText: "Adresse mail"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre mail.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Mot de passe"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre mot de passe.';
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
                    : const Text("veuillez selectionner une image"),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submit();
                    }
                  },
                  child: const Text('Envoyer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
