import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/set_target.dart';
import '../widgets/play_youtube.dart';
import '../widgets/app_drawer.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class DirectionalWaveBasin extends StatefulWidget{

  DirectionalWaveBasinState createState()=> DirectionalWaveBasinState();

}

class DirectionalWaveBasinState extends State<DirectionalWaveBasin> {

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
  Widget build(BuildContext context) {
    return AppHeader(
      header_title: 'Directional Wave Basin',
      body: DwbBody(),
    );
  }
}

class DwbBody extends StatefulWidget {

  DwbBodyState createState() => DwbBodyState();

}

class DwbBodyState extends State<DwbBody>{

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
            dwb_intro(),
            nDwb_video(),
            dwb_waterLevel(),
            dwb_graph(),
            dwb_setLevel(),
            wDwb_video(),
            nwDwb_video()
          ],
        )
    );
  }

  Widget dwb_intro(){
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
                      child: Text('Directional Wave Basin', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))
                  )
                ],
              )
            ],
          )
      )
    );
  }

  Widget nDwb_video(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Youtuber(url: 'https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title')
      )
    );
  }

  Widget dwb_waterLevel(){
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

  Widget dwb_graph(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.width * .2,
        child: Container(
            color: Colors.yellow,
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

  Widget dwb_setLevel(){
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
                            }).toList(),)
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

  Widget wDwb_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=xNzdOP3ixd4&feature=emb_title')
        )
    );
  }
  Widget nwDwb_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=Z7V0x92PpXU&feature=emb_title')
        )
    );
  }
}