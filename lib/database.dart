import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDatabase {
  static late Db _db;

  static Future<bool> connect() async {
    try {
      _db = Db(MONGO_URL);
      await _db.open();
      if (kDebugMode) {
        print('Connected to MongoDB !');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to MongoDB: $e');
      }
      return false;
    }
  }

  static Future<void> listCollections() async {
    try {
      var collections = await _db.getCollectionNames(); // Récupère les noms des collections
      if (kDebugMode) {
        print('Collections in DB:');
        for (var collection in collections) {
          print(collection); // Affiche le nom de chaque collection
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error listing collections: $e');
      }
    }
  }

  static Db get db => _db;
}
