import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/login_page.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  LogoutFormState createState() {
    return LogoutFormState();
  }
}

class LogoutFormState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextButton(
        child: const Text('Logout'),
        onPressed: () {
          // db.close(),
          Get.to(const LoginPage());
        },
      ),
    );
  }
}
