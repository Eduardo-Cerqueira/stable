import 'package:mongo_dart/mongo_dart.dart';

connection() async {
  const connectionString =
      'mongodb+srv://coraliepereira95:coraliepereira95@Cluster1.fs7xzjy.mongodb.net/Cluster1?retryWrites=true&w=majority';

  var db = await Db.create(connectionString);

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
    insertUsers(db, {"name": "keke", "age": 23});
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

getUsersByName(db, name) async {
  var collection = db.collection('users');

  var users = await collection.find(where.eq('name', name)).toList();

  print(users);

  return users;
}

Future<void> insertUsers(db, Map<String, dynamic> usersData) async {
  final collection = db.collection('users');

  await collection.insert(usersData);

  await db.close();
}
