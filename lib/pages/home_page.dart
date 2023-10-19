import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/profile.dart';
import 'program_cours_page.dart';
import 'ManageCoursesPage.dart';
import 'ManageSoireesPage.dart';

class Controller extends GetxController {
  var count = 0.obs;
  increment() => count++;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => MyForm()),
            icon: const Icon(Icons.navigate_next))
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      
      body: Obx(() => Text("${c.count}")),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: c.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      
    );
    
  }
}
