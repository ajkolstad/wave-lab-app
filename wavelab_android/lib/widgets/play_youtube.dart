import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Youtuber extends StatefulWidget {

  String url;
  Youtuber({this.url});

  YoutuberState createState()=> YoutuberState();

}

class YoutuberState extends State<Youtuber>{

  YoutubePlayerController _controller;
  void play(){
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        isLive: true,
        mute: true,
        controlsVisibleAtStart: true,
        disableDragSeek: true,
        enableCaption: true,
        //hideControls: true
      ),
    );
  }

  @override
  void initState() {
    play();
    super.initState();
  }

  @override
  void deactivate(){
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        bottomActions: <Widget>[
          ProgressBar(isExpanded: false)
        ],
      ),
      builder: (context, player){
        return Container(
          child: player,
        );
      }

    );
  }
}