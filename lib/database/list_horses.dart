import 'package:mongo_dart/mongo_dart.dart';
import 'package:stable/.env.dart';

class ListHorses {
  static Future<List<Map<String, dynamic>>> fetchHorses() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    final collection = db.collection('horses');
    final result = await collection.find().toList();
    print(result);
    await db.close();
    return result;
  }
}
