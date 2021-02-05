import 'package:flutter/material.dart';
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

  List<depthData> _curDepthDataLwf;
  List<depthData> _curDepthDataDwb;
  List<targetData> _tDepthDataLwf;
  List<targetData> _tDepthDataDwb;
  String _curDepthLwf = "";
  String _curDepthDwb = "";
  String _tDepthLwf = "";
  String _tDepthDwb = "";
  DateTime date;
  //bool _darkmode;
  //final curDarkmode = new darkmode();

  getCurDepthLwf() {
    dbCalls.getCurDepthLwf().then((depthData) {
      setState(() {
        _curDepthDataLwf = depthData;
        _curDepthLwf = _curDepthDataLwf[0].depth;
      });
    });
  }

  getCurDepthDwb(){
    dbCalls.getCurDepthDwb().then((depthData) {
      setState(() {
        _curDepthDataDwb = depthData;
        _curDepthDwb = _curDepthDataDwb[0].depth;
      });
    });
  }

  getTDepthLwf(){
    dbCalls.getTDepthLwf().then((targetData) {
      setState(() {
        _tDepthDataLwf = targetData;
        _tDepthLwf = _tDepthDataLwf[0].Tdepth;
      });
    });
  }

  getTDepthDwb(){
    dbCalls.getTDepthDwb().then((targetData) {
      setState(() {
        _tDepthDataDwb = targetData;
        _tDepthDwb = _tDepthDataDwb[0].Tdepth;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurDepthLwf();
      print("depth: ${_curDepthLwf}");
      getCurDepthDwb();
      print("2: ${_curDepthDwb}");
      getTDepthLwf();
      getTDepthDwb();
    });

    /*setState(() {
      curDarkmode.initDarkmode();
      _darkmode = curDarkmode.getDarkmode();
    });*/
  }

  static const DBROOT = 'http://localhost/Employees/employee_action.php';
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
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Text("Waiting to fill to ${_tDepthLwf}m at 12:00AM", style: TextStyle(color: Colors.white),)
                )]
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
                    //child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE')
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
                  //child: Youtuber(url: 'https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title')
              )
          )
        ],
      )
    );
  }
}