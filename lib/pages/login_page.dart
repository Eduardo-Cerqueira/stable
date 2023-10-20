import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/forgo_pass_page.dart';
import 'package:stable/pages/home_page.dart';
import 'package:stable/components/login.dart';

class LoginPage extends StatelessWidget {
  final String argument;
  LoginPage({super.key, required this.argument});
  final Controller c = Get.find();



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
            try{
              Get.to(const ForgoPassPage());
            } catch (e) {
              print(e);
            }
          },
          tooltip: 'Forgot Password',
          child: const Icon(Icons.restart_alt_sharp),
        )
      ),
    );
  }
}
