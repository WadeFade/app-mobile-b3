import 'package:intl/intl.dart';

class Role {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  Role(this.id, this.name, this.createdAt, this.updatedAt);

  Role.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["createdAt"]),
        updatedAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["updatedAt"]);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
