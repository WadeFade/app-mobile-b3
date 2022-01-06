import 'package:intl/intl.dart';

class Fiche {
  int id;
  String name;
  String description;
  String typeMusic;
  DateTime createdAt;
  DateTime updatedAt;

  Fiche(this.id, this.name, this.description, this.typeMusic, this.createdAt, this.updatedAt);

  Fiche.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        typeMusic = json['typeMusic'],
        createdAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["createdAt"]),
        updatedAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["updatedAt"]);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'typeMusic': typeMusic,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
