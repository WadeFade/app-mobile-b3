import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:app_festival_flutter/models/event.dart';
import 'package:app_festival_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserDeletePage extends StatefulWidget {
  final User user;

  const UserDeletePage(this.user, {Key? key}) : super(key: key);

  @override
  _UserDeletePageState createState() => _UserDeletePageState();
}

class _UserDeletePageState extends State<UserDeletePage> {
  TextEditingController tecPseudo = TextEditingController();
  TextEditingController tecFirstname = TextEditingController();
  TextEditingController tecLastname = TextEditingController();
  TextEditingController tecEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    tecPseudo.text = widget.user.pseudo;
    tecFirstname.text = widget.user.firstname;
    tecLastname.text = widget.user.lastname;
    tecEmail.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin User (Modify/Delete)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              TextFormField(
                controller: tecPseudo,
                decoration: const InputDecoration(
                  label: Text('Pseudo'),
                  hintText: 'Pseudo',
                ),
              ),
              TextFormField(
                controller: tecFirstname,
                decoration: const InputDecoration(
                  label: Text('Prénom'),
                  hintText: 'Prénom',
                ),
              ),
              TextFormField(
                controller: tecLastname,
                decoration: const InputDecoration(
                  label: Text('Nom'),
                  hintText: 'Nom',
                ),
              ),
              TextFormField(
                controller: tecEmail,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  hintText: 'email@exemple.com',
                ),
              ),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async => _deleteUser(widget.user),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: const Text('Supprimer'),
                  ),
                  ElevatedButton(
                    onPressed: () async => _modifyUser(widget.user),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                    ),
                    child: const Text('Modifier'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _deleteUser(User user) async {
    String? jwt = await FlutterSecureStorage().read(key: ConstStorage.KEY_JWT);
    http.Response response = await http.delete(
      Uri.parse('${ConstStorage.BASE_URL}users/${user.id}'),
      headers: {'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      log("ok: deleted");
      Navigator.pop(context);
    } else {
      log("Error ${response.statusCode} ${response.body}");
      Navigator.pop(context);
    }
  }

  _modifyUser(User user) async {
    String pseudo = tecPseudo.text.trim();
    String firstname = tecFirstname.text.trim();
    String lastname = tecLastname.text.trim();
    String email = tecEmail.text.trim();
    String? jwt = await FlutterSecureStorage().read(key: ConstStorage.KEY_JWT);
    http.Response response = await http.put(
      Uri.parse('${ConstStorage.BASE_URL}users/${user.id}'),
      headers: {'Authorization': 'Bearer $jwt'},
      body: {
        'pseudo': pseudo,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
      },
    );
    if (response.statusCode == 200) {
      log("ok: modified");
      Navigator.pop(context);
    } else {
      log("Error ${response.statusCode} ${response.body}");
      Navigator.pop(context);
    }
  }
}
