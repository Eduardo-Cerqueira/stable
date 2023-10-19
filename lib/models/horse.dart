class Horse {
  Horse(
      {required this.id,
      required this.picture,
      required this.name,
      required this.age,
      required this.sex,
      required this.coat,
      required this.breed,
      required this.specialty,
      required this.rider});

  // Required
  final String id;
  final String picture;
  final String name;
  final int age;
  final String sex;
  final String coat;
  final String breed;
  final String specialty;
  final List<String> rider;

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
      'rider': rider
    };
  }

  factory Horse.fromJson(Map json) {
    return Horse(
        id: json['_id'],
        picture: json['picture'],
        name: json['name'],
        age: json['age'],
        sex: json['sex'],
        coat: json['coat'],
        breed: json['breed'],
        specialty: json['specialty'],
        rider: json['rider']);
  }
}