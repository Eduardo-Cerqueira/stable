import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/add_horse.dart';
import 'package:stable/pages/owner_choose_list_horse.dart';
import 'package:stable/pages/profile.dart';
import 'package:stable/pages/user_details_page.dart';
import '../.env.dart';
import 'program_cours_page.dart';
import 'ManageCoursesPage.dart';
import 'ManageSoireesPage.dart';
import 'package:stable/pages/party_page.dart';
import 'package:stable/pages/party_list_page.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class Controller extends GetxController {
  var count = 0.obs;
  increment() => count++;
  String getUserId() {
    return "65318bc3756ac26b2f770d8a";
  }
}
class User {
  final String id;
  final String name;
  final String role;

  User({required this.id, required this.name, required this.role});
}

class HomePage extends StatelessWidget {
  final dynamic user;

  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    bool isManager = user["isManager"] ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () => Get.to(() => const MyForm()),
              icon: const Icon(Icons.navigate_next)
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Text("${user["name"]}"),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Programmer un cours'),
              onTap: () {
                // Naviguez vers la page de programmation de cours
                Get.to(const CourseForm());
              },
            ),
            if(isManager) // Si l'utilisateur est un gérant, montrez-lui les options de gestion
              ...[
                ListTile(
                  title: const Text('Gérer les cours'),
                  onTap: () {
                    Get.to(const ManageCoursesPage());
                  },
                ),
                ListTile(
                  title: const Text('Gérer les soirées'),
                  onTap: () {
                    Get.to(() => const ManageSoireesPage());
                  },
                ),
              ],
            ListTile(
              title: const Text('Organiser une soirée'),
              onTap: () {
                Get.to(() => PartyPage(user: user));
              },
            ),
            ListTile(
              title: const Text('Liste des soirées'),
              onTap: () => Get.to(() => ListeSoireesPage(user: user)),
            ),
            ListTile(
                title: const Text("Details de l'utilisateur"),
                onTap: () => Get.to(const UserDetailsPage())),
            ListTile(
                title: const Text("Ajouter un cheval"),
                onTap: () => Get.to(AddHorse(user: user))),
            ListTile(
                title: const Text("Liste des chevaux"),
                onTap: () => Get.to(ListHorsesPage(user: user)))
          ],
        ),
      ),
    );
  }
}
