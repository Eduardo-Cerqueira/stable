import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer' as dev; // for logging

const mongoUrl = "10.0.2.2";
const databaseName = "flutterecurie";

void main() async {
  dev.log('test');
  var db = await DbConnection._(mongoUrl, '27017', databaseName).db;
  db.isConnected;
  var coll = db.collection('users');
  await coll.insertOne({
    'profile_picture':
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==',
    'username': 'Hello',
    'email': 'john@doe.com',
    'password': 1234,
  });
  print('Connection to MongoDB successful');
}

class DbConnection {
  DbConnection._(this.host, this.port, this.dbName);

  final String host;
  final String port;
  final String dbName;

  String get connectionString => 'mongodb://$host:$port/$dbName';

  static bool started = false;

  Db? _db;
  Future<Db> get db async => getConnection();

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      print('Database connection closed');
    }
  }

  Future<Db> getConnection() async {
    if (_db == null || !_db!.isConnected) {
      dev.log('Connecting to "$connectionString"');
      await close();
      var retry = 0;
      while (true) {
        try {
          retry++;
          var db = Db(connectionString);
          db.open();
          dev.log('Attempt "$retry"');
          started = true;
          _db = db;
          break;
        } catch (e) {
          dev.log('Error while opening the database: $e');
          if (retry < 5) {
            dev.log('Attempt "$retry" failed');
            await Future.delayed(Duration(milliseconds: 100 * retry));
          } else {
            rethrow;
          }
        }
      }
    }
    return _db!;
  }

  // Future<User?> findUser(String email) async {
  //   if (_db != null) {
  //     return db.then((db) => db.collection('users').find(where.eq('email', email)));
  //   }
  // }
}
