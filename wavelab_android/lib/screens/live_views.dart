import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../inheritable_data.dart';
import '../models/darkmode_state.dart';
import '../widgets/play_youtube.dart';

class LiveView extends StatefulWidget{

  LiveViewState createState()=> LiveViewState();

}

class LiveViewState extends State<LiveView> {

  Darkmode darkmodeClass;

  void initDarkmode(){
    if (this.mounted) {
      setState(() {
        final dmodeContainer = StateContainer.of(context);
        darkmodeClass = dmodeContainer.darkmode;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Row(
                //  mainAxisAlignment: MainAxisAlignment.center,
              //),
              lv_intro(),
              LWF_Intro(),
              LWF_Carousel(),
              //LWF_Live(),
              DWB_Intro(),
              DWB_Carousel()
              //DWB_Live(),
            ]
        )
    );
  }

  Widget liveVideo(String url, String title) {
    return Container(
      //height: 250,
      //width: MediaQuery.of(context).size.width * .8,
        child: Column(
            children: [
              Container(
                color: darkmodeClass.darkmodeState ? Colors.grey[800] : Colors.grey[400],
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(title, style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 20))
              ),
              Container(
                child: Youtuber(url: url)
              )
            ]
        )
    );
  }

  Widget lv_intro(){
    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
        padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
        child: Text('Wave View', style: TextStyle(fontSize: 35, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
    );
  }

  Widget LWF_Intro() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Large Wave Flume', style: TextStyle(fontSize: 30, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
            ]
        )
    );
  }

  Widget LWF_Carousel() {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(height: 270, autoPlay: false, enableInfiniteScroll: false, enlargeCenterPage: true),
        items: [
          liveVideo('https://www.youtube.com/watch?v=ciioaETC6wE&feature=emb_title', 'Above Bay 10'),
          liveVideo('https://www.youtube.com/watch?v=V3JsFPQA6YQ&feature=emb_title', 'West Side'),
          liveVideo('https://www.youtube.com/watch?v=VCluhS3RJpI&feature=emb_title', 'North Wall')
        ]
      )
    );
  }

  Widget DWB_Intro() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
        padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Container(
                      child: Text('Directional Wave Basin', style: TextStyle(fontSize: 30, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
                  )
                ],
              )
            ]
        )
    );
  }

  DWB_Carousel() {
    return Container(
        child: CarouselSlider(
            options: CarouselOptions(height: 270, autoPlay: false, enableInfiniteScroll: false, enlargeCenterPage: true),
            items: [
              liveVideo('https://www.youtube.com/watch?v=pHmmBQYVPCI&feature=emb_title', 'North Wall'),
              liveVideo('https://www.youtube.com/watch?v=xNzdOP3ixd4&feature=emb_title', 'West Wall'),
              liveVideo('https://www.youtube.com/watch?v=Z7V0x92PpXU&feature=emb_title', 'Northwest Corner')
            ]
        )
    );
  }
}