import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
              ElevatedButton(
                onPressed: () => {},
                child: const Text('Festivals'),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: const Text('Évènements'),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: const Text('Artistes'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

}
