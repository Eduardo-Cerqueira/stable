import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/home_page.dart';

class SecondPage extends StatelessWidget {
  final String argument;
  SecondPage({super.key, required this.argument});

  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
                onPressed: () => Get.to(const HomePage()),
                icon: const Icon(Icons.navigate_next)),
          ),
          body: Center(child: Obx(() => Text("${c.count}"))),
          floatingActionButton: FloatingActionButton(
            onPressed: c.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          )),
    );
  }
}
