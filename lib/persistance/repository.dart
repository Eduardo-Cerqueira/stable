import 'package:mongo_dart/mongo_dart.dart';
import 'package:stable/models/horse.dart';
import 'package:stable/models/stable.dart';
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
  static var db, userCollection, horseCollection, stableCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print("🖴 Connected to database !");
    userCollection = db.collection("user");
    horseCollection = db.collection("horse");
    stableCollection = db.collection("stable");
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

  static getUserOwnedHorse(User user) async {
    try {
      final horsesList =
          await horseCollection.find({"owner": user.id}).toList();
      print(horsesList.toString());
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

  static getUserHalfBoarderHorse(User user) async {
    try {
      final horsesList =
          await horseCollection.find({"halfBoarder": user.id}).toList();
      print(horsesList.toString());
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

  static updateOwnerManyFieldHorse(User user, List<ObjectId> horses) async {
    for (final horse in horses) {
      await horseCollection.updateOne(
          where.eq("_id", horse.id), modify.set("owner", user.id));
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

  static updateFieldHorse(ObjectId horseId, String field, value) async {
    var horseToSave = await horseCollection.findOne({"_id": horseId});
    horseToSave[field] = value;
    await horseCollection.updateOne(
        where.eq("_id", horseId), modify.set(field, value));
  }

  static deleteHorse(Horse horse) async {
    await horseCollection.remove(where.id(horse.id));
  }

  static Stable toStable(data) {
    final stable =
        Stable(id: data['_id'], name: data['name'], picture: data['picture']);

    return stable;
  }

  static getAllStables() async {
    try {
      final stableList = await stableCollection.find().toList();
      List<Stable> stables = [];
      for (var item in stableList) {
        stables.add(toStable(item));
      }
      return stables;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
