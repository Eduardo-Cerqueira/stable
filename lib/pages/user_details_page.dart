import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/models/horse.dart';
import 'package:stable/pages/list_horse.dart';
import 'package:stable/pages/user_horses_detail.dart';
import 'package:stable/persistance/repository.dart';
import 'package:stable/models/user.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  UserDetailsPageState createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController ffeLinkController = TextEditingController();
  TextEditingController horseController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    ageController.dispose();
    ffeLinkController.dispose();
    horseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String userData = '''{
      "_id": "65314582cb18c29ab0d68b26",
      "profilePicture":
          "",
      "username": "",
      "password": "",
      "email": ""
    }''';

    final User user = User.fromJson(jsonDecode(userData));

    usernameController.text = user.username;
    if (user.phoneNumber != null) {
      phoneNumberController.text = user.phoneNumber.toString();
    }
    if (user.age != null) ageController.text = user.age.toString();

    if (user.ffeLink != null) {
      ffeLinkController.text = user.ffeLink.toString();
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                child: ElevatedButton(
                  child: const Icon(Icons.update),
                  onPressed: () {
                    updateUsername(user);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone number'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                child: ElevatedButton(
                  child: user.phoneNumber == null
                      ? const Icon(Icons.create)
                      : const Icon(Icons.update),
                  onPressed: () {
                    updatePhoneNumber(user);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                child: ElevatedButton(
                  child: user.age == null
                      ? const Icon(Icons.create)
                      : const Icon(Icons.update),
                  onPressed: () {
                    updateAge(user);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ffeLinkController,
                decoration: const InputDecoration(labelText: 'FFE Link'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                child: ElevatedButton(
                  child: user.ffeLink == null
                      ? const Icon(Icons.create)
                      : const Icon(Icons.update),
                  onPressed: () {
                    updateFFELink(user);
                  },
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10), child: Text("Cheval:")),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      child: const Text("I'am a half-boarder"),
                      onPressed: () => (Get.to(const UserHorses()))),
                  TextButton(
                      child: const Text("I'am a owner"),
                      onPressed: () => Get.to(const ListHorses()))
                ]),
          ]))
        ],
      ),
    );
  }

  updateUsername(User user) async {
    await Collection.updateField(user, "username", usernameController.text);
  }

  updateAge(User user) async {
    await Collection.updateField(user, "age", ageController.text);
  }

  updatePhoneNumber(User user) async {
    await Collection.updateField(
        user, "phoneNumber", phoneNumberController.text);
  }

  updateFFELink(User user) async {
    await Collection.updateField(user, "ffeLink", ffeLinkController.text);
  }

  Future<List<Horse>> listHorses() async =>
      await Collection.getHorseDocuments();

  listUserHalfBoarderHorses(User user) async =>
      await Collection.getUserHalfBoarderHorse(user);
}
