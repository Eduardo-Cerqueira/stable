import 'package:mongo_dart/mongo_dart.dart';
import 'package:stable/persistance/update_one_field.dart';

void setPhoneNumberField(ObjectId userId, String? value) {
  if (value != null) updateOneField("user", userId, "phoneNumber", value);
}

void setAgeField(ObjectId userId, String? value) {
  if (value != null) updateOneField("user", userId, "Age", value);
}

void setProfileLinkField(ObjectId userId, String? value) {
  if (value != null) updateOneField("user", userId, "FFE_link", value);
}

Future<Map<String, dynamic>?> getUserById(ObjectId userId) async {
  var db = Db("mongodb://flutter:1234@172.21.0.2:27017/");
  await db.open();
  var user = db.collection("user").findOne(where.eq('_id', userId));
  await db.close();
  return user;
}

Future<Map<String, dynamic>?> getOneUser() async {
  var db = Db("mongodb://flutter:1234@172.21.0.2:27017/");
  await db.open();
  var user = db.collection("user").findOne();
  await db.close();
  return user;
}
