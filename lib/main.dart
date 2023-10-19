import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:stable/pages/user_details_page.dart';
import 'package:stable/persistance/repository.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure dart and flutter engine are connected
  await Collection.connect();
  runApp(const GetMaterialApp(
      debugShowCheckedModeBanner: false, home: UserDetailsPage()));
}
