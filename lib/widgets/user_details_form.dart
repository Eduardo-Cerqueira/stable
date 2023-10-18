import 'package:flutter/material.dart';
import 'package:niku/namespace.dart' as n;

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phonenumberController = TextEditingController();
  final emailController = TextEditingController();

  stringValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter some text';
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          n.TextFormField()
            ..outlined
            ..maxLines = 1
            ..margin = const EdgeInsets.all(10)
            ..hintText = "Contact firstname"
            ..validator = (value) => stringValidator(value),
          n.TextFormField()
            ..outlined
            ..maxLines = 1
            ..margin = const EdgeInsets.all(10)
            ..hintText = "Contact lastname"
            ..controller = lastnameController
            ..validator = (value) => stringValidator(value),
          n.TextFormField()
            ..outlined
            ..maxLines = 1
            ..margin = const EdgeInsets.all(10)
            ..hintText = "Contact phone number"
            ..controller = phonenumberController
            ..validator = (value) => stringValidator(value),
          n.TextFormField()
            ..outlined
            ..maxLines = 1
            ..margin = const EdgeInsets.all(10)
            ..hintText = "Contact email"
            ..controller = emailController
            ..validator = (value) => stringValidator(value),
          n.IconButton(Icons.send_rounded)
            ..autofocus
            ..iconSize = 24
            ..highlightColor = Colors.blue.withOpacity(.10)
            ..splashColor = Colors.blue.withOpacity(.100)
            ..hoverColor = Colors.blue.withOpacity(.150)
            ..color = Colors.blue
            ..splashRadius = 30
            ..onPressed = () => ()
        ],
      ),
    ));
  }
}
