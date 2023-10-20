import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;
import 'package:stable/.env.dart';

class ManageCoursesPage extends StatefulWidget {
  final dynamic user;
  const ManageCoursesPage({super.key, required this.user});

  @override
  _ManageCoursesPageState createState() => _ManageCoursesPageState();
}

class _ManageCoursesPageState extends State<ManageCoursesPage> {
  List<Map<String, dynamic>>? courses;

  @override
  void initState() {
    super.initState();
    _fetchAllCourses();
  }

  Future<void> _fetchAllCourses() async {
    var db = mdb.Db(MONGO_URL);
    await db.open();

    var collection = db.collection('cours');
    List coursesData = await collection.find().toList();

    setState(() {
      courses = coursesData.cast<Map<String, dynamic>>();
    });

    await db.close();
  }

  String extractObjectId(String rawId) {
    var matches = RegExp(r'ObjectId\("([a-fA-F0-9]{24})"\)').firstMatch(rawId);
    return matches?.group(1) ?? '';
  }

  Future<void> _updateCourseStatus(String id, String status) async {
    var db = mdb.Db(MONGO_URL);
    await db.open();

    var hexId = extractObjectId(id);

    var collection = db.collection('cours');
    await collection
        .update(mdb.where.eq("_id", mdb.ObjectId.fromHexString(hexId)), {
      '\$set': {'status': status}
    });

    await db.close();

    // Refresh the list
    _fetchAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les cours')),
      body: courses == null
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: courses!.length,
              itemBuilder: (context, index) {
                var course = courses![index];

                Color? tileColor;
                List<Widget> actions = []; // Boutons d'action

                switch (course['status']) {
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
                          _updateCourseStatus(
                              course['_id'].toString(), 'ACCEPTED');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text('Valider'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _updateCourseStatus(
                              course['_id'].toString(), 'REJECTED');
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
                      'Date: ${course['date']}, Terrain: ${course['terrain']}, Discipline: ${course['discipline']}'),
                  subtitle:
                      Text('De ${course['startTime']} à ${course['endTime']}'),
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
