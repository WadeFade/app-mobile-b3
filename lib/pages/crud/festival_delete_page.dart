import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_festival_flutter/const_storage.dart';
import 'package:app_festival_flutter/models/event.dart';
import 'package:app_festival_flutter/models/festival.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FestivalDeletePage extends StatefulWidget {
  final Festival festival;

  const FestivalDeletePage(this.festival, {Key? key}) : super(key: key);

  @override
  _FestivalDeletePageState createState() => _FestivalDeletePageState();
}

class _FestivalDeletePageState extends State<FestivalDeletePage> {
  StreamController<List<Event>> streamControllerEvents = StreamController();

  @override
  void initState() {
    super.initState();
    _getFestivalInfo(widget.festival);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Festival (Delete)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "${widget.festival.name}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
              ),
              Text(
                '${DateFormat('dd/MM/yyyy').format(widget.festival.startDate)} - ${DateFormat('dd/MM/yyyy').format(widget.festival.endDate)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade200,
                  fontSize: 18.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 16.0, 25.0, 0.0),
                child: Text(
                  "${widget.festival.description}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 16.0, 25.0, 0.0),
                child: Text(
                  'Programmation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Event>>(
                    stream: streamControllerEvents.stream,
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
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          return const Center(
                              child: CircularProgressIndicator());
                      }
                    }),
              ),
              // Spacer(),
              ElevatedButton(
                  onPressed: () async => _deleteFestival(widget.festival),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: const Text('Supprimer')),
            ],
          ),
        ),
      ),
    );
  }

  _getFestivalInfo(Festival festival) async {
    String? jwt = await FlutterSecureStorage().read(key: ConstStorage.KEY_JWT);
    http.Response response = await http.get(
      Uri.parse('${ConstStorage.BASE_URL}events/festival/${festival.id}'),
      headers: {'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      log("ok");
      _analyzeResponseEvents(response);
    } else {
      log("Error ${response.statusCode} ${response.body}");
      Navigator.pop(context);
    }
  }

  void _analyzeResponseEvents(http.Response response) {
    if (response.statusCode == 200) {
      String res = response.body;
      dynamic mapRes = jsonDecode(res);
      List<Event> listEvents = List.from(mapRes.map((x) => Event.fromJson(x)));
      streamControllerEvents.sink.add(listEvents);
    } else {
      log("${response.statusCode} ${response.reasonPhrase}");
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
                Text(
                    'Du : ${DateFormat('dd/MM/yyyy - HH:mm').format(event.startDate)}'),
                Text(
                    'Au : ${DateFormat('dd/MM/yyyy - HH:mm').format(event.endDate)}'),
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

  _deleteFestival(Festival festival) async {
    String? jwt = await FlutterSecureStorage().read(key: ConstStorage.KEY_JWT);
    http.Response response = await http.delete(
      Uri.parse('${ConstStorage.BASE_URL}festivals/${festival.id}'),
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
}
