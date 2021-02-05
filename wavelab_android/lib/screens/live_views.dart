import 'package:flutter/material.dart';
import '../screens/large_wave_flume.dart';
import '../screens/directional_wave_basin.dart';
import '../widgets/play_youtube.dart';
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
              LWF_Intro(),
              LWF_Live(),
              DWB_Intro(),
              DWB_Live(),
            ]
        )
    );
  }

  Widget lv_intro(){
    return SizedBox(
        //width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
            padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Text('Wave View', style: TextStyle(fontSize: 35, color: Colors.white))
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  Widget LWF_Intro() {
    return SizedBox(
        //width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        child: Text('Large Wave Flume', style: TextStyle(fontSize: 30, color: Colors.white))
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  Widget LWF_Live() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
      height: MediaQuery.of(context).size.width * .6,
    child: ListView(
        scrollDirection:Axis.horizontal,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * .6,
              child: Column(
            children: <Widget>[
              bay10_video(),
              bay10_lwf(),
            ],
          )),
          Container(
            width: 10.0,
          ),
          Container(
              width: MediaQuery.of(context).size.width * .6,

              child: Column(
            children: <Widget>[
              bay14_video(),
              bay14_lwf(),
            ],
          )),
          Container(
            width: 10.0,
          ),
          Container(
              width: MediaQuery.of(context).size.width * .6,

              child: Column(
            children: <Widget>[
              nLwf_video(),
              nWall_lwf(),
            ],
          ))
        ],
      )
    );
  }

  Widget bay10_video(){
    return SizedBox(
      //width: MediaQuery.of(context).size.width * .8,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE&feature=emb_title')
      )
    );
  }

  Widget bay10_lwf(){
    return SizedBox(
        //width: MediaQuery.of(context).size.width * .8,
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
        //width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=V3JsFPQA6YQ&feature=emb_title')
        )
    );
  }

  Widget bay14_lwf(){
    return SizedBox(
        //width: MediaQuery.of(context).size.width * .8,
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
        //width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=VCluhS3RJpI&feature=emb_title')
        )
    );
  }

  Widget nWall_lwf(){
    return SizedBox(
        //width: MediaQuery.of(context).size.width * .8,
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

  Widget DWB_Intro() {
    return SizedBox(
        //width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
            padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    Container(
                        child: Text('Directional Wave Basin', style: TextStyle(fontSize: 30, color: Colors.white))
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  Widget DWB_Live() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
        height: MediaQuery.of(context).size.width * .6,
        child: ListView(
          scrollDirection:Axis.horizontal,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * .6,
                child: Column(
                  children: <Widget>[
                    nDwb_video(),
                    nWall_dwb()
                  ],
                )),
            Container(
              width: 10.0,
            ),
            Container(
                width: MediaQuery.of(context).size.width * .6,

                child: Column(
                  children: <Widget>[
                    wDwb_video(),
                    wWall_dwb()
                  ],
                )),
            Container(
              width: 10.0,
            ),
            Container(
                width: MediaQuery.of(context).size.width * .6,

                child: Column(
                  children: <Widget>[
                    nwDwb_video(),
                    nWCorner_dwb()
                  ],
                ))
          ],
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