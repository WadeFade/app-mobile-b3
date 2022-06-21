import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FestivalNewPage extends StatefulWidget {
  const FestivalNewPage({Key? key}) : super(key: key);

  @override
  _FestivalNewPageState createState() => _FestivalNewPageState();
}

class _FestivalNewPageState extends State<FestivalNewPage> {
  //Controller text
  TextEditingController tecName = TextEditingController();
  TextEditingController tecDescription = TextEditingController();
  TextEditingController tecStartDate = TextEditingController();
  TextEditingController tecEndDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Festival (Ajout)'),
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
                controller: tecName,
                decoration: const InputDecoration(
                  hintText: 'Nom',
                  prefixIcon: Icon(Icons.festival_outlined),
                ),
              ),
              TextFormField(
                controller: tecDescription,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              TextFormField(
                controller: tecStartDate,
                decoration: const InputDecoration(
                  hintText: 'Date début',
                  prefixIcon: Icon(Icons.date_range),
                ),
              ),
              TextFormField(
                controller: tecEndDate,
                decoration: const InputDecoration(
                  hintText: 'Date fin',
                  prefixIcon: Icon(Icons.date_range),
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
                    onPressed: _postFestivals,
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

  _postFestivals() async {
    String name = tecName.text.trim();
    String description = tecDescription.text.trim();
    String startDate = tecStartDate.text.trim();
    String endDate = tecEndDate.text.trim();
    const FlutterSecureStorage().read(key: ConstStorage.KEY_JWT).then(
          (jwt) => {
            http.post(
              Uri.parse("${ConstStorage.BASE_URL}festivals"),
              headers: {'Authorization': 'Bearer $jwt'},
              body: {
                'name': name,
                'description': description,
                'startDate': startDate,
                'endDate': endDate,
              },
            ).then(
              (response) => {
                if (response.statusCode == 200)
                  {
                    log("Festival created ${response.statusCode}"),
                    tecName.clear(),
                    tecDescription.clear(),
                    tecStartDate.clear(),
                    tecEndDate.clear(),
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
