import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/database.dart';
import 'package:stable/pages/home_page.dart';
import 'package:stable/pages/owner_choose_list_horse.dart';

class AddHorse extends StatefulWidget {
  final dynamic user;
  const AddHorse({super.key, required this.user});

  @override
  AddHorseState createState() => AddHorseState();
}

class AddHorseState extends State<AddHorse> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _coatController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _stableController = TextEditingController();

  var _db;

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
    if (_db != null) {
      final String name = _nameController.text;
      final String age = _ageController.text;
      final String sex = _sexController.text;
      final String coat = _coatController.text;
      final String breed = _breedController.text;
      final String stable = _stableController.text;

      insertHorse(_db, {
        "name": name,
        "age": age,
        "sex": sex,
        "coat": coat,
        "breed": breed,
        "stable": stable
      });
    } else {
      print("noDB");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create horse'),
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () => Get.to(() => HomePage(user: widget.user)),
              icon: const Icon(Icons.navigate_next))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nom"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer le nom du cheval.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veuillez entrer l'age du cheval.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _sexController,
                  decoration: const InputDecoration(labelText: "Sexe"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer le sexe du cheval.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _coatController,
                  decoration: const InputDecoration(labelText: "Robe"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer la robe du cheval.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(labelText: "Race"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer la race du cheval.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stableController,
                  decoration: const InputDecoration(labelText: "Étable"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veuillez entrer l'étable du cheval.";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submit();
                      Get.to(() => ListHorsesPage(user: widget.user));
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
