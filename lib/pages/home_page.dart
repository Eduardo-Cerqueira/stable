import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/second_page.dart';

import 'program_cours_page.dart';

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
        leading: IconButton(
          onPressed: () => Get.to(SecondPage(
            argument: 'Welcome to page 2',
          )),
          icon: Icon(Icons.navigate_next),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Naviguez vers la page de programmation de cours
              Get.to(CourseForm());
            },
            icon: Icon(Icons.event), // Icône pour accéder à la programmation du cours
          ),
        ],
      ),
      body: Obx(() => Text("${c.count}")),
      floatingActionButton: FloatingActionButton(
        onPressed: c.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
