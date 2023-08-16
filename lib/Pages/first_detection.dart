import 'dart:io';

import 'package:alzcare/Pages/detection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class FirstDetection extends StatefulWidget {
  const FirstDetection({super.key});

  @override
  State<FirstDetection> createState() => _FirstDetectionState();
}

class _FirstDetectionState extends State<FirstDetection> {
  bool _loading = true;
  late File _image;
  final imagepicker = ImagePicker();
  List predictions =[];

  @override
  void initState(){
    super.initState();
    loadmodel();
  }

  loadmodel() async{
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt'
      );
  }

  detectImage(File img) async{
    var prediction = await Tflite.runModelOnImage(path: img.path,numResults:4,threshold: 0.6 );
    setState(() {
      _loading = false;
      predictions = prediction!;
    });
  }

  @override
  void dispose(){
    super.dispose();
  }


loadimageGallery() async{
  var img = await imagepicker.pickImage(source: ImageSource.gallery);
  if(img == null){return null;}
  else {
    _image = File(img.path);
  }
  detectImage(_image);
}

loadimageCamera() async{
  var img = await imagepicker.pickImage(source: ImageSource.camera);
  if(img == null){return null;}
  else {
    _image = File(img.path);
  }
  detectImage(_image);
}

 signOutUser(){
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 145, 46, 165),
        actions: [IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))],
        title: const Text("Detect Alzheimer's"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 241, 216, 230),
      body: Column(
       
        children: [
          const SizedBox(height: 20,),
          Container(
            height: 180,
            width: 180,
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/brain3.png'),
          ),
          const SizedBox(height: 5,),
          const Text('Machine Learning\n        Classifier', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
          const SizedBox(height: 25,),
          GestureDetector(
          onTap: (){
              // Navigate to another page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
          child: Container(
            height: 50,
            width: 350,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(6)),
            child:  Center(child: Text('Real Time Detection',
            style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16),
            )),
          ),
            ),

            const SizedBox(height: 5,),

            GestureDetector(
              onTap: loadimageCamera,
              child: Container(
                height: 50,
                width: 350,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(6)),
                child:  Center(child: Center(
                  child: Text('Capture',
                  style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16),
                  ),
                )),
              ),
            ),

            const SizedBox(height: 5,),

            GestureDetector(
              onTap:loadimageGallery,
              child: Container(
                height: 50,
                width: 350,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(6)),
                child:  Center(child: Text('Gallery',
                style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16),
                )),
              ),
            ),
            const SizedBox(height: 10,),
            // ignore: dead_code
            _loading==false && predictions.isNotEmpty
            // ignore: dead_code
            ? Container(
              child: Column(
                children: [
                  
                  Container(height: 180, width: 180, child: Image.file(_image),),
                  const SizedBox(height: 10,),
                  Text(predictions[0]['label'].toString(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                  Text('Confidence: '+predictions[0]['confidence'].toStringAsFixed(3),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400)),
                ],
                
              ),
            )
            :Container()
        ],
      ),



    );
  }
}