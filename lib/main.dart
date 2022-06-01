import 'package:app_festival_flutter/app.dart';
import 'package:app_festival_flutter/pages/festival_page.dart';
import 'package:app_festival_flutter/pages/home_page.dart';
import 'package:app_festival_flutter/pages/login_page.dart';
import 'package:app_festival_flutter/pages/register_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const App(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        // '/festival': (context) => FestivalPage(),
      },
    );
  }
}


