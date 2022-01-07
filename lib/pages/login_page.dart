import 'dart:convert';
import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
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
              // const Spacer(),
              // Image.asset('assets/icon/icon.png',
              //     width: 100, height: 100, color: Colors.white),
              const Spacer(),
              TextFormField(
                controller: tecEmail,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                controller: tecPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Mot de passe',
                  prefixIcon: Icon(Icons.password),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/register"),
                    child: const Text('S\'INSCRIRE'),
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('SE CONNECTER'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _login() async {
    String email = tecEmail.text.trim();
    String password = tecPassword.text.trim();

    http.Response response = await http.post(
        Uri.parse("${ConstStorage.BASE_URL}auth/signin"),
        body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      tecEmail.clear();
      tecPassword.clear();
      log("Success : ${response.statusCode}");
      String jwt = jsonDecode(response.body)["accessToken"];
      const FlutterSecureStorage()
          .write(key: ConstStorage.KEY_JWT, value: jwt)
          .then((value) => Navigator.of(context).pushNamed("/home"),
          onError: (_, var1) => log("Impossible d'écrire le token JWT."));
    } else {
      log("Error : ${response.statusCode} : ${response.body}");
    }
  }
}
