import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../screens/large_wave_flume.dart';
import '../screens/directional_wave_basin.dart';
import '../screens/live_views.dart';
import '../widgets/play_youtube.dart';
import '../widgets/app_drawer.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Home extends StatefulWidget{

  HomeState createState()=> HomeState();

}

class HomeState extends State<Home> {

  bool darkmode;


/*
  @override
  void initState() {
    super.initState();
    setState((){
      darkmode = widget.preferences.getBool('darkmode') ?? false;
    });
  }

  void darkmodeSwitch(bool value) async{
    setState(() {
      darkmode = value;
      widget.preferences.setBool('darkmode', darkmode);
    });
  }
*/
  Widget build(BuildContext context){
    return AppHeader(
      header_title: 'Large Wave Flume',
      body: HomeBody(),
    );
  }

}

class HomeBody extends StatefulWidget {

  HomeBodyState createState() => HomeBodyState();

}

class HomeBodyState extends State<HomeBody>{

  Widget build(BuildContext context){
    return SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
            start: 5.0,
            top: 10.0,
            end: 5.0,
            bottom: 10.0
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            intro_section(),
            lwf_video(),
            lwf_section(),
            dwb_video(),
            dwb_section(),
            descript_section()
          ],
        )
    );
  }

  Widget intro_section(){
    return SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: Container(
              color: Colors.grey[700],
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Wrap(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //mainAxisAlignment: MainAxisAlignment.center,
                              //color: Color.fromRGBO(214, 214, 214, 1),
                              child: Text('Hinsdale Wave Research Laboratory', style: TextStyle(color: Colors.white, fontSize: 25))
                          )
                        ]
                    ),
                  ]
              )
            )
    );
  }

  Widget lwf_video(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE')
      )
    );
  }

  Widget lwf_section(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text('Large Wave Flume', style: TextStyle(color: Colors.lightBlue))
                      )
                    ]
                ),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text('Currently: 20.0m', style: TextStyle(color: Colors.black, fontSize: 20))
                      )
                    ]
                ),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text('Filling to 40.0m', style: TextStyle(color: Colors.grey[400]))
                      )
                    ]
                ),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          shape: Border.all(color: Colors.lightBlue, width: 1.0),
                          child: Text('View Flume', style: TextStyle(color: Colors.lightBlue)),
                          onPressed: () {push_lwf(context);},
                        ),
                      )
                    ]
                ),
              ]
          )
        )
    );
  }

  Widget dwb_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title')
        )
    );
  }

  Widget dwb_section(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
                children: <Widget>[
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Directional Wave Basin', style: TextStyle(color: Colors.lightBlue))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Currently: 131.0m', style: TextStyle(fontSize: 20, color: Colors.black))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Filling to 200.0m', style: TextStyle(color: Colors.grey[400]))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              shape: Border.all(color: Colors.lightBlue, width: 1.0),
                              child: Text('View Flume', style: TextStyle(color: Colors.lightBlue)),
                              onPressed: () {push_dwb(context);},
                            ),
                        )
                      ]
                  ),
                ]
            )
        )
    );
  }

  Widget descript_section(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            color: Colors.grey[700],
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Wrap(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(

                            //mainAxisAlignment: MainAxisAlignment.center,
                            child: Text('The O.H. Hinsdale Wave Research Laboratory provides '
                                'outstanding research and testing at the largest nearshore '
                                'experimental facility at an academic institution in the US.', style: TextStyle(color: Colors.white))
                        )
                      ]
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Text('View Flumes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            onPressed: () {push_lv(context);},
                          ),
                      )
                    ],
                  )
                ]
            )
        )
    );
  }

  void push_lv(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LiveView())
    );
  }

  void push_lwf(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LargeWaveFlume())
    );
  }

  void push_dwb(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DirectionalWaveBasin())
    );
  }
}