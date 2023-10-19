class User {
  User({
    required this.id,
    required this.profilePicture,
    required this.username,
    required this.password,
    required this.email,
    required this.stable,
    required this.horse,
    this.age,
    this.phoneNumber,
    this.ffeLink,
  });
  // Required
  final String id;
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
}

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
}

class Stable {
  Stable(
      {required this.id,
      required this.picture,
      required this.name,
      required this.horse});

  // Required
  final String id;
  final String picture;
  final String name;
  final List<String> horse;
}

class Event {
  Event(
      {required this.id,
      required this.attendee,
      required this.type,
      required this.date});

  // Required
  final String id;
  final List<List<String>> attendee;
  final String type;
  final DateTime date;
}
