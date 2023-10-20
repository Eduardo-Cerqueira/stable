import 'package:flutter/material.dart';
import 'package:stable/components/modify_pass.dart';

class ModifyPassPage extends StatelessWidget {
  const ModifyPassPage({Key? key}) : super(key: key);
  
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
      )
    );
  }
}