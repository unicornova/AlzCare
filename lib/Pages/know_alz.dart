import 'package:firebase_auth/firebase_auth.dart';
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
signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext context) =>
  YoutubePlayerBuilder(
    player: YoutubePlayer(controller: controller), 
    builder: (context,player)=>Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 46, 165),
        actions: [IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))],
        title: Text("Know Alzheimer's"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 241, 216, 230),
      body: Center(
        child: Column(
          children: [
            SizedBox(
          width: 300, // adjust the width as needed
          height: 55, // adjust the height as needed
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'What is Alzheimers?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 122, 70, 107),
              ),
            ),
          ),
        ),
        player,
        SizedBox(height: 10,),
        SizedBox(
          width: 300, // adjust the width as needed
          height: 40, // adjust the height as needed
          child: Container(
            
            decoration: BoxDecoration(color: Color.fromARGB(255, 145, 71, 126).withOpacity(0.5), borderRadius:BorderRadius.circular(10), border: Border.all(color: Color.fromARGB(255, 124, 51, 100),width: 2.0) ),
            alignment: Alignment.center,
            child: const Text(
              "Overview About Alzheimer's",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 105, 44, 85),
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: 300,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 1.0,end: 18.0), 
            duration: const Duration(seconds: 3),
            builder:(BuildContext context,double value,Widget? child  ){
              return Text("Alzheimer's disease is a progressive neurological disorder that affects the brain, primarily causing problems with memory, thinking, and behavior.",
              style: TextStyle(color: Color.fromARGB(255, 122, 62, 105), fontWeight: FontWeight.bold,fontSize: value),);
            }
            ),
        ),
        const SizedBox(height: 30,),
        Container(
          width: 300,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 1.0,end: 18.0), 
            duration: const Duration(seconds: 3),
            builder:(BuildContext context,double value,Widget? child  ){
              return Text("It is the most common cause of dementia, a group of brain disorders characterized by a decline in cognitive function and the ability to perform daily activities.",
              style: TextStyle(color: Color.fromARGB(255, 122, 62, 105), fontWeight: FontWeight.bold,fontSize: value),);
            }
            ),
        ),
        const SizedBox(height: 30,),
        Container(
          width: 300,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 1.0,end: 18.0), 
            duration: const Duration(seconds: 3),
            builder:(BuildContext context,double value,Widget? child  ){
              return Text("This App is a guide to know about Alzheimer's, spread awareness and to assist Alzheimer's patients and caregivers ",
              style: TextStyle(color: Color.fromARGB(255, 122, 62, 105), fontWeight: FontWeight.w600 ,fontSize: value, fontStyle: FontStyle.italic),);
            }
            ),
        )


            ],)    
      ),
    )
    );
}
