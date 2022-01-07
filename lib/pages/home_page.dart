import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_festival_flutter/models/festival.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../const_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController<List<Festival>> streamControllerFestivals = StreamController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getFestivals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Festivals')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Expanded(
              child: StreamBuilder<List<Festival>>(
                  stream: streamControllerFestivals.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) => _buildListElement(snapshot.data![index]),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.festival),
            label: 'Festival',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker_notes),
            label: 'Artist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo[200],
        onTap: (value) => {
          _onItemTappedOnNavBar(value),
        },
      ),
    );
  }


  void _onFestivalTapped(Festival _festival) {
    Navigator.pushNamed(context, "/festival", arguments: _festival);
  }

  void _onItemTappedOnNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
    switch(index) {
      case 0: {
        Navigator.pushNamed(context, "/home");
      }
      break;
      case 1: {
        Navigator.pushNamed(context, "/artist");
      }
      break;
      case 2: {
        Navigator.pushNamed(context, "/admin");
      }
      break;
      case 3: {
        Navigator.pushNamed(context, "/profile");
      }
      break;
      default: {
        Navigator.pushNamed(context, "/home");
      }
      break;
    }
  }

  Future<void> _getFestivals() async {
    const FlutterSecureStorage().read(key: ConstStorage.KEY_JWT).then(
          (jwt) => {
            http.get(
              Uri.parse(ConstStorage.BASE_URL + 'festivals'),
              headers: {'Authorization': 'Bearer $jwt'},
            ).then(
              (response) => _analyzeResponseFestivals(response),
              onError: (error, stacktrace) => log("Error response" + error.toString()),
            )
          },
          onError: (error, stacktrace) => log('Error getJWT' + error.toString()),
        );
  }

  void _analyzeResponseFestivals(http.Response response) {
    if (response.statusCode == 200) {
      String res = response.body;
      dynamic mapRes = jsonDecode(res);
      List<Festival> listFestivals = List.from(mapRes.map((x) => Festival.fromJson(x)));
      streamControllerFestivals.sink.add(listFestivals);
    } else {
      log("${response.statusCode} ${response.reasonPhrase}");
      Navigator.pushNamed(context, "/login");
    }
  }

  GestureDetector _buildListElement(Festival festival) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.festival),
              title: Text(festival.name),
              subtitle: Column(
                children: [
                  Text('Du : ${DateFormat('dd/MM/yyyy').format(festival.startDate)}'),
                  Text('Au : ${DateFormat('dd/MM/yyyy').format(festival.endDate)}'),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${festival.description}',
                style: TextStyle(color: Colors.indigo[200]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: Text(
                '(Cliquez pour voir la programmation)',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
      onTap: () => {
        log('festivalId: ${festival.id}'),
        _onFestivalTapped(festival),
      },
    );
  }
}
