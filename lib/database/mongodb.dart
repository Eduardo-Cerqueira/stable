import 'dart:developer';
import 'constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    db.close();
  }

  static Future<void> insertEvent(String nomSoiree, String typeSoiree, DateTime? selectedDate, String userID) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);

    var collection = db.collection('soirees_evenements');

    // Document à insérer
    var event = {
      'createur': userID,
      'name': nomSoiree,
      'type': typeSoiree,
      'date': selectedDate, // Utilisez la date actuelle
    };

    // Insérer le document dans la collection
    await collection.insert(event);

    // Fermer la connexion à la base de données lorsque vous avez terminé
    db.close();
  }
}
