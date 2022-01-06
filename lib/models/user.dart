import 'package:app_festival_flutter/models/fiche.dart';
import 'package:intl/intl.dart';

class User {
  String id;
  String firstname;
  String lastname;
  String email;
  Fiche? fiche;
  DateTime createdAt;
  DateTime updatedAt;


  User(this.id, this.firstname, this.lastname, this.email, this.fiche, this.createdAt, this.updatedAt);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        email = json['email'],
        fiche = Fiche.fromJson(json['email']),
        createdAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["createdAt"]),
        updatedAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["updatedAt"]);

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
