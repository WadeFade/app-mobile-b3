import 'package:app_festival_flutter/pages/admin_page.dart';
import 'package:app_festival_flutter/pages/festival_page.dart';
import 'package:app_festival_flutter/pages/home_page.dart';
import 'package:app_festival_flutter/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'models/festival.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.grey.shade900, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }
}

List<Widget> _buildScreens() {
  return [
    HomePage(),
    AdminPage(),
    // LoginPage(),
    // FestivalPage(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: Colors.indigo.shade400,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.admin_panel_settings),
      title: ("Admin"),
      activeColorPrimary: Colors.indigo.shade400,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: '/',
        routes: {
          // '/home': (context) => HomePage(),
          // '/festival': (context) => LoginPage(),
        },
      ),
    ),
    // PersistentBottomNavBarItem(
    //   icon: Icon(CupertinoIcons.settings),
    //   title: ("Login"),
    //   activeColorPrimary: Colors.indigo.shade400,
    //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // routeAndNavigatorSettings: RouteAndNavigatorSettings(
      //   initialRoute: '/',
      //   routes: {
      //     '/home': (context) => HomePage(),
      //     // '/festival': (context) => LoginPage(),
      //   },
      // ),
    // ),
    // PersistentBottomNavBarItem(
    //   icon: Icon(CupertinoIcons.settings),
    //   title: ("Festival"),
    //   activeColorPrimary: CupertinoColors.activeBlue,
    //   inactiveColorPrimary: CupertinoColors.systemGrey,
    //   routeAndNavigatorSettings: RouteAndNavigatorSettings(
    //     initialRoute: '/',
    //     routes: {
    //       '/home': (context) => HomePage(),
    //       '/login': (context) => LoginPage(),
    //     },
    //   ),
    // ),
    // PersistentBottomNavBarItem(
    //   icon: Icon(CupertinoIcons.profile_circled),
    //   title: ("Profile"),
    //   activeColorPrimary: CupertinoColors.activeBlue,
    //   inactiveColorPrimary: CupertinoColors.systemGrey,
    // ),
  ];
}