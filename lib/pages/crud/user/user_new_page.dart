import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserNewPage extends StatefulWidget {
  const UserNewPage({Key? key}) : super(key: key);

  @override
  _UserNewPageState createState() => _UserNewPageState();
}

class _UserNewPageState extends State<UserNewPage> {
  //Controller text
  TextEditingController tecPseudo = TextEditingController();
  TextEditingController tecFirstname = TextEditingController();
  TextEditingController tecLastname = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin User (Ajout)'),
        // actions: [
        //   IconButton(
        //     onPressed: () => Navigator.of(context).pushNamed("/home"),
        //     icon: const Icon(Icons.home),
        //   ),
        // ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Spacer(),
              TextFormField(
                controller: tecPseudo,
                decoration: const InputDecoration(
                  hintText: 'Pseudo',
                ),
              ),
              TextFormField(
                controller: tecFirstname,
                decoration: const InputDecoration(
                  hintText: 'Prénom',
                ),
              ),
              TextFormField(
                controller: tecLastname,
                decoration: const InputDecoration(
                  hintText: 'Nom',
                ),
              ),
              TextFormField(
                controller: tecEmail,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextFormField(
                controller: tecPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '*******',
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ANNULER'),
                  ),
                  ElevatedButton(
                    onPressed: _postUsers,
                    child: const Text('AJOUTER'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _postUsers() async {
    String pseudo = tecPseudo.text.trim();
    String firstname = tecFirstname.text.trim();
    String lastname = tecLastname.text.trim();
    String email = tecEmail.text.trim();
    String password = tecPassword.text.trim();
    const FlutterSecureStorage().read(key: ConstStorage.KEY_JWT).then(
          (jwt) => {
        http.post(
          Uri.parse("${ConstStorage.BASE_URL}users"),
          headers: {'Authorization': 'Bearer $jwt'},
          body: {
            'pseudo': pseudo,
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
          },
        ).then(
              (response) => {
            if (response.statusCode == 200)
              {
                log("User created ${response.statusCode}"),
                tecPseudo.clear(),
                tecFirstname.clear(),
                tecLastname.clear(),
                tecEmail.clear(),
              }
            else
              {
                log("${response.statusCode} : ${response.reasonPhrase}"),
              }
          },
          onError: (error, stacktrace) =>
              log("Error response" + error.toString()),
        ),
      },
      onError: (error, stacktrace) =>
          log('Error getJWT' + error.toString()),
    );
  }
}
