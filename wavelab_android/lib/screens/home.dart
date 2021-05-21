/**************************************************************
 * This file displays the critical data about both flumes and displays live
 * views of each flume from different angles. The data displayed are the current
 * target depth level, the current water depth, and an eta of when the filling
 * will be complete
 *************************************************************/
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../inheritable_data.dart';
import '../widgets/play_youtube.dart';
import '../models/darkmode_state.dart';
import '../models/db_calls.dart';
import '../models/depth_data.dart';
import '../models/target_data.dart';

// Home screen
class Home extends StatefulWidget{

  HomeState createState()=> HomeState();

}

class HomeState extends State<Home> {

  List<depthData> _curDepthDataLwf = [];
  List<depthData> _curDepthDataDwb = [];
  List<targetData> _tDepthDataLwf = [];
  List<targetData> _tDepthDataDwb = [];
  bool afterLwf = false, afterDwb = false;
  double _curDepthLwf, _curDepthDwb, _tDepthLwf, _tDepthDwb;
  int isCompleteLwf = 0, isCompleteDwb = 0;
  int hoursLwf = 0, minutesLwf = 0, secondsLwf = 0, hoursDwb = 0, minutesDwb = 0, secondsDwb = 0;
  DateTime curTime = new DateTime.now();
  DateTime dateLwf, dateDwb, curTimeLwf, curTimeDwb;
  Darkmode darkmodeClass;

  // Grabs the current depth data for the large wave flume
  void getCurDepthLwf() {
    print("in");
    dbCalls.getCurDepthLwf().then((depthData) {
      //if (this.mounted) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          _curDepthDataLwf = depthData;
          _curDepthLwf = double.parse(_curDepthDataLwf[0].depth);
          curTimeLwf = DateTime.parse(_curDepthDataLwf[0].dDate);
          print("curTimeLwf: ${curTimeLwf.hour}");
        });
      });
    });
  }

  // Grabs the current depth data for the directional wave basin
  void getCurDepthDwb(){
    dbCalls.getCurDepthDwb().then((depthData) {
      Timer(Duration(seconds: 1), () {
        if (this.mounted) {
          setState(() {
            _curDepthDataDwb = depthData;
            _curDepthDwb = double.parse(_curDepthDataDwb[0].depth);
            curTimeDwb = DateTime.parse(_curDepthDataDwb[0].dDate);
            print("curTimeDwb: ${curTimeDwb.hour}");
          });
        }
      });
    });
  }

  // Grabs the most recent target depth data for the large wave flume
  void getTDepthLwf(){
    dbCalls.getTDepthLwf().then((targetData) {
      //if (this.mounted) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          _tDepthDataLwf = targetData;
          _tDepthLwf = double.parse(_tDepthDataLwf[0].Tdepth);
          dateLwf = DateTime.parse(_tDepthDataLwf[0].tDate);
          if(dateLwf.isAfter(curTime))
            afterLwf = true;
          print("dateLwf: ${dateLwf.hour}");
          isCompleteLwf = int.parse(_tDepthDataLwf[0].isComplete);
          print("_tDepth: ${_tDepthDataLwf[0].isComplete}");
        });
      });
    });
  }

  // Grabs the most recent target depth data for the directional wave basin
  void getTDepthDwb(){
    dbCalls.getTDepthDwb().then((targetData) {
      //if (this.mounted) {
      Timer(Duration(seconds: 1), () {

        setState(() {
          _tDepthDataDwb = targetData;
          print("_tDepth: ${_tDepthDataDwb[0].isComplete}");
          _tDepthDwb = double.parse(_tDepthDataDwb[0].Tdepth);
          dateDwb = DateTime.parse(_tDepthDataDwb[0].tDate);
          if(dateDwb.isAfter(curTime))
            afterDwb = true;
          print("dateDwb: ${dateDwb.hour}");
          isCompleteDwb = int.parse(_tDepthDataDwb[0].isComplete);
        });
      });
    });
  }

  void calculateEtaLwf() {
    setState(() {
      dbCalls.getTDepthLwf().then((targetData) {
        double tempTDepth = double.parse(targetData[0].Tdepth);
        DateTime tempTDate = DateTime.parse(targetData[0].tDate);
        print("_tDepthDwb: $tempTDepth");

        //if (this.mounted) {
        dbCalls.getCurDepthLwf().then((depthData) {
          double tempCurDepth = double.parse(depthData[0].depth);
          Timer(Duration(seconds: 1), ()
          {
            setState(() {
              double etaLWF = (tempTDepth - tempCurDepth) * 0.0328085;
              int hourOffset = 0;
              int minuteOffset = 0;
              DateTime now = new DateTime.now();
              while(tempTDate == null)
                Timer(Duration(seconds: 1), (){});
              print("lwfcurTime: ${now.hour}");
              print("lwftempTDate: ${tempTDate.hour}");
              if (now.isBefore(tempTDate)) {
                if(now.minute > tempTDate.minute) {
                  minuteOffset = 60 - now.minute;
                  minuteOffset = minuteOffset + tempTDate.minute;
                }
                else {
                  minuteOffset = tempTDate.minute - now.minute;
                }
                if(now.day < tempTDate.day){
                  hourOffset = 24 - now.hour;
                  hourOffset = hourOffset + tempTDate.hour;
                }
                else
                  hourOffset = tempTDate.hour - now.hour;
              }
              hoursLwf = etaLWF.toInt() + hourOffset;
              double remainder = 10 * etaLWF.remainder(1);
              minutesLwf = remainder.toInt() + minuteOffset;
              double remainder2 = 10 * remainder.remainder(1);
              int round = remainder2.toInt();
              if (round >= 5)
                minutesLwf ++;
            });
          });
        });
        //}
      });
    });
  }

  void calculateEtaDwb() {
    setState(() {
      dbCalls.getTDepthDwb().then((targetData) {
          double tempTDepth = double.parse(targetData[0].Tdepth);
          DateTime tempTDate = DateTime.parse(targetData[0].tDate);
          print("_tDepthDwb: $tempTDepth");

        //if (this.mounted) {
        dbCalls.getCurDepthDwb().then((depthData) {
            double tempCurDepth = double.parse(depthData[0].depth);
            print("tempCurDepth: $tempCurDepth");
            Timer(Duration(seconds: 1), () {
              setState(() {
                double etaDWB = 2 * ((tempTDepth - tempCurDepth) * 0.0328085);
                int hourOffset = 0;
                int minuteOffset = 0;
                DateTime now = new DateTime.now();
                while(tempTDate == null)
                  Timer(Duration(seconds: 1), (){});
                print("dwbcurTime: ${now.hour}");
                print("dwbtempTDate: ${tempTDate.hour}");
                if (now.isBefore(tempTDate)) {
                  print("dwb1");
                  if(now.minute > tempTDate.minute) {
                    minuteOffset = 60 - now.minute;
                    minuteOffset = minuteOffset + tempTDate.minute;
                  }
                  else {
                    minuteOffset = tempTDate.minute - now.minute;
                  }
                  print("dwb2");
                  if(now.day < tempTDate.day){
                    hourOffset = 24 - now.hour;
                    hourOffset = hourOffset + tempTDate.hour;
                  }
                  else
                    hourOffset = tempTDate.hour - now.hour;
                }
                print("etaDWB: $etaDWB");
                hoursDwb = etaDWB.toInt() + hourOffset;
                double remainder = 10 * etaDWB.remainder(1);
                minutesDwb = remainder.toInt() + minuteOffset;
                double remainder2 = 10 * remainder.remainder(1);
                int round = remainder2.toInt();
                if (round >= 5)
                  minutesDwb ++;
              });
            });
          });
        //}
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        getCurDepthLwf();
        getCurDepthDwb();
        getTDepthLwf();
        getTDepthDwb();
        calculateEtaLwf();
        calculateEtaDwb();
      });

      print("currentTime: ${curTime}");
    }
  }

  // initializes the darkmode of the screen
  void initDarkmode(){
    if (this.mounted) {
      setState(() {
        final dmodeContainer = StateContainer.of(context);
        darkmodeClass = dmodeContainer.darkmode;
        //_darkmode = darkmodeClass.darkmodeState;
      });
    }
  }

  // Builds the home screen
  Widget build(BuildContext context){
    initDarkmode();
    //initState();
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
            Lwf_Container(),
            Dwb_Container()
          ],
        )
    );
  }

  // Gets the live youtube stream using the url given to the function
  Widget liveVideo(String url) {
    return Container(
      //height: 250,
      //width: MediaQuery.of(context).size.width * .8,
        child: Column(
            children: [
              Container(
                  child: Youtuber(url: url)
              )
            ]
        )
    );
  }

  // introduces the home screen
  Widget intro_section(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: Container(
            //margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            //mainAxisAlignment: MainAxisAlignment.center,
                            //color: Color.fromRGBO(214, 214, 214, 1),
                            child: Text('Home', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 40, fontWeight: FontWeight.bold))
                        )
                      ]
                  ),
                ]
            )
        )
    );
  }

  // Provides information for the large wave flume
  Widget Lwf_Container(){
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        decoration: BoxDecoration(
        color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
        width: MediaQuery.of(context).size.width * .9,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Large Wave Flume", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0,10,0,5),
                  child: Text("Status: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                ),
                if(_tDepthDataLwf.length < 1)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Generating", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                  )
                else if(isCompleteLwf == 1 && _curDepthLwf >= _tDepthLwf)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Filling Complete", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                  )
                else if(isCompleteLwf == 1)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Not Filling", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                  )
                else if(afterLwf)
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("Waiting to fill ", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("to ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("${_tDepthLwf}cm", style: TextStyle(color: Colors.red, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("at ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("${DateFormat('jm').format(dateLwf)}", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                      )
                    ],
                  )
                else
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("Filling ", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("to ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("${_tDepthLwf}m ", style: TextStyle(color: Colors.red, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("now", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                      )
                    ]
                  )
              ]

            ),
            // Prints the current depth of the large wave flume
            if(isCompleteLwf == 0)
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text("ETA: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                  ),
                  if(_tDepthDataLwf.length < 1)
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text("Generating", style: TextStyle(color: Colors.red, fontSize: 15))
                    )
                  else
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Text("~ $hoursLwf hours $minutesLwf minutes", style: TextStyle(color: Colors.red, fontSize: 15)),
                    ),
                ]
            ),
            // Prints the current depth of the large wave flume
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("Current Depth: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                  ),
                  if(_curDepthLwf == null)
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text("Generating", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                    )
                  else
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text("${_curDepthLwf}m ", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text("at ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text("${DateFormat('jm').format(curTimeLwf)}", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                        )
                      ],
                    )

                ]
            ),
          Container(
              width: MediaQuery.of(context).size.width * .9,

              // sets up a carousel slider with the live steam videos for the large wave flume
              child: CarouselSlider(
              options: CarouselOptions(aspectRatio: 16/9/*height: (MediaQuery.of(context).size.height * 0.23)173*/, autoPlay: false, enableInfiniteScroll: false, enlargeCenterPage: true),
              items: [
                liveVideo('https://www.youtube.com/watch?v=ciioaETC6wE&feature=emb_title'),
                liveVideo('https://www.youtube.com/watch?v=V3JsFPQA6YQ&feature=emb_title'),
                liveVideo('https://www.youtube.com/watch?v=VCluhS3RJpI&feature=emb_title')
              ])
          )
        ]
        )
    );
  }

  // Provides data for the directional wave basin
  Widget Dwb_Container() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        decoration: BoxDecoration(
          color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
      width: MediaQuery.of(context).size.width * .9,
      child: Column(
        children: <Widget>[
          // Introduces the directional wave basin
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Directional Wave Basin", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0,10,0,5),
                child: Text("Status: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
              ),
              if(_tDepthDataDwb.length < 1)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Generating", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                )
              else if(isCompleteDwb == 1 && _curDepthDwb >= _tDepthDwb)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Filling Complete", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                )
              else if(isCompleteDwb == 1)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Not Filling", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                )
              else if(afterDwb)
                Row(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text("Waiting to fill ", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text("to ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("${_tDepthDwb}cm ", style: TextStyle(color: Colors.red, fontSize: 15))
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text("at ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text("at ${DateFormat('jm').format(dateDwb)}", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                    )
                  ],
                )
              else
                Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("Filling ", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("to ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("${_tDepthDwb}m ", style: TextStyle(color: Colors.red, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text("now", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                      )
                    ]
                )
            ]
          ),
          if(isCompleteDwb == 0)
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text("ETA: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                  ),
                  if(_tDepthDataDwb.length < 1)
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text("Generating", style: TextStyle(color: Colors.red, fontSize: 15))
                    )
                  else
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Text("~ $hoursDwb hours $minutesDwb minutes", style: TextStyle(color: Colors.red, fontSize: 15))
                    ),
                ]
            ),
          // Prints the current depth of the directional wave basin
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text("Current Depth: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                ),
                if(_curDepthDwb == null)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text("Generating", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                  )
                else
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text("${_curDepthDwb}m ", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text("at ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text("${DateFormat('jm').format(curTimeDwb)}", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 15))
                      )
                    ],
                  )
              ]
          ),
          Container(
              width: MediaQuery.of(context).size.width * .9,

              // sets up a carousel slider with the live steam videos for the directional wave basin
              child: CarouselSlider(
                  options: CarouselOptions(aspectRatio: 16/9/*height: (MediaQuery.of(context).size.height * 0.266)173*/, autoPlay: false, enableInfiniteScroll: false, enlargeCenterPage: true),
                  items: [
                    liveVideo('https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title'),
                    liveVideo('https://www.youtube.com/watch?v=xNzdOP3ixd4&feature=emb_title'),
                    liveVideo('https://www.youtube.com/watch?v=Z7V0x92PpXU&feature=emb_title')
                  ])
          )
        ],
      )
    );
  }
}