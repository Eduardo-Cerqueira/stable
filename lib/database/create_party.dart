import 'dart:developer';
import 'package:stable/.env.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    db.close();
  }

  static Future<void> insertEvent(String nomSoiree, String typeSoiree,
      DateTime? selectedDate, ObjectId userID) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);

    var collection = db.collection('soirees_evenements');
    var userCollection = db.collection('users');

    var user = await userCollection.findOne(where.id(userID));

    if (user != null) {
      var userName = user['name'];
      var event = {
        'createur': userName,
        'name': nomSoiree,
        'type': typeSoiree,
        'date': selectedDate,
        'items': [],
      };
      await collection.insert(event);
    } else {}

    db.close();
  }
}
