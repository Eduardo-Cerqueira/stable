import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/components/forgo_pass.dart';

class ForgoPassPage extends StatelessWidget {
  const ForgoPassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Forgot Password'),
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.navigate_next)),
          ),
          body: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ForgoPassForm(),
            ],
          )),
    );
  }
}
