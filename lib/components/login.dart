import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;
import 'package:stable/.env.dart';
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
  var user;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _fetchUserByEmail() async {
    var db = mdb.Db(MONGO_URL);
    await db.open();

    var collection = db.collection('users');
    var userData =
        await collection.findOne(mdb.where.eq("email", emailController.text));
    print(userData);

    setState(() {
      user = userData;
    });

    await db.close();
  }

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
                child: const Text('Submit'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _fetchUserByEmail();
                    if (user != null) {
                      if (emailController.text == user["email"]) {
                        // if ok then go to home page
                        if (passwordController.text != user["password"]) {
                          Get.snackbar('Error', 'Invalid Credentials',
                              backgroundColor: Colors.red[300]);
                        }
                        Get.to(() => HomePage(user: user));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill input')),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
