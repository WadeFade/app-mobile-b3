import 'package:intl/intl.dart';

class Role {
  int id;
  String name;


  Role(this.id, this.name);

  Role.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
