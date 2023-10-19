import 'package:mongo_dart/mongo_dart.dart';
import 'package:stable/models/horse.dart';
import 'package:stable/models/user.dart';

String MONGO_CONN_URL = "mongodb://flutter:1234@172.21.0.2:27017/";

class Database {
  static dynamic getConnection() async {
    var db = await Db.create(MONGO_CONN_URL);
    final connection = db.open();
    print("🖴 Connected to database !");
    return connection;
  }
}

class Collection {
  static var db, userCollection, horseCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print("🖴 Connected to database !");
    userCollection = db.collection("user");
    horseCollection = db.collection("horse");
  }

  static Future<List<Map<String, dynamic>>?> getDocuments() async {
    try {
      final users = await userCollection.find().toList();
      return users;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static insert(User user) async {
    await userCollection.insertAll([user.toJson()]);
  }

  static updateField(User user, String field, String value) async {
    var userToSave = await userCollection.findOne({"_id": user.id});
    userToSave[field] = value;
    await userCollection.updateOne(
        where.eq("_id", user.id), modify.set(field, value));
  }

  static delete(User user) async {
    await userCollection.remove(where.id(user.id));
  }

  static getHorseDocuments() async {
    try {
      final horsesList = await horseCollection.find().toList();
      print(horsesList);
      List<Horse> horses = [];
      for (var item in horsesList) {
        horses.add(toHorse(item));
      }
      return horses;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Horse toHorse(data) {
    final horse = Horse(
        id: data['_id'],
        name: data['name'],
        picture: data['picture'],
        age: data['age'],
        sex: data['sex'],
        coat: data['coat'],
        breed: data['breed'],
        stable: data['stable'],
        specialty: data['specialty'],
        owner: data['owner'],
        halfBoarder: data['halfBoarder']);

    return horse;
  }

  static getUserHorseDocuments(User user) async {
    try {
      final horsesList =
          await horseCollection.find({"rider": user.id}).toList();
      print(horsesList);
      List<Horse> horses = [];
      for (var item in horsesList) {
        horses.add(toHorse(item));
      }
      return horses;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static getHorsesStable(String stableId) async {
    try {
      final horsesList =
          await horseCollection.find({"stable": stableId}).toList();
      print(horsesList);
      List<Horse> horses = [];
      for (var item in horsesList) {
        horses.add(toHorse(item));
      }
      return horses;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static insertHorse(Horse horse) async {
    await horseCollection.insertAll([horse.toJson()]);
  }

  static updateFieldHorse(Horse horse, String field, String value) async {
    var userToSave = await horseCollection.findOne({"_id": horse.id});
    userToSave[field] = value;
    await horseCollection.updateOne(
        where.eq("_id", horse.id), modify.set(field, value));
  }

  static deleteHorse(Horse horse) async {
    await horseCollection.remove(where.id(horse.id));
  }
}
