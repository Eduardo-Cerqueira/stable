import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:stable/pages/home_page.dart';
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect(); // Établissez la connexion à MongoDB
  runApp(const GetMaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
}
