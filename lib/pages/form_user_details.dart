import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stable/persistance/user_repository.dart';
import 'package:stable/models/user.dart';

class AddUserPage extends StatefulWidget {
  @override
  AddUserPageState createState() => AddUserPageState();
}

class AddUserPageState extends State<AddUserPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController ffeLinkController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String userData = '''{
      "_id": "",
      "profilePicture":
          "",
      "username": "",
      "password": "",
      "email": "",
      "phoneNumber": ""
    }''';

    final User user = User.fromJson(jsonDecode(userData));

    if (user != null) {
      usernameController.text = user.username;
      if (user.phoneNumber != null)
        phoneNumberController.text = user.phoneNumber.toString();
      if (user.age != null) ageController.text = user.age.toString();
      if (user.ffeLink != null)
        ffeLinkController.text = user.ffeLink.toString();
      print(usernameController);
    }
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
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
                      child: user.username == null
                          ? const Icon(Icons.create)
                          : const Icon(Icons.update),
                      onPressed: () {
                        if (user != null) {
                          updateUsername(user);
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: phoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone number'),
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
                        if (user != null) {
                          updatePhoneNumber(user);
                        }
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
                        if (user != null) {
                          updateAge(user);
                        }
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
                        if (user != null) {
                          updateFFELink(user);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  updateUsername(User user) async {
    await UserDatabase.updateField(user, "username", usernameController.text);
  }

  updateAge(User user) async {
    await UserDatabase.updateField(user, "age", ageController.text);
  }

  updatePhoneNumber(User user) async {
    await UserDatabase.updateField(
        user, "phoneNumber", phoneNumberController.text);
  }

  updateFFELink(User user) async {
    await UserDatabase.updateField(user, "ffeLink", ffeLinkController.text);
  }
}
