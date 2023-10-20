import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/pages/modify_pass_page.dart';

class ForgoPassForm extends StatefulWidget {
  const ForgoPassForm({Key? key}) : super(key: key);

  @override
  ForgoPassFormState createState() {
    return ForgoPassFormState();
  }
}

class ForgoPassFormState extends State<ForgoPassForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Username'),
          ),
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              //compare with database
              return null;
            },
          ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var dbUser = 'email'; //db.findUser(emailController.text);
                  var user = dbUser;
                  if (emailController.text == dbUser &&
                      usernameController.text == user) {
                    // if ok then go to home page
                    Get.to(() => ModifyPassPage(user: user));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid Credentials')),
                    );
                  }
                } else {
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
