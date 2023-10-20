import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:stable/database/list_horses.dart';
import 'package:stable/pages/user_details_page.dart';
import 'package:stable/persistance/repository.dart';

class ListHorsesPage extends StatefulWidget {
  final dynamic user;
  const ListHorsesPage({super.key, required this.user});

  @override
  ListHorsesPageState createState() => ListHorsesPageState();
}

class ListHorsesPageState extends State<ListHorsesPage> {
  List<dynamic> horsesList = [];

  @override
  void initState() {
    super.initState();
    listHorses();
  }

  List<m.ObjectId> horses = [];

  listHorses() async {
    var horses = await ListHorses.fetchHorses();

    setState(() {
      horsesList = horses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () => Get.to(() => UserDetailsPage(user: widget.user)),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: horsesList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Column(children: [
                      ListTile(
                        title: Text(horsesList[index]["name"]),
                        subtitle: Text(horsesList[index]["stable"]),
                        tileColor: horsesList[index]["owner"] != null &&
                                horsesList[index]["owner"] == widget.user["_id"]
                            ? Colors.amber[50]
                            : Colors.white,
                        onTap: () {
                          if (horses.isEmpty ||
                              !horses.contains(horsesList[index]["_id"])) {
                            return horses.add(horsesList[index]["_id"]);
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
    await Collection.updateFieldHorse(horseId, "owner", widget.user["_id"]);
  }
}
