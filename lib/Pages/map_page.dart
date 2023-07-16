

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  String locationmsg ='Current location';

  late String lat;
  late String long;

  //String? lat;
  //String? long;

  @override
  void initState() {
    lat='0.00';
    long='0.00';
  super.initState();
}

  Future<Position> getCurrentLocation() async{
    bool serviceEnabled= await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location service disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if(permission== LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission== LocationPermission.denied){
      return Future.error('Location permission denied');
    }
    }

    if(permission== LocationPermission.deniedForever){
      return Future.error('Location permission denied permanently');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _livelocation(){
    LocationSettings locationSettings= const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      );

      Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position){
        lat= position.latitude.toString();
        long= position.longitude.toString();

        setState(() {
          locationmsg= 'Latitude: $lat, Longitude: $long';
        });
      });
  }

  Future<void>openMap(String lat, String long) async{
    String googleURL ='https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrlString(googleURL)
    ? launchUrlString(googleURL)
    : throw 'could not launch $googleURL';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Color.fromARGB(255, 241, 216, 230),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locationmsg, textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
          const SizedBox(height: 20,),

      GestureDetector(
      onTap: (){
          getCurrentLocation().then((value) {
            lat = '${value.latitude}';
            long = '${value.longitude}';

          setState(() {
          locationmsg= 'Latitude: $lat, Longitude: $long';
        });

          _livelocation();
          });
          },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 30.0),
        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(6)),
        child:  Center(child: Text('Get User Location',
        style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16),
        )),
      ),
    ),

    const SizedBox(height: 10,),
    GestureDetector(
      onTap: (){
            openMap(lat,long);
          },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 30.0),
        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(6)),
        child:  Center(child: Text('Open Google Map',
        style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16),
        )),
      ),
    )

      ]),
    ),
  );
}