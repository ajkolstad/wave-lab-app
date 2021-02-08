import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/play_youtube.dart';
import '../widgets/change_darkmode.dart';
import '../models/db_calls.dart';
import '../models/depth_data.dart';
import '../models/target_data.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget{

  HomeState createState()=> HomeState();

}

class HomeState extends State<Home> {

  List<depthData> _curDepthDataLwf = [];
  List<depthData> _curDepthDataDwb = [];
  List<targetData> _tDepthDataLwf = [];
  List<targetData> _tDepthDataDwb = [];
  double _curDepthLwf;
  double _curDepthDwb;
  double _tDepthLwf;
  double _tDepthDwb;
  DateTime curTime = new DateTime.now();
  DateTime dateLwf;
  DateTime dateDwb;
  //bool _darkmode;
  //final curDarkmode = new darkmode();

  void getCurDepthLwf() {
    dbCalls.getCurDepthLwf().then((depthData) {
      setState(() {
        _curDepthDataLwf = depthData;
        _curDepthLwf = double.parse(_curDepthDataLwf[0].depth);
      });
    });
  }

  void getCurDepthDwb(){
    dbCalls.getCurDepthDwb().then((depthData) {
      setState(() {
        _curDepthDataDwb = depthData;
        _curDepthDwb = double.parse(_curDepthDataDwb[0].depth);
      });
    });
  }

  void getTDepthLwf(){
    dbCalls.getTDepthLwf().then((targetData) {
      setState(() {
        _tDepthDataLwf = targetData;
        _tDepthLwf = double.parse(_tDepthDataLwf[0].Tdepth);
        dateLwf = DateTime.parse(_tDepthDataLwf[0].tDate);
      });
    });
  }

  void getTDepthDwb(){
    dbCalls.getTDepthDwb().then((targetData) {
      setState(() {
        _tDepthDataDwb = targetData;
        _tDepthDwb = double.parse(_tDepthDataDwb[0].Tdepth);
        dateDwb = DateTime.parse(_tDepthDataDwb[0].tDate);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurDepthLwf();
      //print("depth: ${_curDepthLwf}");
      getCurDepthDwb();
      //print("2: ${_curDepthDwb}");
      getTDepthLwf();
      getTDepthDwb();
    });
    print("currentTime: ${curTime}");
    /*setState(() {
      curDarkmode.initDarkmode();
      _darkmode = curDarkmode.getDarkmode();
    });*/
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
                            child: Text('Home', style: TextStyle(color: Colors.white, fontSize: 40))
                        )
                      ]
                  ),
                ]
            )
        )
    );
  }

  Widget Lwf_Container(){
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        decoration: BoxDecoration(
        color: Colors.grey[800],
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
        //color: Colors.grey[800],
        width: MediaQuery.of(context).size.width * .9,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Large Wave Basin", style: TextStyle(color: Colors.white, fontSize: 20.0))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if(_tDepthDataLwf[0].isComplete == 1 && _curDepthLwf >= _tDepthLwf)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Filling Complete", style: TextStyle(color: Colors.white),)
                  )
                else if(_tDepthDataLwf[0].isComplete == 1)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Not Filling", style: TextStyle(color: Colors.white),)
                  )
                else if(dateLwf.isAfter(curTime))
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text("Waiting to fill to ${_tDepthLwf}m at ${DateFormat('jm').format(dateLwf)}", style: TextStyle(color: Colors.white),)
                    )
                else
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Filling to ${_tDepthLwf}m now", style: TextStyle(color: Colors.white),)
                  )
              ]

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("Currently ${_curDepthLwf}m", style: TextStyle(color: Colors.white))
            )]),
            Container(
                width: MediaQuery.of(context).size.width * .9,
                child: Container(
                    //margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE')
                )
            )
          ],
        )
    );
  }

  Widget Dwb_Container() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        decoration: BoxDecoration(
          color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
      //color: Colors.grey[800],
      width: MediaQuery.of(context).size.width * .9,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Directional Wave Basin", style: TextStyle(color: Colors.white, fontSize: 20.0))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if(_tDepthDataDwb[0].isComplete == 1 && _curDepthDwb >= _tDepthDwb)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Filling Complete", style: TextStyle(color: Colors.white),)
                )
              else if(_tDepthDataDwb[0].isComplete == 1)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Not Filling", style: TextStyle(color: Colors.white),)
                )
              else if(dateDwb.isAfter(curTime))
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Waiting to fill to ${_tDepthDwb}m at ${DateFormat('jm').format(dateDwb)}", style: TextStyle(color: Colors.white),)
                )
              else
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Filling to ${_tDepthDwb}m now", style: TextStyle(color: Colors.white),)
                )
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text("Currently ${_curDepthDwb}m", style: TextStyle(color: Colors.white))
              )
            ]
          ),
          Container(
              width: MediaQuery.of(context).size.width * .9,
              child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Youtuber(url: 'https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title')
              )
          )
        ],
      )
    );
  }
}