import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/db_calls.dart';
import '../models/target_data.dart';
import '../widgets/set_target.dart';
import '../widgets/play_youtube.dart';
import '../widgets/change_darkmode.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class LargeWaveFlume extends StatefulWidget{

  LargeWaveFlumeState createState()=> LargeWaveFlumeState();

}

class LargeWaveFlumeState extends State<LargeWaveFlume> {

  final curDarkmode = new darkmode();
  List<targetData> _tDepthDataLwf = [];

  String username = "admin";
  int dropdownValue = 0;
  double _tDepthLwf;
  bool editTarget = false;
  bool editOffset = false;
  bool boolTarget = false;
  bool _darkmode;


  void getTDepthLwf(){
    dbCalls.getTDepthLwf().then((targetData) {
      setState(() {
        _tDepthDataLwf = targetData;
        _tDepthLwf = double.parse(_tDepthDataLwf[0].Tdepth);
      });
    });
  }

  void initState() {
    super.initState();
    getTDepthLwf();
    curDarkmode.initDarkmode();
    _darkmode = curDarkmode.getDarkmode();
    print("Darkmode: ${_darkmode}");
  }

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
              //mainAxisAlignment: MainAxisAlignment.center,
            ),
            lwf_intro(),
            fill_target(),
            if(boolTarget) hourOffset(),
            if(boolTarget) addTargetButton(),
            estimate_time(),
            lastFill(),
            lwf_barChart(),
            generalInfo(),
            live_view_intro(),
            bay10_video()
          ],
        )
    );
  }

  Widget lwf_intro(){
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
                        child: Text('Large Wave Flume', style: TextStyle(fontSize: 35, color: Colors.white))
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
                      onChanged: (value) => _tDepthLwf = double.parse(value),
                      decoration: InputDecoration(
                          labelText: '${_tDepthLwf}m',
                          labelStyle: TextStyle(color: Colors.red, fontSize: 20),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))),

                      keyboardType: TextInputType.number,
                  //controller: number,
                ))
                else Container(
                    child: Text(" ${_tDepthLwf}m", style: TextStyle(color: Colors.red, fontSize: 20))
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
                  boolTarget = true;
                  editTarget = true;
                });},
              )
            ],
          ),
        ],
      )
    );
  }

  Widget carouselOptions(String option, int curSlide) {
    return Container(
      child: Column(
          children: [
            if(curSlide == dropdownValue)Container(
                width: MediaQuery.of(context).size.width * .6,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    color: Colors.grey[800]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(option, style: TextStyle(color: Colors.white, fontSize: 20))
                  ],
                )
            )
            else Container(
                width: MediaQuery.of(context).size.width * .6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(option, style: TextStyle(color: Colors.white, fontSize: 20))
                  ],
                )                )
          ]
      )
    );
  }

  Widget carouselSlider(){
    return Container(
      width: MediaQuery.of(context).size.width * .6,
    //height: 150,
    child: CarouselSlider(

      options: CarouselOptions(
          height: 200,
          scrollDirection: Axis.vertical,
          aspectRatio: 12/9,
          viewportFraction: 0.15,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason){
            setState(() {
              dropdownValue = index;
            });
          }),

      items: <Widget>[
        carouselOptions("now", 0),
        carouselOptions("1 hour", 1),
        carouselOptions("2 hours", 2),
        carouselOptions("3 hours", 3),
        carouselOptions("4 hours", 4),
        carouselOptions("5 hours", 5),
        carouselOptions("6 hours", 6),
        carouselOptions("7 hours", 7),
        carouselOptions("8 hours", 8),
        carouselOptions("9 hours", 9),
        carouselOptions("10 hours", 10),
        carouselOptions("11 hours", 11),
        carouselOptions("12 hours", 12),
        carouselOptions("13 hours", 13),
        carouselOptions("14 hours", 14),
        carouselOptions("15 hours", 15),
        carouselOptions("16 hours", 16),
        carouselOptions("17 hours", 17),
        carouselOptions("18 hours", 18),
        carouselOptions("19 hours", 19),
        carouselOptions("20 hours", 20),
        carouselOptions("21 hours", 21),
        carouselOptions("22 hours", 22),
        carouselOptions("23 hours", 23),
        carouselOptions("24 hours", 24)
      ],
    ));
  }

  Widget hourOffset() {
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
                    if(editOffset) carouselSlider()
                    else if(dropdownValue != 0) Column(
                        children: <Widget>[
                          Text("Fill in ${dropdownValue} hours", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                        ]
                    )
                      else Column(
                      children: <Widget>[
                        Text("Fill now", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                      ],
                    )

                  ],

                )
              ],
            ),
            Column(
              children: <Widget>[
                if(editOffset) FlatButton(
                  child: Text("done", style: TextStyle(color: Colors.grey, fontSize: 20)),
                  //color: Colors.grey,
                  padding: EdgeInsets.all(0),
                  textColor: Colors.grey,
                  onPressed: () {setState(() {
                    print("Index: ${dropdownValue}");
                    editOffset = false;
                  });},
                )
                else FlatButton(
                  child: Text("edit", style: TextStyle(color: Colors.grey, fontSize: 20)),
                  //color: Colors.grey,
                  padding: EdgeInsets.all(0),
                  textColor: Colors.grey,
                  onPressed: () {setState(() {
                    boolTarget = true;
                    editOffset = true;
                  });},
                )
              ],
            ),
          ],
        )
    );
  }

  void addTarget() {
    editTarget = false;
    DateTime tDate = new DateTime.now();
    tDate = tDate.add(new Duration(hours: dropdownValue));
    dbCalls.addTarget(_tDepthLwf, 1, tDate, username, 0);
    setState(() {
      boolTarget = false;
      editOffset = false;
      editTarget = false;
    });
  }

  Widget addTargetButton() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              child: RaisedButton(
                child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () {setState(() {
                  boolTarget = false;
                  editOffset = false;
                  editTarget = false;
                });},
                    color: Colors.grey[800],
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  )
                ),
          Container(
              child: RaisedButton(
                child: Text("Done", style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: addTarget,
                color: Colors.grey[800],
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              )
          )
        ],
      ));
  }

  Widget estimate_time(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: <Widget>[
          Text("ETA", style: TextStyle(color: Colors.yellowAccent, fontSize: 20)),
          Text(" 3hrs", style: TextStyle(color: Colors.white, fontSize: 20))
        ],
      )
    );
  }

  Widget lastFill(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text("Last Filled to 6m", style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text("9:46 AM", style: TextStyle(color: Colors.grey[800], fontSize: 15))
              )
            ],
          )
        ],
      )
    );
  }

  Widget lwf_barChart(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        height: MediaQuery.of(context).size.width * .2,
        child: Container(
          color: Colors.yellowAccent
        )
    );
  }

  Widget generalInfo() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text("Fill Time", style: TextStyle(color: Colors.blue, fontSize: 15)),
              Text("12hrs", style: TextStyle(color: Colors.white, fontSize: 15))
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * .3, 0),
          ),
          Column(
            children: <Widget>[
              Text("Water Used", style: TextStyle(color: Colors.lightBlue, fontSize: 15)),
              Text("22,387 gal", style: TextStyle(color: Colors.white, fontSize: 15))
            ],
          )
        ],
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

  Widget bay10_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE&feature=emb_title')
        )
    );
  }
}