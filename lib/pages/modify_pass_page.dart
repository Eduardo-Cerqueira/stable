import 'package:flutter/material.dart';
import 'package:stable/components/modify_pass.dart';

class ModifyPassPage extends StatelessWidget {
  final dynamic user;
  const ModifyPassPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text('Change Password'),
          ),
          body: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModifyPassForm(),
            ],
          ),
        ));
  }
}
