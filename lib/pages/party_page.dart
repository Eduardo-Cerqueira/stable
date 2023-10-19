import 'package:flutter/material.dart';
import 'package:stable/database/create_party.dart';
import 'package:get/get.dart';
import 'package:stable/pages/party_list_page.dart';

class PartyPage extends StatefulWidget {
  final String argument;

  PartyPage({Key? key, required this.argument}) : super(key: key);

  @override
  _PartyPageState createState() => _PartyPageState();
}

class _PartyPageState extends State<PartyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nomSoireeController = TextEditingController();
  bool isAperoSelected = false;
  bool isRepasSelected = false;
  String typeSoiree = '';
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ))!;

    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      _formKey.currentState!.save();

      // Utilisez les valeurs des booléens pour déterminer quelles options ont été sélectionnées
      if (isAperoSelected) {
        typeSoiree = 'soireeApero';
      }
      if (isRepasSelected) {
        typeSoiree = 'soireeRepas';
      }

      print(typeSoiree);
      print(nomSoireeController.text);
      print(selectedDate); // Date sélectionnée par l'utilisateur

      // Connexion à la base de données et insertion du document avec les données du formulaire
      MongoDataBase.insertEvent(nomSoireeController.text, typeSoiree, selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Party Page'),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Champ de texte pour le nom de la soirée
                TextFormField(
                  controller: nomSoireeController,
                  decoration: InputDecoration(labelText: 'Nom de la soirée'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de soirée';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isAperoSelected,
                              onChanged: (value) {
                                setState(() {
                                  isAperoSelected = value ?? false;
                                });
                              },
                            ),
                            Image.asset('assets/apero.jpeg', width: 30, height: 30), // Remplacez par le chemin de votre image
                          ],
                        ),
                        Text('Apéro', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isRepasSelected,
                              onChanged: (value) {
                                setState(() {
                                  isRepasSelected = value ?? false;
                                });
                              },
                            ),
                            Image.asset('assets/repas.jpeg', width: 30, height: 30), // Remplacez par le chemin de votre image
                          ],
                        ),
                        Text('Repas', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text('Choisir la date de la soirée'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                    Get.to(ListeSoireesPage(argument: 'oui'));
                  },
                  child: Text('Créer la soirée'),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
