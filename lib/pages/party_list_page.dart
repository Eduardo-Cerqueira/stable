import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:stable/database/list_party_database.dart';
import 'package:stable/database/party_actions.dart';

class ListeSoireesPage extends StatefulWidget {
  final dynamic user;

  const ListeSoireesPage({Key? key, required this.user}) : super(key: key);
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
              const Text('Voulez-vous participer à cette soirée ?'),
              TextFormField(
                controller: itemToBringController,
                decoration:
                    const InputDecoration(labelText: 'Apportez quelque chose'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                selectedSoireeIndex = soirees
                    .indexWhere((soiree) => soiree['name'] == soireeName);
                _addPartyItem(widget.user["_id"]);
                Navigator.of(context).pop();
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  void _addPartyItem(m.ObjectId userID) async {
    final itemToBring = itemToBringController.text;
    if (itemToBring.isNotEmpty && selectedSoireeIndex >= 0) {
      await PartyActions.bringItemToParty(
          soirees[selectedSoireeIndex]['name'], itemToBring, userID);
      itemToBringController.clear();
      // Rafraîchissez la liste des soirées après avoir ajouté l'élément.
      await fetchSoireesFromDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Soirées'),
      ),
      body: Column(
        children: [ListSoirees()],
      ),
    );
  }

  Widget ListSoirees() {
    return Expanded(
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
    );
  }
}
