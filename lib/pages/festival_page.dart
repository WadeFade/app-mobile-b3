import 'dart:async';
import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:app_festival_flutter/models/event.dart';
import 'package:app_festival_flutter/models/festival.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FestivalPage extends StatefulWidget {
  const FestivalPage({Key? key}) : super(key: key);

  @override
  _FestivalPageState createState() => _FestivalPageState();
}

class _FestivalPageState extends State<FestivalPage> {
  StreamController<List<Event>> streamControllerFestivals = StreamController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Festival;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "${args.name}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
              ),
              Text('${DateFormat('dd/MM/yyyy').format(args.startDate)} - ${DateFormat('dd/MM/yyyy').format(args.endDate)}'),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 16.0, 25.0, 0.0),
                child: Text(
                  "${args.description}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 16.0, 25.0, 0.0),
                child: Text('Programmation :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Event>>(
                    // stream: streamControllerEvents.stream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  _buildListElement(snapshot.data![index]),
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        default:
                          return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  _getFestivalInfo(Festival args) async {
    String? jwt = await FlutterSecureStorage().read(key: ConstStorage.KEY_JWT);
    http.Response response = await http.get(
      Uri.parse('${ConstStorage.BASE_URL}festival/${args.id}'),
      headers: {'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      log("ok");
    } else {
      log("Error ${response.statusCode} ${response.body}");
      Navigator.pop(context);
    }
  }

  Card _buildListElement(Event event) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(event.name),
            subtitle: Column(
              children: [
                Text('Du : ${DateFormat('dd/MM/yyyy').format(event.startDate)}'),
                Text('Au : ${DateFormat('dd/MM/yyyy').format(event.endDate)}'),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${event.description}',
              style: TextStyle(color: Colors.indigo[200]),
            ),
          ),
        ],
      ),
    );
  }
}
