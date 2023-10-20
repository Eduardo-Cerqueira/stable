import 'package:mongo_dart/mongo_dart.dart';
import 'package:stable/.env.dart';

class ListParty {
  static Future<List<Map<String, dynamic>>> fetchSoirees() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    final collection = db.collection('soirees_evenements');
    final result = await collection.find(where.sortBy('type')).toList();
    await db.close();
    return result;
  }
}
