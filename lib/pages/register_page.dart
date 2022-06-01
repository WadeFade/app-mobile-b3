import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controller text
  TextEditingController tecFirstname = TextEditingController();
  TextEditingController tecLastname = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S\'inscrire'),
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
              // Image.asset('assets/image/loupp.png',
              //     width: 100, height: 100, color: Colors.white),
              const Spacer(),
              TextFormField(
                controller: tecFirstname,
                decoration: const InputDecoration(
                  hintText: 'Prénom',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                controller: tecLastname,
                decoration: const InputDecoration(
                  hintText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                controller: tecEmail,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
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
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                    child: const Text('SE CONNECTER'),
                  ),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('S\'INSCRIRE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _register() async {
    String firstname = tecFirstname.text.trim();
    String lastname = tecLastname.text.trim();
    String email = tecEmail.text.trim();
    String password = tecPassword.text.trim();

    http.Response response = await http.post(
        Uri.parse("${ConstStorage.BASE_URL}auth/signup"),
        body: {'firstname': firstname, 'lastname': lastname, 'email': email, 'password': password});

    if (response.statusCode == 200) {
      log("Register done with success ${response.statusCode}");
      tecFirstname.clear();
      tecLastname.clear();
      tecEmail.clear();
      tecPassword.clear();
      Navigator.of(context).pushNamed("/login");
    } else {
      log("Register error ${response.statusCode}");
    }
  }
}
