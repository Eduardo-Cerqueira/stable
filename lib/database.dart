import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:stable/.env.dart';

connection() async {
  var db = await Db.create(MONGO_URL);

  // var db = Db.pool([
  //     connectionString,
  // ]);
  // await db.open();

  // GridFS bucket = GridFS(db,"image");

  await db.open(secure: true);

  print("Connected to database");

  return db;
}

main() async {
  try {
    var db = await connection();
    insertUser(db, {"name": "keke", "age": 23});
    print("inserted");
  } catch (e) {
    print(e);
  }
  // getUsers(db);
  // getUsersByName(db , "wanwan");
}

getUsers(db) async {
  var collection = db.collection('users');

  var users = await collection.find().toList();

  print(users);

  return users;
}

getHorses(db) async {
  var collection = db.collection('horses');

  var horses = await collection.find().toList();

  print(horses);

  return horses;
}

getUsersByName(db, name) async {
  var collection = db.collection('users');

  var users = await collection.find(where.eq('name', name)).toList();

  print(users);

  return users;
}

Future<void> insertUser(db, Map<String, dynamic> userData) async {
  final collection = db.collection('users');

  await collection.insert(userData);

  await db.close();
}

Future<void> insertHorse(db, Map<String, dynamic> horse) async {
  final collection = db.collection('horses');

  await collection.insert(horse);

  await db.close();
}

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
      var collections =
          await _db.getCollectionNames(); // Récupère les noms des collections
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
