import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/DataBase/db_connection_v2.dart' as db;
import 'dart:developer' as dev;

import 'package:stable/pages/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
    

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('E-mail'),
              ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'E-mail',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an e-mail';
              }
              //compare with database
              return null;
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Password'),
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              //compare with database
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                    var dbUser = 'email'; //db.findUser(emailController.text);
                    var user = dbUser;
                  if (emailController.text == dbUser) {
                    // if ok then go to home page
                    var password = 'password'; //user.password;
                    if (passwordController.text == password) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Success')),
                      );
                      Get.to(const HomePage());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid Credentials')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid Credentials')
                        ),
                    );
                  }
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill input')),
                  );
                } 
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}