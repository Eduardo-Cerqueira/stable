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

  static Db get db => _db;
}

