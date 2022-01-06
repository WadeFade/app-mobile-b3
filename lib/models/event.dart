import 'package:intl/intl.dart';

class Event {
  int id;
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;

  Event(this.id, this.name, this.description, this.startDate, this.endDate, this.createdAt, this.updatedAt);

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        startDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["startDate"]),
        endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["endDate"]),
        createdAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["createdAt"]),
        updatedAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["updatedAt"]);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'startDate': startDate,
    'endDate': endDate,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
