import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:stable/pages/user_details.dart';

void main() async {
  runApp(
      const GetMaterialApp(debugShowCheckedModeBanner: false, home: UserDetails()));
}
