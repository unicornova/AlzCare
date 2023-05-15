import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 160, 108, 170),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: const BoxDecoration( 
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/brain2.png'),
              ),
              ),
          ),
         
          const Text("AlzCare!",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 25,),)
        ]
        ),
    );
  }
}