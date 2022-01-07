import 'package:intl/intl.dart';

class Fiche {
  int id;
  String name;
  String description;
  String typeMusic;

  Fiche(this.id, this.name, this.description, this.typeMusic);

  Fiche.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        typeMusic = json['typeMusic'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'typeMusic': typeMusic,
  };
}
