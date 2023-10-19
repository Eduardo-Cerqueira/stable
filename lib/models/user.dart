// https://codewithandrea.com/articles/parse-json-dart/
// https://flutterbyexample.com/lesson/factory-methods
// https://github.com/harshshinde07/MongoDB-Flutter/blob/master/lib/models/user.dart

import 'package:mongo_dart/mongo_dart.dart';

class User {
  User({
    required this.id,
    required this.profilePicture,
    required this.username,
    required this.password,
    required this.email,
    this.stable,
    this.horse,
    this.age,
    this.phoneNumber,
    this.ffeLink,
  });
  // Required
  final ObjectId id;
  final String profilePicture;
  final String username;
  final String password;
  final String email;
  // Optional
  final int? age;
  final String? phoneNumber;
  final String? ffeLink;
  final String? stable;
  final List<String>? horse;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profilePicture': profilePicture,
      'username': age,
      'password': password,
      'email': email,
      'age': age,
      'phoneNumber': phoneNumber,
      'ffeLink': ffeLink,
      'stable': stable,
      'horse': horse,
    };
  }

  factory User.fromJson(Map json) {
    return User(
        id: ObjectId.parse(json['_id']),
        profilePicture: json['profilePicture'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        age: json['age'],
        phoneNumber: json['phoneNumber'],
        ffeLink: json['ffeLink'],
        stable: json['stable'],
        horse: json['horse']);
  }
}
