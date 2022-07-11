import 'package:app_festival_flutter/models/fiche.dart';
import 'package:intl/intl.dart';

class User {
  String id;
  String firstname;
  String lastname;
  String pseudo;
  String email;
  // Fiche? fiche;


  User(this.id, this.firstname, this.lastname, this.pseudo, this.email);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        pseudo = json['pseudo'],
        email = json['email'];
        // fiche = Fiche.fromJson(json['fiche']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'pseudo': pseudo,
    'email': email,
  };
}
