/****************************************************************************
 * This file is used to control the apps ability to switch between tabs.
 ***************************************************************************/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screens/home.dart';
import 'screens/large_wave_flume.dart';
import 'screens/directional_wave_basin.dart';
import 'screens/settings.dart';
import 'models/darkmode_state.dart';
import 'models/app_icons.dart';
import 'inheritable_data.dart';
class ScreenController extends StatefulWidget {

  ScreenControllerState createState() => ScreenControllerState();

}

class ScreenControllerState extends State<ScreenController> {

  static Darkmode darkmodeClass;

  // Initializes darkmode from inheritable widget
  void initDarkmode(){
    if (this.mounted) {
      setState(() {
        final dmodeContainer = StateContainer.of(context);
        darkmodeClass = dmodeContainer.darkmode;
      });
    }
  }

  // Tabs for the app that holds tabs "Home", "LWF", "DWB", and "Settings"
  static var tabs = [
    Tab(child: Container(
        padding: EdgeInsetsDirectional.only(
            start: 0,
            top: 3.0,
            end: 0,
            bottom: 0
        ),
        child: Column(
            children: <Widget>[
              Icon(
                Icons.home, // Icon for home tab
              ),
              Text("Home", style: TextStyle(fontSize: 12)) // Text for home tab
            ],
        )
    )),
    Tab(child: Container(
        padding: EdgeInsetsDirectional.only(
            start: 0,
            top: 3.0,
            end: 0,
            bottom: 0
        ),
        child: Column(
          children: <Widget>[
            Icon(
                AppIcons.drop, // Icon for LWF tab
            ),
            Text("LWF", style: TextStyle(fontSize: 12)) // Text for LWF tab
          ],
        ))),
    Tab(child: Container(
        padding: EdgeInsetsDirectional.only(
            start: 0,
            top: 3.0,
            end: 0,
            bottom: 0
        ),
        child: Column(
          children: <Widget>[
            Icon(
              AppIcons.tint, // Icon for DWB tab
            ),
            Text("DWB", style: TextStyle(fontSize: 12)) // Text for DWB tab
          ],
        ))),
    Tab(child: Container(
      padding: EdgeInsetsDirectional.only(
          start: 0,
          top: 3.0,
          end: 0,
          bottom: 0
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.settings, // Icon for settings tab
          ),
          Text("Settings", style: TextStyle(fontSize: 12)) // Text for settings tab
        ],
      ),
    ))
  ];

  // Screen holds widgets for each tab to switch to when tab is pressed
  final screens = [Home(), LargeWaveFlume(), DirectionalWaveBasin(), Settings()];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {

    initDarkmode();
    if(darkmodeClass == null)
      return DefaultTabController(
          length: 4, // Tab controller length
          initialIndex: 0,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor:  Color.fromRGBO(220, 68, 5, 1.0),
              // Designs the top bar of app
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromRGBO(220, 68, 5, 1.0),
                centerTitle: true,
                title: Row(
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Image.asset(
                                "assets/logo.png",
                                scale: 1.5,
                              )
                          ),
                        ]
                    ),
                  ],
                ),
              ),
              body: Center(
                child: Text("Generating")
              )
          )
      );

    else
      return DefaultTabController(
          length: 4, // Tab controller length
          initialIndex: 0,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: darkmodeClass.darkmodeState ? Color.fromRGBO(
                  26, 26, 19, .9) : Colors.white,
              // Designs the top bar of app
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromRGBO(220, 68, 5, 1.0),
                centerTitle: true,
                title: Row(
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Image.asset(
                                "assets/logo.png",
                                scale: 1.5,
                              )
                          ),
                        ]
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Navigation(),
              body: TabBarView(children: screens)
          )
      );

  }

  // Control the navigation bar
  Widget Navigation(){
    return Container(
      color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
      child: TabBar(labelColor: darkmodeClass.darkmodeState ? Colors.lightBlue : Colors.blue[700], unselectedLabelColor: darkmodeClass.darkmodeState ? Colors.grey : Colors.black, tabs: tabs)
    );
  }
}