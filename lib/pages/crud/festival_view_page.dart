import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:app_festival_flutter/models/festival.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../const_storage.dart';
import '../festival_page.dart';
import '../login_page.dart';
import 'festival_delete_page.dart';

class FestivalViewPage extends StatefulWidget {
  const FestivalViewPage({Key? key}) : super(key: key);

  @override
  _FestivalViewPageState createState() => _FestivalViewPageState();
}

class _FestivalViewPageState extends State<FestivalViewPage> {
  StreamController<List<Festival>> streamControllerFestivals =
      StreamController();

  @override
  void initState() {
    super.initState();
    _getFestivals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Festivals')),
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
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            heightFactor: 13.0,
            child: FloatingActionButton(
              heroTag: 'refresh',
              onPressed: () async => _getFestivals(),
              tooltip: 'Refresh',
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.refresh),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: () async => {},
              tooltip: 'Add',
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
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
                  // log("Error response" + error.toString()),
                  pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: '/home'),
                screen: LoginPage(),
                withNavBar: false,
              ),
            )
          },
          onError: (error, stacktrace) =>
              // log('Error getJWT' + error.toString()),
              pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: '/home'),
            screen: LoginPage(),
            withNavBar: false,
          ),
        );
  }

  void _analyzeResponseFestivals(http.Response response) {
    if (response.statusCode == 200) {
      String res = response.body;
      dynamic mapRes = jsonDecode(res);
      List<Festival> listFestivals =
          List.from(mapRes.map((x) => Festival.fromJson(x)));
      streamControllerFestivals.sink.add(listFestivals);
    } else {
      log("${response.statusCode} ${response.reasonPhrase}");
      pushNewScreen(
        context,
        // settings: RouteSettings(name: '/home'),
        screen: LoginPage(),
        withNavBar: false,
      );
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
                  Text(
                      'Du : ${DateFormat('dd/MM/yyyy').format(festival.startDate)}'),
                  Text(
                      'Au : ${DateFormat('dd/MM/yyyy').format(festival.endDate)}'),
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
          ],
        ),
      ),
      onTap: () => {
        log('festivalId: ${festival.id}'),
        pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: '/festival-view'),
          screen: FestivalDeletePage(festival),
          withNavBar: true,
        ),
      },
    );
  }
}
