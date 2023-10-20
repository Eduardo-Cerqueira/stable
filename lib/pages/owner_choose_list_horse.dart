import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:stable/models/horse.dart';
import 'package:stable/models/user.dart';
import 'package:stable/pages/user_details_page.dart';
import 'package:stable/persistance/repository.dart';

class ListHorses extends StatefulWidget {
  final String? stableId;
  const ListHorses({super.key, this.stableId});

  @override
  ListHorsesState createState() => ListHorsesState();
}

class ListHorsesState extends State<ListHorses> {
  List<Horse> horsesList = [];
  String userData = '''{
      "_id": "65314582cb18c29ab0d68b26",
      "profilePicture":
          "",
      "username": "",
      "password": "",
      "email": ""
    }''';

  @override
  void initState() {
    super.initState();
    listUserHorses();
  }

  List<m.ObjectId> horses = [];

  listUserHorses() async {
    var horsesForStable;
    widget.stableId != null
        ? horsesForStable =
            await Collection.getHorsesStable(widget.stableId.toString())
        : horsesForStable = await Collection.getHorseDocuments();

    setState(() {
      horsesList = horsesForStable;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = User.fromJson(jsonDecode(userData));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () => Get.to(() => const UserDetailsPage()),
              icon: const Icon(Icons.navigate_next)),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: horsesList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Column(children: [
                      ListTile(
                        title: Text(horsesList[index].name),
                        subtitle: Text(horsesList[index].sex),
                        tileColor: horsesList[index].owner != null &&
                                horsesList[index].owner == user.id
                            ? Colors.amber[50]
                            : Colors.white,
                        leading: Image.memory(const Base64Decoder()
                            .convert(horsesList[index].picture)),
                        onTap: () {
                          if (horses.isEmpty ||
                              !horses.contains(horsesList[index].id)) {
                            return horses.add(horsesList[index].id);
                          }
                        },
                      )
                    ]));
                  }))
        ]),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () => {
                  for (var horse in horses) {updateHorseOwner(horse)}
                }));
  }

  updateHorseOwner(
    m.ObjectId horseId,
  ) async {
    await Collection.updateFieldHorse(
        horseId, "owner", User.fromJson(jsonDecode(userData)).id.toString());
  }
}
