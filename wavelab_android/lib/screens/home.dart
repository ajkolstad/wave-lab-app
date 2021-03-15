import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
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
  double _curDepthLwf;
  double _curDepthDwb;
  double _tDepthLwf;
  double _tDepthDwb;
  DateTime curTime = new DateTime.now();
  DateTime dateLwf;
  DateTime dateDwb;
  Darkmode darkmodeClass;
  bool _darkmode;

  void getCurDepthLwf() {
    print("in");
    dbCalls.getCurDepthLwf().then((depthData) {
      if (this.mounted) {
        setState(() {
          _curDepthDataLwf = depthData;
          _curDepthLwf = double.parse(_curDepthDataLwf[0].depth);
        });
      }
    });
  }

  void getCurDepthDwb(){
    dbCalls.getCurDepthDwb().then((depthData) {
      if (this.mounted) {
        setState(() {
          _curDepthDataDwb = depthData;
          _curDepthDwb = double.parse(_curDepthDataDwb[0].depth);
        });
      }
    });
  }

  void getTDepthLwf(){
    dbCalls.getTDepthLwf().then((targetData) {
      if (this.mounted) {
        setState(() {
          _tDepthDataLwf = targetData;
          _tDepthLwf = double.parse(_tDepthDataLwf[0].Tdepth);
          dateLwf = DateTime.parse(_tDepthDataLwf[0].tDate);
        });
      }
    });
  }

  void getTDepthDwb(){
    dbCalls.getTDepthDwb().then((targetData) {
      if (this.mounted) {
        setState(() {
          _tDepthDataDwb = targetData;
          _tDepthDwb = double.parse(_tDepthDataDwb[0].Tdepth);
          dateDwb = DateTime.parse(_tDepthDataDwb[0].tDate);
        });
      }
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
      });
      print("currentTime: ${curTime}");
    }
  }

  void initDarkmode(){
    if (this.mounted) {
      setState(() {
        final dmodeContainer = StateContainer.of(context);
        darkmodeClass = dmodeContainer.darkmode;
        //_darkmode = darkmodeClass.darkmodeState;
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
                            child: Text('Home', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 40))
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
                if(_tDepthDataLwf.length < 1)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Generating target", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                  )
                else if(_tDepthDataLwf[0].isComplete == 1 && _curDepthLwf >= _tDepthLwf)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Filling Complete", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                  )
                else if(_tDepthDataLwf[0].isComplete == 1)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Not Filling", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                  )
                else if(dateLwf.isAfter(curTime))
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text("Waiting to fill to ${_tDepthLwf}m at ${DateFormat('jm').format(dateLwf)}", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                    )
                else
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text("Filling to ${_tDepthLwf}m now", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                  )
              ]

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if(_curDepthLwf == null)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text("Generating current depth", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
                  )
                else
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text("Currently ${_curDepthLwf}m", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
            )]),
          Container(
              width: MediaQuery.of(context).size.width * .9,

              child: CarouselSlider(
              options: CarouselOptions(height: 173, autoPlay: false, enableInfiniteScroll: false, enlargeCenterPage: true),
              items: [
                liveVideo('https://www.youtube.com/watch?v=ciioaETC6wE&feature=emb_title'),
                liveVideo('https://www.youtube.com/watch?v=V3JsFPQA6YQ&feature=emb_title'),
                liveVideo('https://www.youtube.com/watch?v=VCluhS3RJpI&feature=emb_title')
              ])
          )
        ]
        )
    /*Container(
        width: MediaQuery.of(context).size.width * .9,

        child: Container(
                    //margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Youtuber(url: 'https://www.youtube.com/watch?v=ciioaETC6wE')
                )
            )
          ],
        )*/
    );
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Directional Wave Basin", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20.0))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if(_tDepthDataDwb.length < 1)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Filling Complete", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                )
              else if(_tDepthDataDwb[0].isComplete == 1 && _curDepthDwb >= _tDepthDwb)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Filling Complete", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                )
              else if(_tDepthDataDwb[0].isComplete == 1)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Not Filling", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                )
              else if(dateDwb.isAfter(curTime))
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Waiting to fill to ${_tDepthDwb}m at ${DateFormat('jm').format(dateDwb)}", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                )
              else
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("Filling to ${_tDepthDwb}m now", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black),)
                )
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if(_curDepthDwb == null)
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("Generating current depth", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
                )
              else
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("Currently ${_curDepthDwb}m", style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
                )
            ]
          ),
          Container(
              width: MediaQuery.of(context).size.width * .9,

              child: CarouselSlider(
                  options: CarouselOptions(height: 173, autoPlay: false, enableInfiniteScroll: false, enlargeCenterPage: true),
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