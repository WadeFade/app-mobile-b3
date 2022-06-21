import 'dart:convert';
import 'dart:developer';

import 'package:app_festival_flutter/pages/crud/festival/festival_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: 150.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () => pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: '/admin'),
                    screen: FestivalViewPage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                  ),
                  child: const Text('Festivals'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: SizedBox(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () => {},
                    child: const Text('Évènements'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: SizedBox(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () => {},
                    child: const Text('Fiches'),
                  ),
                ),
              ),
              SizedBox(
                width: 150.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () => {},
                  child: const Text('Utilisateurs'),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
