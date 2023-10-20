import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/add_horse.dart';
import 'package:stable/pages/list_horse_page.dart';
import 'package:stable/pages/login_page.dart';
import 'package:stable/pages/user_details_page.dart';
import 'program_cours_page.dart';
import 'ManageCoursesPage.dart';
import 'ManageSoireesPage.dart';
import 'package:stable/pages/party_page.dart';
import 'package:stable/pages/party_list_page.dart';

class HomePage extends StatelessWidget {
  final dynamic user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool isManager = user["isManager"] ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => Get.to(const LoginPage()),
            icon: const Icon(Icons.logout),
            color: Colors.red,
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
                Get.to(() => CourseForm(user: user));
              },
            ),
            if (isManager) // Si l'utilisateur est un gérant, montrez-lui les options de gestion
              ...[
              ListTile(
                title: const Text('Gérer les cours'),
                onTap: () {
                  Get.to(() => ManageCoursesPage(user: user));
                },
              ),
              ListTile(
                title: const Text('Gérer les soirées'),
                onTap: () {
                  Get.to(() => ManageSoireesPage(user: user));
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
                title: const Text("Ajouter un cheval"),
                onTap: () => Get.to(AddHorse(user: user))),
            ListTile(
                title: const Text("Liste des chevaux"),
                onTap: () => Get.to(ListHorsesPage(user: user))),
            ListTile(
                title: const Text("Details de l'utilisateur"),
                onTap: () => Get.to(UserDetailsPage(user: user)))
          ],
        ),
      ),
    );
  }
}
