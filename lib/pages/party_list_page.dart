import 'package:flutter/material.dart';
import 'package:stable/database/list_party_database.dart';
import 'package:stable/database/party_actions.dart';

class ListeSoireesPage extends StatefulWidget {
  final String userID;

  ListeSoireesPage({Key? key, required this.userID}) : super(key: key);
  @override
  _ListeSoireesPageState createState() => _ListeSoireesPageState();
}

class _ListeSoireesPageState extends State<ListeSoireesPage> {
  List soirees = [];
  int selectedSoireeIndex = -1; 
  final TextEditingController itemToBringController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSoireesFromDatabase();
  }

  Future<void> fetchSoireesFromDatabase() async {
    final soireesFromDb = await ListParty.fetchSoirees();
    setState(() {
      soirees = soireesFromDb;
    });
  }

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
                controller: itemToBringController,
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
                selectedSoireeIndex = soirees.indexWhere((soiree) => soiree['name'] == soireeName);
                _addPartyItem(widget.userID);
                Navigator.of(context).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  void _addPartyItem(String userID) async {
  final itemToBring = itemToBringController.text;
  if (itemToBring.isNotEmpty && selectedSoireeIndex >= 0) {
    await PartyActions.bringItemToParty(soirees[selectedSoireeIndex]['name'], itemToBring, userID);
    itemToBringController.clear();
    // Rafraîchissez la liste des soirées après avoir ajouté l'élément.
    await fetchSoireesFromDatabase();
  }
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
                  subtitle: Text(
                          'Créateur: ${soiree['createur']},\nDate de création: ${soiree['date']},\nInscrits: ${soiree['items'].join(', ')}',
                        ),

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