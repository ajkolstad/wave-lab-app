import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/large_wave_flume.dart';
import '../screens/directional_wave_basin.dart';
import '../screens/live_views.dart';
import '../screens/login.dart';
class ScreenDrawer extends StatefulWidget {

  State createState() =>ScreenDrawerState();
}

class ScreenDrawerState extends State<ScreenDrawer> {

  Widget build(BuildContext context){

    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Drawer(
      child: Container(
          color: Colors.grey[700],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                child: DrawerHeader(
                  child: Text('Navigation', style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(220, 68, 5, 1.0)
                  )
                )
              ),
              ListTile(
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap:() {pushHome(context);}
              ),
              ListTile(
                title: Text('Large Wave Flume', style: TextStyle(color: Colors.white)),
                onTap:() {pushLWF(context);}
              ),
              ListTile(
                title: Text('Directional Wave Basin', style: TextStyle(color: Colors.white)),
                onTap:() {pushDWB(context);}
              ),
              ListTile(
                title: Text('Live Views', style: TextStyle(color: Colors.white)),
                onTap:() {pushLiveViews(context);}
              ),
              ListTile(
                title: Text('Login', style: TextStyle(color: Colors.white)),
                onTap:() {pushLogin(context);}
              )
            ],
          )
      )
    )
    );
  }

  void pushHome(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Home())
    );
  }
  void pushLWF(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LargeWaveFlume())
    );
  }

  void pushDWB(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DirectionalWaveBasin())
    );
  }

  void pushLiveViews(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LiveView())
    );
  }

  void pushLogin(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Login())
    );
  }
}