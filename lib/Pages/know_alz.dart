import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class KnowAlzPage extends StatefulWidget {
   KnowAlzPage({super.key});

  @override
  State<KnowAlzPage> createState() => _KnowAlzPageState();
}

class _KnowAlzPageState extends State<KnowAlzPage> {
late YoutubePlayerController controller;

  @override

void initState(){
  super.initState();

  const url = 'https://www.youtube.com/watch?v=v5gdH_Hydes&t=16s';

  controller= YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(url)!);
}

void deactivate(){
  controller.pause();



  super.deactivate();
}

void dispose(){
  controller.dispose();


  
  super.dispose();
}

  Widget build(BuildContext context) =>
  YoutubePlayerBuilder(
    player: YoutubePlayer(controller: controller), 
    builder: (context,player)=>Scaffold(
      body: ListView(children: [
        player
      ]),
    )
    );
}
