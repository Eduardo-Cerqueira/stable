import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:stable/pages/login_page.dart';
import 'package:stable/persistance/repository.dart';
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var isConnected =
      await MongoDatabase.connect(); // Établissez la connexion à MongoDB
  await Collection.connect();
  if (isConnected) {
    await MongoDatabase
        .listCollections(); // Ajoutez cette ligne pour lister les collections
    runApp(const GetMaterialApp(
        debugShowCheckedModeBanner: false, home: LoginPage()));
  } else {
    if (kDebugMode) {
      print("Failed to connect to MongoDB");
    }
  }
}
