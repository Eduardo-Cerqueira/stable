import 'package:flutter/material.dart';
import 'package:stable/persistance/user_repository.dart';
import 'package:stable/widgets/user_details_form.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    setPhoneNumberField("652fe69fd9e48ce4ad21038c", "060606060606060665");
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MyCustomForm());
  }
}
