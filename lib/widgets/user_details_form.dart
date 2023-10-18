import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:niku/namespace.dart' as n;
import 'package:stable/persistance/user_repository.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phonenumberController = TextEditingController();
  final ageController = TextEditingController();
  final linkController = TextEditingController();

  stringValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter some text';
    return null;
  }

  optionalPhoneNumberValidator(String? value) {
    if (value != null && (value.isEmpty || !value.isPhoneNumber)) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  optionalAgeValidator(String? value) {
    // https://en.wikipedia.org/wiki/Life_expectancy
    if (value != null && int.parse(value) > 122) {
      return 'Entered age is too high';
    }
    return null;
  }

  optionalLinkValidator(String? value) {
    if (value != null && (value.isEmpty || !value.isURL)) {
      return "Please enter a valid link/url";
    }
    return null;
  }

  initialValue(Map<String, dynamic>? user, String field) {
    if (user != null && user[field]) return user[field];
    return null;
  }

  Map<String, dynamic>? user;
  @override
  void initState() {
    super.initState();
    getOneUser().then((fetchedUser) => setState(() {
          user = fetchedUser;
        }));
  }

  bool isValidated = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(children: <Widget>[
        n.TextFormField()
          ..outlined
          ..maxLines = 1
          ..margin = const EdgeInsets.all(10)
          ..hintText = "Nom d'utilisateur"
          ..initialValue = initialValue(user, "username")
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
          ..hintText = "Numéro de téléphone"
          ..controller = phonenumberController
          ..keyboardType = TextInputType.phone
          ..validator = (value) => optionalPhoneNumberValidator(value),
        n.TextFormField()
          ..outlined
          ..maxLines = 1
          ..margin = const EdgeInsets.all(10)
          ..hintText = "Age"
          ..controller = ageController
          ..keyboardType = TextInputType.number
          ..inputFormatters = [FilteringTextInputFormatter.digitsOnly]
          ..onSaved
          ..validator = (value) => optionalAgeValidator(value),
        n.TextFormField()
          ..outlined
          ..maxLines = 1
          ..margin = const EdgeInsets.all(10)
          ..hintText = "FFE Link"
          ..controller = linkController
          ..onSaved
          ..validator = (value) => optionalLinkValidator(value),
        n.Button.elevated(isValidated
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ))
            : n.Icon(Icons.send))
          ..onPressed = () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                isValidated = !isValidated;
              });

              if (user != null) print("User " + user?["_id"]);
              /*setAgeField(user?["_id"], ageController.toString());
              setPhoneNumberField(
                  user?["_id"], phonenumberController.toString());
              setProfileLinkField(user?["_id"], linkController.toString());*/

              Get.snackbar(
                  "⚠️ Do not leave this page", "User data is being updated");
            }
          }
      ]),
    ));
  }
}
