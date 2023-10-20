import 'package:mongo_dart/mongo_dart.dart';

class Horse {
  Horse(
      {required this.id,
      required this.picture,
      required this.name,
      required this.age,
      required this.sex,
      required this.coat,
      required this.breed,
      required this.stable,
      this.specialty,
      this.owner,
      this.halfBoarder});

  // Required
  final ObjectId id;
  final String picture;
  final String name;
  final int age;
  final String sex;
  final String coat;
  final String breed;
  final String stable;
  final String? specialty;
  final ObjectId? owner;
  final List<String>? halfBoarder;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'picture': picture,
      'name': name,
      'age': age,
      'sex': sex,
      'coat': coat,
      'breed': breed,
      'speciality': specialty,
      'owner': owner,
      'halfBoarder': halfBoarder,
      'stable': stable,
    };
  }

  factory Horse.fromJson(Map json) {
    return Horse(
        id: ObjectId.parse(json['_id']),
        picture: json['picture'],
        name: json['name'],
        age: json['age'],
        sex: json['sex'],
        coat: json['coat'],
        breed: json['breed'],
        specialty: json['specialty'],
        owner: ObjectId.parse(json['owner']),
        halfBoarder: json['halfBoarder'],
        stable: json['stable']);
  }
}