import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/forgo_pass_page.dart';
import 'package:stable/components/login.dart';
import 'package:stable/pages/profile.dart';

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LoginForm(),
              TextButton(
                child: const Text('Forgot Password?'),
                onPressed: () {
                  try{
                    Get.to(const ForgoPassPage());
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                }
              ),
            ],
            
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              try {
                Get.to(() => const MyForm());
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            },
            tooltip: 'Forgot Password',
            child: const Icon(Icons.person_add_sharp),
          )),
    );
  }
}
