import 'package:mongo_dart/mongo_dart.dart';

class Stable {
  Stable({required this.id, required this.picture, required this.name});

  // Required
  final ObjectId id;
  final String picture;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'picture': picture,
      'name': name,
    };
  }

  factory Stable.fromJson(Map json) {
    return Stable(
        id: ObjectId.parse(json['_id']),
        picture: json['picture'],
        name: json['name']);
  }
}
