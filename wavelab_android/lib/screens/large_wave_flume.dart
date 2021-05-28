/***************************************************************
 * This file controls the large wave flume's screen. The main functions are to
 * display information about the flume, display the water depths in a graph and
 * set a new target depth to fill to. The user can only set a new target depth
 * if they are logged in. The user can scroll between times in the graph by
 * clicking a button to view previous water depths.
 **************************************************************/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import '../models/depth_data.dart';
import '../inheritable_data.dart';
import '../models/db_calls.dart';
import '../models/target_data.dart';
import '../models/user.dart';
import '../models/darkmode_state.dart';

// Large Wave Flume screen
class LargeWaveFlume extends StatefulWidget{

  LargeWaveFlumeState createState()=> LargeWaveFlumeState();

}

class LargeWaveFlumeState extends State<LargeWaveFlume> {

  List<targetData> _tDepthDataLwf = []; // Holds json response for target depth
  List<targetData> _prevTDepthDataLwf = []; // Holds json response for previous target depth that was completed
  List<depthData> _depthData = []; // Holds json response for depth data
  var graphLine = Map<DateTime, double>(); // Holds the depth data in a 4 hour range that will be shown on line graph
  //var graphData = Map<DateTime, double>(); // Holds all of the depth data
  var initGraphLine = Map<DateTime, double>(); // initial line that all points = 0.0 before DB data is received

  int seconds = 0, minutes = 0, hours = 0; // These are the duration that the flume has been filling for
  int dropdownValue = 0, graphDataMarker = 0;
  int etaHours = 0, etaMinutes = 0;
  double _tDepthLwf, depthHolder, _prevTarget;
  bool editTarget = false; //Bool that
  bool filling = false; // Bool that saves if the the flume will or is filling
  bool fillingRN = false; // Bool that saves if the flume is currently filling at the current moment
  bool editOffset = false; // Bool that opens the Hour offset carousell if the button is pressed
  bool boolTarget = false; // Bool that shows the buttons to add a new target depth to DB
  bool atEdge = true; // Bool that checks if line graph is showing data at an edge of the depth data
  bool boolFilling = false; // Bool that checks if user wants to start or stop filling without focus on target depth
  bool dbConnect = false, prevDBConnect = false;
  DateTime prevTargetDate; // Date when previous target depth was set
  DateTime now = new DateTime.now(); // Date when app is running
  DateTime dayCheck; // Date a day ago from when app is running
  DateTime latestDepth, earliestDepth;
  DateTime lineStart, lineEnd;
  Darkmode darkmodeClass; //
  User user;

  // Get current target depth from DB
  void getTDepthLwf(){
    dbCalls.getTDepthLwf().then((targetData) {
      if (this.mounted) {
        Timer(Duration(seconds: 1), ()
        {
          setState(() {
            dbConnect = true;
            _tDepthDataLwf = targetData;
            _tDepthLwf = double.parse(_tDepthDataLwf[0].Tdepth);
            if (int.parse(_tDepthDataLwf[0].isComplete) == 0) {
              filling = true;
              if (now.isBefore(DateTime.parse(_tDepthDataLwf[0].tDate)) != true)
                fillingRN = true;
              Duration fillTime = now.difference(
                  DateTime.parse(_tDepthDataLwf[0].tDate));
              int fullSeconds = fillTime.inSeconds;
              hours = (fullSeconds / 3600).toInt();
              fullSeconds = fullSeconds - (hours * 3600);
              minutes = (fullSeconds / 60).toInt();
              seconds = fullSeconds - (minutes * 60);
            }
          });
        });
      }
    });
  }

  // Get most recently completed target depth from DB
  void getPrevTLwf(){
    dbCalls.getPreviousTargetLwf().then((targetData) {
      Timer(Duration(seconds: 1), ()
      {
        setState(() {
          prevDBConnect = true;
          _prevTDepthDataLwf = targetData;
          _prevTarget = double.parse(_prevTDepthDataLwf[0].Tdepth);
          prevTargetDate = DateTime.parse(_prevTDepthDataLwf[0].tDate);
        });
      });
    });
  }

  // Get all depth data from DB for line graph
  void getGraphDepth(){
    DateTime start;
    DateTime end;
    dbCalls.getAllDepthLwf().then((depthData) {
      Timer(Duration(seconds: 1), ()
      {
        setState(() {
          _depthData = depthData;
          for (int i = 0; i < _depthData.length; i++) {
            DateTime date = DateTime.parse(_depthData[i].dDate);
            // Get the bounds for the data on the first line graph
            if (i == 0) {
              start = date;
              end = start.subtract(new Duration(hours: 4));
              latestDepth = date;
              lineStart = date;
              lineEnd = lineStart.subtract(new Duration(hours: 4));
            }
            // add data in the bounds to the line for the line graph
            if (date.isBefore(end) != true)
              graphLine[date] = double.parse(_depthData[i].depth);
            // Get the latest data available in DB
            if (i == (_depthData.length - 1))
              earliestDepth = date;
          }
        });
      });
    });
  }

  // inital line where all values equal 0.0 and will be used before DB response is recieved
  void initGraph(){
    DateTime now = new DateTime.now();
    initGraphLine[now] = 0.0;
    now = now.subtract(new Duration(hours: 2));
    initGraphLine[now] = 0.0;
    now = now.subtract(new Duration(hours: 2));
    initGraphLine[now] = 0.0;
  }

  // Calculate the time left in the filling process
  void calculateEta() {
    setState(() {
      dbCalls.getTDepthLwf().then((targetData) {
        double tempTDepth = double.parse(targetData[0].Tdepth);
        DateTime tempTDate = DateTime.parse(targetData[0].tDate);

        //if (this.mounted) {
        dbCalls.getCurDepthLwf().then((depthData) {
          double tempCurDepth = double.parse(depthData[0].depth);
          int hourOffset = 0;
          int minuteOffset = 0;
          Timer(Duration(seconds: 1), ()
          {
            if (now.isBefore(tempTDate)) {
              if(now.day < tempTDate.day){
                hourOffset = 24 - now.hour;
                hourOffset = hourOffset + tempTDate.hour;
              }
              else{
                hourOffset = tempTDate.hour - now.hour;
              }
              if(now.minute > tempTDate.minute) {
                minuteOffset = 60 - now.minute;
                minuteOffset = minuteOffset + tempTDate.minute;
              }
              else {
                minuteOffset = tempTDate.minute - now.minute;
              }            }
            setState(() {
              double etaLWF = (tempTDepth - tempCurDepth) * 3.2808399;
              etaHours = etaLWF.toInt() + hourOffset;
              double remainder = 10 * etaLWF.remainder(1);
              etaMinutes = remainder.toInt() + minuteOffset;
              double remainder2 = 10 * remainder.remainder(1);
              int round = remainder2.toInt();
              if (round >= 5)
                etaMinutes ++;
            });
          });
        });
      });
    });
  }

  // Init state for this screen
  void initState() {
    super.initState();
    //if (this.mounted) {
    setState(() {
      getTDepthLwf();
      getPrevTLwf();
      initGraph();
      getGraphDepth();
      calculateEta();
      dayCheck = now.subtract(new Duration(days: 1));
    });

    //}
    getTDepthLwf();
  }

  // Rebuild the screen when a new depth target is set
  void rebuildScreen(){
    setState(() {
      getTDepthLwf();
      getPrevTLwf();
      initGraph();
      getGraphDepth();
      calculateEta();
      dayCheck = now.subtract(new Duration(days: 1));
    });
  }

  // Get the darkmode state from inheritable widget
  void initDarkmode(){
    if (this.mounted) {
      setState(() {
        final dmodeContainer = StateContainer.of(context);
        darkmodeClass = dmodeContainer.darkmode;
        user = dmodeContainer.user;
      });
    }
  }

  Widget build(BuildContext context){
    initDarkmode();
    return SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
            start: 5.0,
            top: 10.0,
            end: 5.0,
            bottom: 10.0
        ),
        child: Column(
          children: <Widget>[
            lwf_intro(),
            fill_target(),
            // Show the buttons for editing if the user has signed in and clicks edit
            statusCurTarget(),
            Divider(
              color: darkmodeClass.darkmodeState ? Colors.white : Colors.black,
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),
            if(user.Name != "") setNewTarget(),
            if(user.Name != "") fillingNoTarget(),
            curDepth(),
            if(filling && etaHours >= 0 && etaMinutes >= 0)  estimate_time(),
            if(fillingRN) curFillTime(),
            lastFill(),
            lwf_lineChart(),
            switch_lineChart(),
            //generalInfo(),              Hardcoded right now
          ],
        )
    );
  }

  // The heading for the LWF screen
  Widget lwf_intro(){
    return SizedBox(
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Text('Large Wave Flume', style: TextStyle(fontSize: 35, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontWeight: FontWeight.bold))
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  // Displays current fill target
  Widget fill_target() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
        width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // If the editTarget bool equals true then the user can edit and the format of page changes
                Text("Current Fill Target: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
                // If user can edit the textfield appears for user
                if(dbConnect == false)
                  Text(" Generating", style: TextStyle(color: Colors.red, fontSize: 20))
                else if(_tDepthDataLwf.length < 1)
                  Text(" None", style: TextStyle(color: Colors.red, fontSize: 20))
                else
                  Text(" ${_tDepthLwf}m", style: TextStyle(color: Colors.red, fontSize: 20))
              ],
              )
            ],
          ),
        ],
      )
    );
  }

  // Displays each carousel option and styles each differently
  Widget carouselOptions(String option, int curSlide) {
    return Container(
      child: Column(
          children: [
            if(curSlide == dropdownValue)Container(
                width: MediaQuery.of(context).size.width * .6,
                height: 30,
                child: FlatButton(
                  color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Text(option, style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20)),
                  onPressed: () {
                    setState(() {
                      editOffset = false;
                    });},
                    )
            )
            else Container(
                width: MediaQuery.of(context).size.width * .6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(option, style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20))
                  ],
                )
            )
          ]
      )
    );
  }

  // Display carousel slider
  Widget carouselSlider(){
    return Container(
      width: MediaQuery.of(context).size.width * .6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            border: Border.all(
              color: Colors.red,
            ),
        ),
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
          // Options for hour offset carousel
          items: <Widget>[
            carouselOptions("0 hours", 0),
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
        )
    );
  }

  // Display the current hour offset with open carousell scroll for new target depth
  Widget openHourOffset() {
    return Container(
        width: MediaQuery.of(context).size.width * .4,
        padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Colors.red)
              ),
              child: Text("$dropdownValue hours", style: TextStyle(color: Colors.red, fontSize: 20)),
              onPressed: () {
                setState(() {
                  editOffset = true;
                });},
            )
          ],
        )
    );
  }

  // Display the current hour offset for new target depth
  Widget hourOffset() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        carouselSlider()
      ],
    );
  }

  // Add new target depth to DB
  void addTarget() {
    editTarget = false;
    DateTime tDate = new DateTime.now();
    tDate = tDate.add(new Duration(hours: dropdownValue));
    dbCalls.addTarget(_tDepthLwf, 1, tDate, user.Username, 0);
    setState(() {
      boolTarget = false;
      editOffset = false;
      editTarget = false;
    });
    rebuildScreen();
  }

  // Button to add target depth or cancel new target depth
  Widget addTargetButton() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              child: FlatButton(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(color: Colors.red)
                ),
                child: Text("Cancel", style: TextStyle(color: Colors.red, fontSize: 20)),
                onPressed: () {
                  setState(() {
                    boolTarget = false;
                    editOffset = false;
                    editTarget = false;
                    _tDepthLwf = depthHolder;
                  });},
              )
          ),
          Container(
              child: FlatButton(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(color: Colors.red)
                ),
                child: Text("Add Target", style: TextStyle(color: Colors.red, fontSize: 20)),
                onPressed: addTarget
              )
          )
        ],
      ));
  }

  Widget statusCurTarget(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            setBy(),
            fillingConfirm()
          ],
        )
    );
  }

  Widget setBy(){
    return Container(
        child: Row(
          children: <Widget>[
            Text("Set By: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20)),
            if(dbConnect == false)
              Text("Generating", style: TextStyle(color: Colors.red, fontSize: 20))
            else if(_tDepthDataLwf.length < 1)
              Text("None", style: TextStyle(color: Colors.red, fontSize: 20))
            else
              Text("${_tDepthDataLwf[0].username}", style: TextStyle(color: Colors.red, fontSize: 20))
          ],
        )
    );
  }

  // Display if the flume is currently filling or not
  Widget fillingConfirm(){
    return Container(
        child: Row(
          children: <Widget>[
            Text("Status: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20)),
            if(fillingRN)
              Text("Filling", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
            else
              Text("Not Filling", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
          ],
        )
    );
  }

  Widget newTarget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: [
          Text("New Depth Target: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20)),
          Container(
              width: MediaQuery.of(context).size.width * .4,
              padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
              height: 35,
              child: TextField(
                style: TextStyle(color: Colors.red),
                onChanged: (value) => _tDepthLwf = double.parse(value),
                decoration: InputDecoration(
                    labelText: '0.0m',
                    labelStyle: TextStyle(color: Colors.red, fontSize: 20),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))),
                keyboardType: TextInputType.number,
              )
          )
        ],
      )
    );
  }

  Widget setNewTarget(){
    return Column(
      children: [
        if(!boolTarget)
          FlatButton(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(color: Colors.red)
            ),
            child: Text("Set New Target", style: TextStyle(color: Colors.red, fontSize: 20)),
            onPressed: () {setState(() {
              depthHolder = _tDepthLwf;
              boolTarget = true;
              editTarget = true;
            });},
          )
        else Column(
          children: [
            newTarget(),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text("Delay start filling(in hours): ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
            ),
            if(editOffset)
              hourOffset()
            else
              openHourOffset(),
            addTargetButton(),
          ],
        ),
        Divider(
          color: darkmodeClass.darkmodeState ? Colors.white : Colors.black,
          thickness: 2,
          indent: 15,
          endIndent: 15,
        ),
      ],
    );
  }

  Widget controlFilling(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                child: FlatButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(color: Colors.red)
                  ),
                  child: Text("Stop Filling", style: TextStyle(color: Colors.red, fontSize: 20)),
                  onPressed: () {
                    setState(() {
                      dbCalls.stopFilling(1);
                      boolFilling = false;
                    });},
                )
            ),
            Container(
                child: FlatButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(color: Colors.red)
                  ),
                  child: Text("Start Filling", style: TextStyle(color: Colors.red, fontSize: 20)),
                  onPressed: () {
                    setState(() {
                      DateTime now = DateTime.now();
                      dbCalls.addTarget(100000, 1, now, user.Username, 0);
                      boolFilling = false;
                    });},
                )
            )
          ],
        ),
        IconButton(
          icon: const Icon(Icons.cancel_outlined),
          color: Colors.red,
          tooltip: 'Cancel',
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          iconSize: 50,
          onPressed: () {
            setState(() {
              boolFilling = false;
            });
          },
        ),
      ],
    );
  }

  Widget fillingNoTarget(){
    return Column(
      children: [
        if(!boolFilling) FlatButton(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: BorderSide(color: Colors.red)
          ),
          child: Text("Fill(No Target Depth)", style: TextStyle(color: Colors.red, fontSize: 20)),
          onPressed: () {setState(() {
            boolFilling = true;
          });},
        )
        else controlFilling(),
        Divider(
          color: darkmodeClass.darkmodeState ? Colors.white : Colors.black,
          thickness: 2,
          indent: 15,
          endIndent: 15,
        ),
      ],
    );
  }

  Widget curDepth(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          children: <Widget>[
            Text("Current Depth: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20)),
            if(_depthData.length < 1)
              Text("Generating", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
            else
              Text("${_depthData[0].depth}m", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20)),
          ],
        )
    );
  }

  // Display estimated time to finish current target depth goal
  Widget estimate_time(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          children: <Widget>[
            Text("ETA: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20)),
            if(_tDepthDataLwf.length < 1)
              Text("Generating", style: TextStyle(color: Colors.red, fontSize: 20))
            else
              Text("~$etaHours hours $etaMinutes minutes", style: TextStyle(color: Colors.red, fontSize: 20))
          ],
        )
    );
  }

  // If the flume is currently filling show the how long the flume has been filling for
  Widget curFillTime(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // If the json response isn't back from calling the DB then display generating
                Text("Current Fill Time: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20)),
                // If the json response isn't back from calling the DB then display generating
                if(dbConnect == false)
                  Text("Generating", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
                else if(_tDepthDataLwf.length < 1)
                  Text("None", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
                else if(minutes < 10)
                  Text("$hours:0$minutes:$seconds", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
                else if(seconds < 10)
                    Text("$hours:$minutes:0$seconds", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
                  else if(minutes < 10 && seconds < 10)
                      Text("$hours:0$minutes:0$seconds", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
                    else
                      Text("$hours:$minutes:$seconds", style: TextStyle(color: Color.fromRGBO(0, 175, 255, 1.0), fontSize: 20))
              ],
            )
          ],
        )
    );
  }

  // Display previous target depth that was completed
  Widget lastFill(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // If the json response isnt back from calling the DB then display generating
              Text("Last Filled Depth: ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
              // If the json response isn't back from calling the DB then display generating
              if(prevDBConnect == false)
                Text("Generating", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
              else if(_prevTDepthDataLwf.length < 1)
                Text("None", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
              else if(prevTargetDate.isAfter(dayCheck))
                Text("${_prevTarget}m at ${DateFormat('jm').format(prevTargetDate)}", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
              else
                Text("${_prevTarget}m ${DateFormat('Md').format(prevTargetDate)} at ${DateFormat('jm').format(prevTargetDate)}", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))

            ],
          ),
    );
  }

  // Display line chart
  Widget lwf_lineChart(){
    return Container(
        padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
        ),
        child: Column(
        children: <Widget>[
          // If the line data hasn't been grabbed then display initial line on graph
          if(graphLine.length < 1)
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
                height: 200,
                child: AnimatedLineChart(
                  LineChart.fromDateTimeMaps(
                      [initGraphLine], [Colors.blue], ["S"],
                      tapTextFontWeight: FontWeight.w400
                  )
                )
            )
          // If the line data is grabbed then display line
          else SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: 200,
              child: AnimatedLineChart(
                  LineChart.fromDateTimeMaps(
                      [graphLine], [Colors.blue], ['S'],
                      tapTextFontWeight: FontWeight.w400,
                  )
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if(lineStart == null)
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text("Generating date", style: TextStyle(color: Colors.black/*darkmodeClass.darkmodeState ? Colors.white : Colors.black*/, fontSize: 15))
                )
              else if(DateFormat('Md').format(lineStart) != DateFormat('Md').format(lineEnd))
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text("${DateFormat('Md').format(lineEnd)}/${DateFormat('Md').format(lineStart)}", style: TextStyle(color: Colors.black/*darkmodeClass.darkmodeState ? Colors.white : Colors.black*/, fontSize: 15))
                )
              else
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text("${DateFormat('Md').format(lineStart)}", style: TextStyle(color: Colors.black/*darkmodeClass.darkmodeState ? Colors.white : Colors.black*/, fontSize: 15))
                )
            ],
          )
        ],
      )
    );
  }

  // Increase time zone the line is grabbed from
  Widget increase_lineChart(){
    print("graphDataMarker: ${graphDataMarker}");

    int pos = 0;
    bool stop = false;
    double depth;
    DateTime date;
    setState(() {
      graphLine.clear();
      //date = DateTime.parse(_depthData[graphDataMarker].dDate);
      //depth = double.parse(_depthData[graphDataMarker].depth);
      while(stop == false) {
        date = DateTime.parse(_depthData[graphDataMarker].dDate);

        depth = double.parse(_depthData[graphDataMarker].depth);
        if(pos == 0){
          setState(() {
            lineStart = date;
            lineEnd = lineStart.add(new Duration(hours: 4));
          });
        }

        pos += 1;

        graphLine[date] = depth;
        if(date.isAfter(lineEnd) || graphDataMarker <= 0)
          stop = true;
        else
          graphDataMarker -= 1;

      }
      if(lineEnd.isAfter(latestDepth) || lineEnd == latestDepth) {
        atEdge = true;
      }
      else
        atEdge = false;
    });
  }

  // Decrease the time zone the line is grabbed from
  Widget decrease_lineChart(){
    DateTime test = DateTime.parse(_depthData[0].dDate);
    int pos = 0;
    bool stop = false;
    DateTime date;
    double depth;
    setState(() {
      graphDataMarker = graphDataMarker + graphLine.length - 1;
      graphLine.clear();
      date = DateTime.parse(_depthData[graphDataMarker + pos].dDate);
      depth = double.parse(_depthData[graphDataMarker + pos].depth);

      while(stop == false) {
        graphLine[date] = depth;

        if(pos == 0){
          setState(() {
            lineStart = date;
            lineEnd = lineStart.subtract(new Duration(hours: 4));
          });
        }
        pos += 1;
        date = DateTime.parse(_depthData[graphDataMarker + pos].dDate);
        depth = double.parse(_depthData[graphDataMarker + pos].depth);
        if(date.isBefore(lineEnd) || (graphDataMarker + pos) >= _depthData.length)
          stop = true;
      }
      if(lineEnd.isBefore(earliestDepth) || lineEnd == earliestDepth) {
        atEdge = true;
      }
      else
        atEdge = false;
    });
  }

  // Display buttons to move datetimes in direction pressed
  Widget switch_lineChart() {
    return Column(
      children: <Widget>[
        // If the time zone is at the edge then only show one of the buttons to scroll through depth graph
        if(atEdge)
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Scroll left if at the right edge
            if(graphDataMarker == 0)
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                ),
                label: Text('Scroll left', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
                icon: Icon(Icons.arrow_back_ios, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),
              onPressed: decrease_lineChart
            )
              // Scroll right if at the left edge
            else RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                label: Text('Scroll right', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
                icon: Icon(Icons.arrow_forward_ios, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),
              onPressed: increase_lineChart
            )
          ],
        )
          // Show both buttons if not at an edge
        else Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                label: Text('Scroll left', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
                icon: Icon(Icons.arrow_back_ios, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),
                onPressed: decrease_lineChart
            ),
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                label: Text('Scroll right', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
                icon: Icon(Icons.arrow_forward_ios, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),
                onPressed: increase_lineChart
            )
          ],
        )
      ],
    );
  }

  // Display gerenal info under line graph
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
              Text("12hrs", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * .3, 0),
          ),
          Column(
            children: <Widget>[
              Text("Water Used", style: TextStyle(color: Colors.lightBlue, fontSize: 15)),
              Text("22,387 gal", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
            ],
          )
        ],
      )
    );
  }
}