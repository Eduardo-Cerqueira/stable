import 'package:flutter/material.dart';
import 'package:stable/database/list_party_database.dart';

class ListeSoireesPage extends StatefulWidget {
  final String argument;

  ListeSoireesPage({Key? key, required this.argument}) : super(key: key);
  @override
  _ListeSoireesPageState createState() => _ListeSoireesPageState();
}

class _ListeSoireesPageState extends State<ListeSoireesPage> {
  List soirees = [];

  @override
  void initState() {
    super.initState();
    fetchSoireesFromDatabase();
  }

  Future<void> fetchSoireesFromDatabase() async {
    final soireesFromDb = await DatabaseHelper.fetchSoirees();
    setState(() {
      soirees = soireesFromDb;
    });
  }

  // Fonction pour afficher la boîte de dialogue
  Future<void> _showPartyDialog(BuildContext context, String soireeName) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Participer à la soirée $soireeName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Voulez-vous participer à cette soirée ?'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apportez quelque chose'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Traitez la réponse ici (ajoutez des données dans la base de données, etc.)
                Navigator.of(context).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Soirées'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: soirees.length,
              itemBuilder: (context, index) {
                final soiree = soirees[index];
                return ListTile(
                  title: Text(soiree['name']),
                  subtitle: Text(soiree['type']),
                  onTap: () {
                    _showPartyDialog(context, soiree['name']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
