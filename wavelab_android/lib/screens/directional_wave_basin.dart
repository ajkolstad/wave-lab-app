import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/depth_data.dart';
import '../inheritable_data.dart';
import '../models/db_calls.dart';
import '../models/target_data.dart';
import '../models/user.dart';
import '../models/darkmode_state.dart';
import '../widgets/play_youtube.dart';

class DirectionalWaveBasin extends StatefulWidget{

  DirectionalWaveBasinState createState()=> DirectionalWaveBasinState();

}

class DirectionalWaveBasinState extends State<DirectionalWaveBasin> {
  List<targetData> _tDepthDataDwb = [];
  List<targetData> _prevTDepthDataDwb = [];
  List<depthData> _depthData = [];
  var graphLine = Map<DateTime, double>();
  var initGraphLine = Map<DateTime, double>(); // initial line that all points = 0.0 before DB data is received

  int dropdownValue = 0, graphDataMarker = 0;
  double _tDepthDwb, _prevTarget, depthHolder;
  bool editTarget = false; // Bool that opens the Hour offset carousell if the button is pressed
  bool editOffset = false;
  bool boolTarget = false; // Bool that shows the buttons to add a new target depth to DB
  bool atEdge = true; // Bool that checks if line graph is showing data at an edge of the depth data
  DateTime prevTargetDate;// Date when previous target depth was set
  DateTime dayCheck; // Date a day ago from when app is running
  DateTime now = new DateTime.now(); // Date when app is running
  DateTime latestDepth, earliestDepth;
  DateTime lineStart, lineEnd;
  Darkmode darkmodeClass;
  User user;


  void getTDepthDwb(){
    dbCalls.getTDepthDwb().then((targetData) {
      setState(() {
        _tDepthDataDwb = targetData;
        _tDepthDwb = double.parse(_tDepthDataDwb[0].Tdepth);
      });
    });
  }

  void getPrevTDwb(){
    dbCalls.getPreviousTargetDwb().then((targetData) {
      setState(() {
        _prevTDepthDataDwb = targetData;
        _prevTarget = double.parse(_prevTDepthDataDwb[0].Tdepth);
        prevTargetDate = DateTime.parse(_prevTDepthDataDwb[0].tDate);
        //print("prevTargetDate: ${prevTargetDate}");
      });
    });
  }

  void getGraphDepth(){
    DateTime start;
    DateTime end;
    dbCalls.getAllDepthDwb().then((depthData) {
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

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        getTDepthDwb();
        getPrevTDwb();
        getGraphDepth();
        initGraph();
        dayCheck = now.subtract(new Duration(days: 1));
      //  print("dayCheck: ${dayCheck}");
      });
    }
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            dwb_intro(),
            fill_target(),
            if(boolTarget) hourOffset(),
            if(boolTarget) addTargetButton(),
            estimate_time(),
            lastFill(),
            dwb_lineChart(),
            switch_lineChart(),
            generalInfo(),
            //live_view_intro(),
            //nDwb_video(),
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
                        child: Text('Directional Wave Basin', style: TextStyle(fontSize: 35, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
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
                          Text("Current Fill", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
                          Text("Target ", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0))
                        ]
                    )
                    else Text("Current Fill Target", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0)),
                    if(editTarget) Container(
                        width: MediaQuery.of(context).size.width * .4,
                        padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                        height: 35,
                        child: TextField(
                          style: TextStyle(color: Colors.red),
                          //autofocus: true,
                          onChanged: (value) => _tDepthDwb = double.parse(value),
                          decoration: InputDecoration(
                              labelText: '${_tDepthDwb}m',
                              labelStyle: TextStyle(color: Colors.red, fontSize: 20),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))),

                          keyboardType: TextInputType.number,
                          //controller: number,
                        ))
                    else Container(
                        child: Text(" ${_tDepthDwb}m", style: TextStyle(color: Colors.red, fontSize: 20))
                    )
                  ],

                )
              ],
            ),
            Column(
              children: <Widget>[
                if(user.Name != "" &&  editTarget != true) FlatButton(
                  child: Text("edit", style: TextStyle(color: Colors.grey, fontSize: 20)),
                  padding: EdgeInsets.all(0),
                  textColor: Colors.grey,
                  onPressed: () {setState(() {
                    depthHolder = _tDepthDwb;
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

  void addTarget() {
    editTarget = false;
    DateTime tDate = new DateTime.now();
    tDate = tDate.add(new Duration(hours: dropdownValue));
    dbCalls.addTarget(_tDepthDwb, 0, tDate, user.Name, 0);
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
                      _tDepthDwb = depthHolder;
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

  Widget lastFill(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if(_prevTDepthDataDwb.length < 1)
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
                if(_prevTDepthDataDwb.length < 1)
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

  Widget dwb_lineChart(){
    return Column(
      children: <Widget>[
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

  Widget increase_lineChart(){
    int pos = 0, holder;
    bool stop = false;
    double depth;
    DateTime date;
    setState(() {
      graphLine.clear();
      while(stop == false) {
        date = DateTime.parse(_depthData[graphDataMarker].dDate);
        print('date: $date');
        depth = double.parse(_depthData[graphDataMarker].depth);
        graphLine[date] = depth;
        if(pos == 0){
          setState(() {
            lineEnd = date;
            lineStart = lineEnd.add(new Duration(hours: 4));
          });
        }
        graphDataMarker -= 1;
        pos += 1;
        if(date.isAfter(lineStart) || (graphDataMarker) < 0)
          stop = true;
      }
      if(lineStart.isAfter(earliestDepth))
        atEdge = true;
      else
        atEdge = false;
    });
  }

  Widget decrease_lineChart(){
    int pos = 0;
    bool stop = false;
    DateTime date, lineStart, lineEnd;
    double depth;
    setState(() {
      print("graphDataMarker: $graphDataMarker");
      print("Length: ${graphLine.length}");
      graphDataMarker = graphDataMarker + graphLine.length - 1;
      print("new graphDataMarker: $graphDataMarker");
      graphLine.clear();
      while(stop == false) {
        date = DateTime.parse(_depthData[graphDataMarker + pos].dDate);
        print("date: $date");
        depth = double.parse(_depthData[graphDataMarker + pos].depth);
        graphLine[date] = depth;
        if(pos == 0) {
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
        if(atEdge)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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

  Widget live_view_intro(){
    return Container(
        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Live View : North Wall", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20))
          ],
        )
    );
  }

  Widget nDwb_video(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Youtuber(url: 'https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title')
        )
    );
  }
}