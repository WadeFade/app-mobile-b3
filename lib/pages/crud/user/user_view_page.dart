import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:app_festival_flutter/models/festival.dart';
import 'package:app_festival_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../../const_storage.dart';
import '../../login_page.dart';


class UserViewPage extends StatefulWidget {
  const UserViewPage({Key? key}) : super(key: key);

  @override
  _UserViewPageState createState() => _UserViewPageState();
}

class _UserViewPageState extends State<UserViewPage> {
  StreamController<List<User>> streamControllerUsers =
  StreamController();

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Users')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Expanded(
              child: StreamBuilder<List<User>>(
                  stream: streamControllerUsers.stream,
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
              onPressed: () async => _getUsers(),
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
              onPressed: () => {
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: '/user-view'),
                  screen: UserNewPage(),
                  withNavBar: false,
                ),
              },
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

  Future<void> _getUsers() async {
    const FlutterSecureStorage().read(key: ConstStorage.KEY_JWT).then(
          (jwt) => {
        http.get(
          Uri.parse(ConstStorage.BASE_URL + 'users'),
          headers: {'Authorization': 'Bearer $jwt'},
        ).then(
              (response) => _analyzeResponseUsers(response),
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

  void _analyzeResponseUsers(http.Response response) {
    if (response.statusCode == 200) {
      String res = response.body;
      dynamic mapRes = jsonDecode(res);
      List<User> listUsers =
      List.from(mapRes.map((x) => User.fromJson(x)));
      streamControllerUsers.sink.add(listUsers);
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

  GestureDetector _buildListElement(User user) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(user.pseudo),
              subtitle: Column(
                children: [
                  Text(
                      '${user.firstname}'),
                  Text(
                      '${user.lastname}'),
                  Text(
                      '${user.email}'),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ],
        ),
      ),
      onTap: () => {
        log('userId: ${user.id}'),
        pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: '/user-view'),
          screen: UserDeletePage(user),
          withNavBar: true,
        ),
      },
    );
  }
}
