

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
List <CameraDescription>? cameras;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState(){
    super.initState();
    loadCamera();
    loadmodel();
  }

  loadCamera()async{
    cameras = await availableCameras();
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value){
      if(!mounted){
        return;
      }
      else{
        setState(() {
          cameraController!.startImageStream((imageStream){
           cameraImage = imageStream;
           runModel();
          });
        });
      }
    });
  }

  runModel() async{
    if(cameraImage!= null){
      var predictions = await Tflite.runModelOnFrame(bytesList: cameraImage!.planes.map((plane){
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage!.height,
      imageWidth: cameraImage!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true
      );
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  loadmodel() async{
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt'
      );
  }
  
  signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 216, 230),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 145, 46, 165),
        actions: [IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))],
        title: const Text("Real Time Detection"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(20),
        child: Container(
          height: MediaQuery.of(context).size.height*0.7,
          width: MediaQuery.of(context).size.width,
          child: !cameraController!.value.isInitialized
          ?Container()
          :AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
          child: CameraPreview(cameraController!),),
        ),),
        Text(output,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),)
      ]),
    );
  }
}