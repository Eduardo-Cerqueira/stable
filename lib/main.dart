import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:stable/Database/db_connection_v2.dart';
import 'package:stable/pages/home_page.dart';

Future<void> main() async {
  var db = await MongoDataBase.connect();
  runApp(const GetMaterialApp(
      debugShowCheckedModeBanner: false, 
      home: HomePage()));
}

