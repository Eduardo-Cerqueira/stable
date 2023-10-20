import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/forgo_pass_page.dart';
import 'package:stable/components/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Login'),
          ),
          body: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginForm(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              try {
                Get.to(const ForgoPassPage());
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            },
            tooltip: 'Forgot Password',
            child: const Icon(Icons.restart_alt_sharp),
          )),
    );
  }
}
