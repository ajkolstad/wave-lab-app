/*************************************************************
 * This file controls the youtube liveview video that is added to the Home
 * screen. The youtube url is sent as an arguement to the youtuber widget and
 * used to connect to the liveview video.
 ************************************************************/
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Controls the live youtube videos
class Youtuber extends StatefulWidget {

  String url; // Youtube url
  Youtuber({this.url});

  YoutuberState createState()=> YoutuberState();

}

// Controls the state of the live youtube videos
class YoutuberState extends State<Youtuber>{

  YoutubePlayerController _controller;
  void play(){
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
      flags: YoutubePlayerFlags(
        autoPlay: false, // Prevents autoplay
        isLive: true, // Starts at live
        mute: true, // Prevents sound
        controlsVisibleAtStart: true, // Shows the play button and scroll bar at start
        disableDragSeek: true,
        enableCaption: true,
        //hideControls: true
      ),
    );
  }

  // Initializes the youtube player
  @override
  void initState() {
    play();
    super.initState();
  }

  // Pauses the video when the video is deactivated
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