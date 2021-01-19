import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/set_target.dart';
import '../widgets/play_youtube.dart';
import '../widgets/app_drawer.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class LargeWaveFlume extends StatefulWidget{

  LargeWaveFlumeState createState()=> LargeWaveFlumeState();

}

class LargeWaveFlumeState extends State<LargeWaveFlume> {

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
      body: LwfBody(),
    );
  }

}

class LwfBody extends StatefulWidget {

  LwfBodyState createState() => LwfBodyState();

}

class LwfBodyState extends State<LwfBody>{

  int dropdownValue = 0;
  int dTarget;

  Widget build(BuildContext context){
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(
        start: 5.0,
        top: 10.0,
        end: 5.0,
        bottom: 10.0
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          lwf_intro(),
          bay10_video(),
          lwf_waterLevel(),
          lwf_graph(),
          lwf_setLevel(),
          wLwf_video(),
          nLwf_video()
        ],
      )
    );
  }

  Widget lwf_intro(){
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
                        child: Text('Large Wave Flume', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))
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
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE&feature=emb_title')
      )
    );
  }

  Widget lwf_waterLevel(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Current Status', style: TextStyle(color: Colors.lightBlue))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Currently 20.0m', style: TextStyle(fontSize: 25))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Filling To 27.0m', style: TextStyle(fontSize: 15, color: Colors.grey[400]))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Set at Sat 12:20', style: TextStyle(color: Colors.lightBlue))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Set by Birdy', style: TextStyle(color: Colors.lightBlue))
                        )
                      ]
                  ),
                ]
            )

        )

    );
  }

  Widget lwf_graph(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.width * .2,
        child: Container(
            color: Colors.yellow[500],
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Text('Graph Goes Here', style: TextStyle(fontSize: 20, color: Colors.white))
                      )
                    ]
                ),
              ],
            )
        )
    );
  }

  Widget lwf_setLevel(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Set New Target', style: TextStyle(color: Colors.lightBlue))
                        )
                      ]
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Depth Target')
                        )
                      ]
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          width: 280,
                          height: 35,
                          child: TextField(
                            //autofocus: true,
                            decoration: InputDecoration(border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            onChanged: (newVal) {
                              dTarget = int.parse(newVal);
                            }
                            //controller: number,
                          )
                      )
                    ],
                  ),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text('Hour Offset')
                        )
                      ]
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          //width: 280,
                          //height: 35,
                          child: DropdownButton<int>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (int newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                              },
                            items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
                                .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value'),
                                  );
                                }).toList(),
                          )
                      )
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,

                          child: Container(
                            //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: FlatButton(
                              child: Text('Set Target'),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              onPressed: () {setTarget(dropdownValue, dTarget);},
                            )
                        )
                        )
                      ]
                  ),
                ]
            )
        )
    );
  }

  Widget wLwf_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=V3JsFPQA6YQ&feature=emb_title')
        )
    );
  }

  Widget nLwf_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=VCluhS3RJpI&feature=emb_title')
        )
    );
  }

}