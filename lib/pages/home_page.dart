import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_festival_flutter/models/festival.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController<List<Festival>> streamControllerFestivals = StreamController();

  @override
  void initState() {
    super.initState();
    _getFestivals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Festivals')),
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
          ]),
        ),
      ),
    );
  }

  ListTile _buildListElement(Festival festival) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(festival.name),
        backgroundColor: Colors.indigoAccent,
      ),
      title: Row(
        children: [
          Text(festival.name),
          const Spacer(),
          Text('${festival.createdAt.hour}h${festival.createdAt.minute}'),
        ],
      ),
      subtitle: Text(festival.description),
    );
  }

  Future<void> _getFestivals() async {
    const FlutterSecureStorage().read(key: ConstStorage.KEY_JWT).then(
          (jwt) => {
            http.get(
              Uri.parse(ConstStorage.BASE_URL + 'festivals'),
              headers: {'Authorization': 'Bearer $jwt'},
            ).then(
              (response) => _analyzeResponseFestivals(response),
              onError: (error, stacktrace) =>
                  log("Error response" + error.toString()),
            )
          },
          onError: (error, stacktrace) =>
              log('Error getJWT' + error.toString()),

        );
  }

  void _analyzeResponseFestivals(http.Response response) {
    if (response.statusCode == 200) {
      String res = response.body;
      dynamic mapRes = jsonDecode(res);
      log('Festivals : $mapRes');
      List<Festival> listFestivals = List.from(mapRes.map((x) => Festival.fromJson(x)));
      log('$listFestivals');
      streamControllerFestivals.sink.add(listFestivals);
    } else {
      log("${response.statusCode} ${response.reasonPhrase}");
    }
  }
}
