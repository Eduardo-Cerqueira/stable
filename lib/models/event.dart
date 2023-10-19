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

  Map<String, dynamic> toJson() {
    return {'_id': id, 'attendee': attendee, 'type': type, 'date': date};
  }

  factory Event.fromJson(Map json) {
    return Event(
        id: json['_id'],
        attendee: json['attendee'],
        type: json['type'],
        date: json['date']);
  }
}
