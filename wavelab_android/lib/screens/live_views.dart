import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../screens/large_wave_flume.dart';
import '../screens/directional_wave_basin.dart';
import '../widgets/play_youtube.dart';
import '../widgets/app_drawer.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class LiveView extends StatefulWidget{

  LiveViewState createState()=> LiveViewState();

}

class LiveViewState extends State<LiveView> {

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
      header_title: 'Live View',
      body: lwf_body(),
    );
  }

  Widget lwf_body() {
    return SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
            start: 5.0,
            top: 10.0,
            end: 5.0,
            bottom: 10.0
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              ),
              lv_intro(),
              bay10_video(),
              bay10_lwf(),
              bay14_video(),
              bay14_lwf(),
              nLwf_video(),
              nWall_lwf(),
              nDwb_video(),
              nWall_dwb(),
              wDwb_video(),
              wWall_dwb(),
              nwDwb_video(),
              nWCorner_dwb()
            ]
        )
    );
  }

  Widget lv_intro(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
            padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        child: Text('Wave View', style: TextStyle(fontSize: 30, color: Colors.white))
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  Widget bay10_video(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE&feature=emb_title')
      )
    );
  }

  Widget bay10_lwf(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Text('Above Bay 10', style: TextStyle(color: Colors.black))
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 80,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: FlatButton(
                                  shape: Border.all(color: Colors.lightBlue, width: 1.0),
                                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                                  child: Text('View', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400)),
                                  onPressed: () {push_lwf(context);},
                                ),
                              )
                            )
                          ]
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('Large Wave Flume')
                            )
                          ],
                        )
                      ]
                  ),
                ]
            )

        )

    );
  }

  Widget bay14_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=V3JsFPQA6YQ&feature=emb_title')
        )
    );
  }

  Widget bay14_lwf(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Text('Above Bay 14', style: TextStyle(color: Colors.black))
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 80,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: FlatButton(
                                      shape: Border.all(color: Colors.lightBlue, width: 1.0),
                                      padding: EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Text('View', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400)),
                                      onPressed: () {push_lwf(context);},
                                    ),
                                  )
                              )
                            ]
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('Large Wave Flume')
                            )
                          ],
                        )
                      ]
                  ),
                ]
            )

        )

    );
  }

  Widget nLwf_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=VCluhS3RJpI&feature=emb_title')
        )
    );
  }

  Widget nWall_lwf(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Text('North Wall', style: TextStyle(color: Colors.black))
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 80,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: FlatButton(
                                      shape: Border.all(color: Colors.lightBlue, width: 1.0),
                                      padding: EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Text('View', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400)),
                                      onPressed: () {push_lwf(context);},
                                    ),
                                  )
                              )
                            ]
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('Large Wave Flume')
                            )
                          ],
                        )
                      ]
                  ),
                ]
            )

        )

    );
  }

  Widget nDwb_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title')
        )
    );
  }

  Widget nWall_dwb(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Text('North Wall', style: TextStyle(color: Colors.black))
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 80,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: FlatButton(
                                      shape: Border.all(color: Colors.lightBlue, width: 1.0),
                                      padding: EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Text('View', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400)),
                                      onPressed: () {push_dwb(context);},
                                    ),
                                  )
                              )
                            ]
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('Directional Wave Basin')
                            )
                          ],
                        )
                      ]
                  ),
                ]
            )

        )

    );
  }

  Widget wDwb_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=xNzdOP3ixd4&feature=emb_title')
        )
    );
  }

  Widget wWall_dwb(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Text('West Wall', style: TextStyle(color: Colors.black))
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 80,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: FlatButton(
                                      shape: Border.all(color: Colors.lightBlue, width: 1.0),
                                      padding: EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Text('View', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400)),
                                      onPressed: () {push_dwb(context);},
                                    ),
                                  )
                              )
                            ]
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('Directional Wave Basin')
                            )
                          ],
                        )
                      ]
                  ),
                ]
            )

        )

    );
  }

  Widget nwDwb_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=Z7V0x92PpXU&feature=emb_title')
        )
    );
  }

  Widget nWCorner_dwb(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Text('Northwest Corner', style: TextStyle(color: Colors.black))
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 80,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: FlatButton(
                                      shape: Border.all(color: Colors.lightBlue, width: 1.0),
                                      padding: EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Text('View', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400)),
                                      onPressed: () {push_dwb(context);},
                                    ),
                                  )
                              )
                            ]
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('Directional Wave Basin')
                            )
                          ],
                        )
                      ]
                  ),
                ]
            )
        )
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