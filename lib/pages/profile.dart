import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/home_page.dart';
import '../database.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _photoController = TextEditingController();
var _db ; 
@override
  void initState() {
    super.initState();
    // Appel de la fonction connection pour obtenir la connexion à la base de données
    connection().then((db) {
      setState(() {
        _db = db;
      });
    });
  }

  void _submit() async {
    if(_db != null){
      final String name = _nameController.text;
      final String mail = _mailController.text;
      final String password = _passwordController.text;
      // var data = {"name": name, "mail" : mail , "password" : password};
      insertUsers(_db , {"name": name, "mail" : mail , "password" : password}); 
      print("monsieurWan");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nom d 'utilisateur"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre nom.';
                    }
                    return null;
                  },
                ),


                   TextFormField(
                  controller: _mailController,
                  decoration: InputDecoration(labelText: "Adresse mail"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre mail.';
                    }
                    return null;
                  },
                ),


                   TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Mot de passe"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre mot de passe.';
                    }
                    return null;
                  },
                ),

                

                   TextFormField(
                  controller: _photoController,
                  decoration: InputDecoration(labelText: "Photo de profile"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre photo.';
                    }
                    return null;
                  },
                ),





                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Le formulaire est valide, vous pouvez traiter les données ici
                      String name = _nameController.text;
                      // Faites quelque chose avec le nom, par exemple, l'imprimer
                      _submit();
                    }
                  },
                  child: Text('Envoyer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}