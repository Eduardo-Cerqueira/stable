import 'package:mongo_dart/mongo_dart.dart';

class Stable {
  Stable(
      {required this.id,
      required this.picture,
      required this.name,
      required this.horse});

  // Required
  final ObjectId id;
  final String picture;
  final String name;
  final List<String> horse;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'picture': picture,
      'name': name,
      'horse': horse,
    };
  }

  factory Stable.fromJson(Map json) {
    return Stable(
        id: ObjectId.parse(json['_id']),
        picture: json['picture'],
        name: json['name'],
        horse: json['horse']);
  }
}
