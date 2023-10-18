import 'package:mongo_dart/mongo_dart.dart';

void updateOneField(String collectionName, ObjectId userId, String fieldName,
    String value) async {
  var db = Db("mongodb://flutter:1234@172.21.0.2:27017/");
  await db.open();

  var collection = db.collection(collectionName);
  await collection.updateOne(
      where.eq('_id', userId), modify.set(fieldName, value));

  await db.close();
}
