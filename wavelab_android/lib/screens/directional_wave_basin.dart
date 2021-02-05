import 'package:flutter/material.dart';
import '../widgets/set_target.dart';
import '../widgets/play_youtube.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class DirectionalWaveBasin extends StatefulWidget{

  DirectionalWaveBasinState createState()=> DirectionalWaveBasinState();

}

class DirectionalWaveBasinState extends State<DirectionalWaveBasin> {

  int dropdownValue = 0;
  TextEditingController newTargetDepth = TextEditingController();
  bool editTarget = false;
  int dTarget;
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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            dwb_intro(),
            fill_target(),
            estimate_time(),
            dwb_barChart(),
            live_view_intro(),
            nDwb_video(),
          ],
        )
    );
  }

  Widget dwb_intro(){
    return SizedBox(
      //width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Text('Directional Wave Basin', style: TextStyle(fontSize: 35, color: Colors.white))
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  Widget fill_target() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        //height: 100.0,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if(editTarget) Column(
                        children: <Widget>[
                          Text("Current Fill", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                          Text("Target ", style: TextStyle(color: Colors.white, fontSize: 20.0))
                        ]
                    )
                    else Text("Current Fill Target", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    if(editTarget) Container(
                        width: MediaQuery.of(context).size.width * .4,
                        padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                        height: 35,
                        child: TextField(
                          style: TextStyle(color: Colors.red),
                          //autofocus: true,
                          controller: newTargetDepth,
                          decoration: InputDecoration(
                              labelText: '${dTarget}m',
                              labelStyle: TextStyle(color: Colors.red, fontSize: 20),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))),

                          keyboardType: TextInputType.number,
                          //controller: number,
                        ))
                    else Container(
                        child: Text(" 6.0m", style: TextStyle(color: Colors.red, fontSize: 20))
                    )
                  ],

                )
              ],
            ),
            Column(
              children: <Widget>[
                if(editTarget) FlatButton(
                  child: Text("done", style: TextStyle(color: Colors.grey, fontSize: 20)),
                  //color: Colors.grey,
                  padding: EdgeInsets.all(0),
                  textColor: Colors.grey,
                  onPressed: () {setState(() {
                    editTarget = false;
                  });},
                )
                else FlatButton(
                  child: Text("edit", style: TextStyle(color: Colors.grey, fontSize: 20)),
                  //color: Colors.grey,
                  padding: EdgeInsets.all(0),
                  textColor: Colors.grey,
                  onPressed: () {setState(() {
                    editTarget = true;
                  });},
                )
              ],
            ),
          ],
        )
    );
  }

  Widget estimate_time(){
    return Container(
        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
        child: Row(
          children: <Widget>[
            Text("ETA", style: TextStyle(color: Colors.yellowAccent, fontSize: 20)),
            Text(" 3hrs", style: TextStyle(color: Colors.white, fontSize: 20))
          ],
        )
    );
  }

  Widget dwb_barChart(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        height: MediaQuery.of(context).size.width * .2,
        child: Container(

        )
    );
  }

  Widget live_view_intro(){
    return Container(
        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Live Views", style: TextStyle(color: Colors.white, fontSize: 20))
          ],
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
}