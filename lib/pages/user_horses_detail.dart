import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/models/horse.dart';
import 'package:stable/models/user.dart';
import 'package:stable/pages/user_details_page.dart';
import 'package:stable/persistance/repository.dart';

class UserHorses extends StatefulWidget {
  final String? stableId;
  const UserHorses({super.key, this.stableId});

  @override
  UserHorsesState createState() => UserHorsesState();
}

class UserHorsesState extends State<UserHorses> {
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

  var horses = [];

  listUserHorses() async {
    var horsesForStable;
    widget.stableId != null
        ? horsesForStable =
            await Collection.getHorsesStable(widget.stableId.toString())
        : horsesForStable = await Collection.getUserHalfBoarderHorse(
            User.fromJson(jsonDecode(userData)));

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
                        textColor: horsesList[index].owner != null &&
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
                        }),
                  ]));
                }))
      ]),
    );
  }
}
