import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/home_page.dart';
import 'package:stable/pages/list_horse_page.dart';
import 'package:stable/pages/user_horses_detail.dart';
import 'package:stable/persistance/repository.dart';

class UserDetailsPage extends StatefulWidget {
  final dynamic user;
  const UserDetailsPage({super.key, required this.user});

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
    if (widget.user != null) {
      if (widget.user["username"] != null) {
        usernameController.text = widget.user["username"];
      }

      if (widget.user["phoneNumber"] != null) {
        phoneNumberController.text = widget.user["phoneNumber"];
      }
      if (widget.user["age"] != null) ageController.text = widget.user["age"];

      if (widget.user["ffeLink"] != null) {
        ffeLinkController.text = widget.user["ffeLink"];
      }
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () => Get.to(() => HomePage(user: widget.user)),
              icon: const Icon(Icons.arrow_back))),
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
                    updateUsername(widget.user["_id"]);
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
                  child:
                      widget.user != null && widget.user["phoneNumber"] == null
                          ? const Icon(Icons.create)
                          : const Icon(Icons.update),
                  onPressed: () {
                    updatePhoneNumber(widget.user["phoneNumber"]);
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
                  child: widget.user != null && widget.user["age"] == null
                      ? const Icon(Icons.create)
                      : const Icon(Icons.update),
                  onPressed: () {
                    updateAge(widget.user["_id"]);
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
                  child: widget.user != null && widget.user["ffeLink"] == null
                      ? const Icon(Icons.create)
                      : const Icon(Icons.update),
                  onPressed: () {
                    updateFFELink(widget.user["_id"]);
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
                      onPressed: () =>
                          Get.to(() => UserHorses(user: widget.user))),
                  TextButton(
                      child: const Text("I'am a owner"),
                      onPressed: () => Get.to(ListHorsesPage(
                            user: widget.user,
                          )))
                ]),
          ]))
        ],
      ),
    );
  }

  updateUsername(userId) async {
    await Collection.updateField(userId, "username", usernameController.text);
  }

  updateAge(user) async {
    await Collection.updateField(user, "age", ageController.text);
  }

  updatePhoneNumber(userId) async {
    await Collection.updateField(
        userId, "phoneNumber", phoneNumberController.text);
  }

  updateFFELink(user) async {
    await Collection.updateField(user, "ffeLink", ffeLinkController.text);
  }

  listHorses() async => await Collection.getHorseDocuments();

  listUserHalfBoarderHorses(user) async =>
      await Collection.getUserHalfBoarderHorse(user);
}
