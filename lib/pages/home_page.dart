import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/profile.dart';
import 'package:stable/pages/user_details_page.dart';
import 'program_cours_page.dart';
import 'ManageCoursesPage.dart';
import 'ManageSoireesPage.dart';
import 'package:stable/pages/party_page.dart';
import 'package:stable/pages/party_list_page.dart';

class HomePage extends StatelessWidget {
  final dynamic user;
  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () => Get.to(() => const MyForm()),
              icon: const Icon(Icons.navigate_next))
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
            ListTile(
              title: const Text('Gérer les cours'),
              onTap: () {
                // Naviguez vers ManageCoursesPage
                Get.to(const ManageCoursesPage());
              },
            ),
            ListTile(
              title: const Text('Gérer les soirées'),
              onTap: () {
                // Naviguez vers ManageSoireesPage
                Get.to(() => const ManageSoireesPage());
              },
            ),
            ListTile(
              title: const Text('Organiser une soirée'),
              onTap: () {
                Get.to(() => PartyPage(user: user));
              },
            ),
            ListTile(
              title: const Text('Liste des soirées'),
              onTap: () {
                Get.to(() => ListeSoireesPage(user: user));
              },
            ),
            ListTile(
                title: const Text("Details de l'utilisateur"),
                onTap: () => Get.to(const UserDetailsPage())),
          ],
        ),
      ),
    );
  }
}
