import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/login_page.dart';

class ModifyPassForm extends StatefulWidget {
  const ModifyPassForm({super.key});

  @override
  ModifyPassFormState createState() {
    return ModifyPassFormState();
  }
}

class ModifyPassFormState extends State<ModifyPassForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Confirm Password'),
          ),
          TextFormField(
            controller: confirmePasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirm Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              //compare with database
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  if (passwordController.text ==
                      confirmePasswordController.text) {
                    try {
                      //db insert new password
                      Get.to(LoginPage());
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Passwords do not match')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter new password')));
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
