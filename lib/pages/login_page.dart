import 'dart:convert';
import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:app_festival_flutter/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'home_page.dart';

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connexion'),
          automaticallyImplyLeading: false,
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
                      onPressed: () => pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: '/login'),
                        screen: RegisterPage(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                      ),
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
          .then(
              (value) => pushNewScreen(
                context,
                screen: HomePage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
              onError: (_, var1) => log("Impossible d'écrire le token JWT."));
    } else {
      log("Error : ${response.statusCode} : ${response.body}");
    }
  }
}
