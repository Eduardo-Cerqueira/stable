import 'package:flutter/material.dart';
import 'package:stable/database/create_party.dart';
import 'package:get/get.dart';
import 'package:stable/pages/home_page.dart';

class PartyPage extends StatefulWidget {
  final String userID; 

  const PartyPage({Key? key, required this.userID}) : super(key: key); 

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

  if (picked != selectedDate) {
    setState(() {
      selectedDate = DateTime(picked.year, picked.month, picked.day);
    });
  }
}


  void _submitForm() {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      _formKey.currentState!.save();

      if (isAperoSelected) {
        typeSoiree = 'soireeApero';
      }
      if (isRepasSelected) {
        typeSoiree = 'soireeRepas';
      }

      print(typeSoiree);
      print(nomSoireeController.text);
      print(selectedDate); 

      MongoDataBase.insertEvent(nomSoireeController.text, typeSoiree, selectedDate, widget.userID);

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
                            Image.asset('assets/apero.jpeg', width: 30, height: 30), 
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
                            Image.asset('assets/repas.jpeg', width: 30, height: 30), 
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
                    Get.to(HomePage());
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
