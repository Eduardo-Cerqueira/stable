import 'package:mongo_dart/mongo_dart.dart';
import 'package:stable/models/user.dart';

String MONGO_CONN_URL = "mongodb://flutter:1234@172.21.0.2:27017/";
String USER_COLLECTION = "user";

class UserDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print("🖴 Connected to database !");
    userCollection = db.collection(USER_COLLECTION);
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
}
