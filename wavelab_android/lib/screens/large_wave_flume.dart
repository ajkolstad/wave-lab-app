import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  int dropdownValue = 0, graphDataMarker = 0;
  double _tDepthLwf, depthHolder, _prevTarget;
  bool editTarget = false; //Bool that
  bool editOffset = false; // Bool that opens the Hour offset carousell if the button is pressed
  bool boolTarget = false; // Bool that shows the buttons to add a new target depth to DB
  bool atEdge = true; // Bool that checks if line graph is showing data at an edge of the depth data
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
        setState(() {
          _tDepthDataLwf = targetData;
          _tDepthLwf = double.parse(_tDepthDataLwf[0].Tdepth);
        });
      }
    });
  }

  // Get most recently completed target depth from DB
  void getPrevTLwf(){
    dbCalls.getPreviousTargetLwf().then((targetData) {
      setState(() {
        _prevTDepthDataLwf = targetData;
        _prevTarget = double.parse(_prevTDepthDataLwf[0].Tdepth);
        prevTargetDate = DateTime.parse(_prevTDepthDataLwf[0].tDate);
      });
    });
  }

  // Get all depth data from DB for line graph
  void getGraphDepth(){
    DateTime start;
    DateTime end;
    dbCalls.getAllDepthLwf().then((depthData) {
      setState(() {
        _depthData = depthData;
        for(int i = 0; i < _depthData.length; i++){
          DateTime date = DateTime.parse(_depthData[i].dDate);
          // Get the bounds for the data on the first line graph
          if(i == 0) {
            start = date;
            latestDepth = date;
            lineStart = date;
            lineEnd = lineStart.subtract(new Duration(hours: 4));
            end = start.subtract(new Duration(hours: 4));
          }
          // add data in the bounds to the line for the line graph
          if(date.isBefore(end) != true)
            graphLine[date] = double.parse(_depthData[i].depth);
          // Get the latest data available in DB
          if(i == (_depthData.length - 1))
            earliestDepth = date;
          //graphData[date] = double.parse(_depthData[i].depth);
        }
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

  // Init state for this screen
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        getTDepthLwf();
        getPrevTLwf();
        initGraph();
        getGraphDepth();
        dayCheck = now.subtract(new Duration(days: 1));
      });
    }
    getTDepthLwf();
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
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
            ),
            lwf_intro(),
            fill_target(),
            // Show the buttons for editing if the user has signed in and clicks edit
            if(boolTarget) hourOffset(),
            if(boolTarget) addTargetButton(),
            estimate_time(),
            lastFill(),
            lwf_lineChart(),
            switch_lineChart(),
            generalInfo(),
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
                        child: Text('Large Wave Flume', style: TextStyle(fontSize: 35, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
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
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                if(editTarget) Column(
                  children: <Widget>[
                    Text("Current Fill", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
                    Text("Target ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0))
                  ]
                )
                else Text("Current Fill Target", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
                // If user can edit the textfield appears for user
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
              // If the user is signed in show the edit button
              if(user.Name != "" && editTarget != true) FlatButton(
                child: Text("edit", style: TextStyle(color: Colors.grey, fontSize: 20)),
                padding: EdgeInsets.all(0),
                textColor: Colors.grey,
                onPressed: () {setState(() {
                  depthHolder = _tDepthLwf;
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

  // Display the current hour offset for new target depth
  Widget hourOffset() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                // Display carousel slider if user pressed button and editOffset is true
                if(editOffset)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Fill in ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
                        carouselSlider()
                      ]
                  )
                // Display current hour offset in button
                else
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Fill in", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
                        Container(
                            width: MediaQuery.of(context).size.width * .4,
                            padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                        )
                      ]
                )
              ],
            ),
          ],
        )
    );
  }

  // Add new target depth to DB
  void addTarget() {
    editTarget = false;
    DateTime tDate = new DateTime.now();
    tDate = tDate.add(new Duration(hours: dropdownValue));
    dbCalls.addTarget(_tDepthLwf, 1, tDate, user.Name, 0);
    setState(() {
      boolTarget = false;
      editOffset = false;
      editTarget = false;
    });
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

  // Display estimated time to finish current target depth goal
  Widget estimate_time(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: <Widget>[
          Text("ETA", style: TextStyle(color: Colors.yellowAccent, fontSize: 20)),
          Text(" 3hrs", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20))
        ],
      )
    );
  }

  // Display previous target depth that was completed
  Widget lastFill(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // If the json response isnt back from calling the DB then display generating
              if(_prevTDepthDataLwf.length < 1)
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text("Generating last filled", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                )
              else
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text("Last Filled to ${_prevTarget}m", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15)),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // If the json response isnt back from calling the DB then display generating
              if(_prevTDepthDataLwf.length < 1)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("Generating date}", style: TextStyle(color: Colors.grey[800], fontSize: 15))
                )
              else if(prevTargetDate.isAfter(dayCheck))
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("${DateFormat('jm').format(prevTargetDate)}", style: TextStyle(color: Colors.grey[800], fontSize: 15))
                )
              else
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("${DateFormat('Md').format(prevTargetDate)} ${DateFormat('jm').format(prevTargetDate)}", style: TextStyle(color: Colors.grey[800], fontSize: 15))
                )
            ],
          )
        ],
      )
    );
  }

  // Display line chart
  Widget lwf_lineChart(){
    return Column(
      children: <Widget>[
        // If the line data hasn't been grabbed then display initial line on graph
        if(graphLine.length < 1)
          SizedBox(
            width: MediaQuery.of(context).size.width * .9,
              height: 200,
              child: AnimatedLineChart(
                  LineChart.fromDateTimeMaps(
                      [initGraphLine], [Colors.blue], ['S'],
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
                    tapTextFontWeight: FontWeight.w400
                )
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if(lineStart == null)
              Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text("Generating date", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
              )
            else if(DateFormat('Md').format(lineStart) != DateFormat('Md').format(lineEnd))
              Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text("${DateFormat('Md').format(lineEnd)}/${DateFormat('Md').format(lineStart)}", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
              )
            else
              Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text("${DateFormat('Md').format(lineStart)}", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 15))
              )
          ],
        )
      ],
    );
  }

  // Increase time zone the line is grabbed from
  Widget increase_lineChart(){
    int pos = 0;
    bool stop = false;
    double depth;
    DateTime date;
    setState(() {
      graphLine.clear();
      while(stop == false) {
        date = DateTime.parse(_depthData[graphDataMarker - pos].dDate);
        depth = double.parse(_depthData[graphDataMarker].depth);
        graphLine[date] = depth;
        graphDataMarker -= 1;
        if(pos == 0){
          setState(() {
            lineStart = date;
            lineEnd = lineStart.add(new Duration(hours: 4));
          });
        }
        pos += 1;

        if(date.isAfter(lineStart) || graphDataMarker < 0)
          stop = true;

      }
      if(lineStart.isAfter(earliestDepth))
        atEdge = true;
      else
        atEdge = false;
    });
  }

  // Decrease the time zone the line is grabbed from
  Widget decrease_lineChart(){
    int pos = 0;
    bool stop = false;
    DateTime date;
    double depth;
    setState(() {
      graphDataMarker = graphDataMarker + graphLine.length - 1;
      graphLine.clear();
      while(stop == false) {
        date = DateTime.parse(_depthData[graphDataMarker + pos].dDate);
        depth = double.parse(_depthData[graphDataMarker + pos].depth);
        graphLine[date] = depth;

        if(pos == 0){
          setState(() {
            lineStart = date;
            lineEnd = lineStart.subtract(new Duration(hours: 4));
          });
        }
        pos += 1;
        if(date.isBefore(lineEnd) || (graphDataMarker + pos) >= _depthData.length)
          stop = true;
      }
      if(lineEnd.isBefore(latestDepth))
        atEdge = true;
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