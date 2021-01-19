import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AppHeader extends StatefulWidget {

  final String header_title;
  //final Widget ScreenDrawer;
  final Widget body;

  AppHeader({this.header_title, this.body});

  AppHeaderState createState() => AppHeaderState();
}

class AppHeaderState extends State<AppHeader> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(26, 26, 19, .9),
        endDrawer: ScreenDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
            //backgroundColor: Colors.orange[900],
            backgroundColor: Color.fromRGBO(220, 68, 5, 1.0),
            /*leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/logo.png",
                //height: 100,

                width: 300,
                  fit: BoxFit.fitWidth,
              ),
            ),*/
            centerTitle: true,
            title: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.center,
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
                /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('OSU', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                  ]
                )*/
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                      Icons.menu,
                      color: Colors.white
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  }
              )
            ]
        ),
        body: widget.body
    );
  }
}