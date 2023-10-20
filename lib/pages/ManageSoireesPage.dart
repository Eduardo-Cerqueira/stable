import 'package:flutter/material.dart';
import 'package:stable/.env.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class ManageSoireesPage extends StatefulWidget {
  final dynamic user;
  const ManageSoireesPage({super.key, required this.user});

  @override
  _ManageSoireesPageState createState() => _ManageSoireesPageState();
}

String extractObjectId(String rawId) {
  var matches = RegExp(r'ObjectId\("([a-fA-F0-9]{24})"\)').firstMatch(rawId);
  return matches?.group(1) ?? '';
}

class _ManageSoireesPageState extends State<ManageSoireesPage> {
  List<Map<String, dynamic>>? soirees;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchAllSoirees();
  }

  Future<void> _fetchAllSoirees() async {
    var db = mdb.Db(MONGO_URL);
    await db.open();

    var collection = db.collection('soirees_evenements');
    List soireesData = await collection.find().toList();

    setState(() {
      soirees = soireesData.cast<Map<String, dynamic>>();
    });

    await db.close();
  }

  Future<void> _updateSoireeStatus(String id, String status) async {
    setState(() {
      isUpdating = true; // Début de la mise à jour
    });

    var db = mdb.Db(MONGO_URL);
    await db.open();

    var collection = db.collection('soirees_evenements');
    var hexId = extractObjectId(id);

    await collection
        .update(mdb.where.eq("_id", mdb.ObjectId.fromHexString(hexId)), {
      '\$set': {'status': status}
    });

    await db.close();

    // Refresh the list
    _fetchAllSoirees().then((_) {
      setState(() {
        isUpdating = false; // Fin de la mise à jour
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les soirées')),
      body: soirees == null
          ? const Center(child: CircularProgressIndicator())
          : isUpdating
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: soirees!.length,
                  itemBuilder: (context, index) {
                    var soiree = soirees![index];
                    Color? tileColor;
                    List<Widget> actions = []; // Boutons d'action

                    switch (soiree['status']) {
                      case 'ACCEPTED':
                        tileColor = Colors.green[100]; // vert pour validé
                        actions.add(
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text('Validé'),
                          ),
                        );
                        break;
                      case 'REJECTED':
                        tileColor = Colors.red[100]; // rouge pour refusé
                        actions.add(
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Refusé'),
                          ),
                        );
                        break;
                      default:
                        tileColor = Colors.grey[100]; // gris pour en attente
                        actions.addAll([
                          ElevatedButton(
                            onPressed: () {
                              _updateSoireeStatus(
                                  soiree['_id'].toString(), 'ACCEPTED');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text('Valider'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              _updateSoireeStatus(
                                  soiree['_id'].toString(), 'REJECTED');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Refuser'),
                          ),
                        ]);
                    }

                    return ListTile(
                      tileColor: tileColor,
                      title: Text(
                          '${soiree['name']} le ${soiree['date'].toLocal()}'),
                      subtitle: Text('Créateur: ${soiree['createur']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions,
                      ),
                    );
                  },
                ),
    );
  }
}
