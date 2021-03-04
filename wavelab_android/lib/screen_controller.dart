import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screens/home.dart';
import 'screens/large_wave_flume.dart';
import 'screens/directional_wave_basin.dart';
import 'screens/live_views.dart';
import 'screens/settings.dart';
import 'models/darkmode_state.dart';
import 'models/app_icons.dart';
import 'inheritable_data.dart';
class ScreenController extends StatefulWidget {

  //final SharedPreferences preferences;



  //ScreenController({this.preferences});

  ScreenControllerState createState() => ScreenControllerState();
}

class ScreenControllerState extends State<ScreenController> {

  static Darkmode darkmodeClass;
  static bool _darkmode;

  void initDarkmode(){
    if (this.mounted) {
      setState(() {
        final dmodeContainer = StateContainer.of(context);
        darkmodeClass = dmodeContainer.darkmode;
        //_darkmode = darkmodeClass.darkmodeState;
      });
    }
  }

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
                Icons.home,
              ),
              Text("Home", style: TextStyle(fontSize: 12))
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
                AppIcons.drop,
            ),
            Text("LWF", style: TextStyle(fontSize: 12))
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
              AppIcons.tint,
            ),
            Text("DWB", style: TextStyle(fontSize: 12))
          ],
        ))),
    /*Tab(child: Container(
        padding: EdgeInsetsDirectional.only(
            start: 0,
            top: 3.0,
            end: 0,
            bottom: 0
        ),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.live_tv,
            ),
            Text("Live", style: TextStyle(fontSize: 12))
          ],
        ))),*/
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
            Icons.settings,
          ),
          Text("Settings", style: TextStyle(fontSize: 12))
        ],
      ),
    ))
  ];

  final screens = [Home(), LargeWaveFlume(), DirectionalWaveBasin(), /*LiveView(),*/ Settings()];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    initDarkmode();
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: darkmodeClass.darkmodeState ? Color.fromRGBO(26, 26, 19, .9) : Colors.white,
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

  Widget Navigation(){
    return Container(
        //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        //margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        //height: 100.0,
      color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
      child: TabBar(labelColor: darkmodeClass.darkmodeState ? Colors.lightBlue : Colors.blue[700], unselectedLabelColor: darkmodeClass.darkmodeState ? Colors.grey : Colors.black, tabs: tabs)
    );
  }
}