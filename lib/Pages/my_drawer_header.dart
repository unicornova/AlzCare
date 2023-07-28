import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.only(top: 20.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 229, 176, 240),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(120),),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 85,
            decoration: const BoxDecoration( 
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/brain2.png'),
              ),
              ),
          ),
         
          const Text("AlzCare!",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 25,fontWeight: FontWeight.w500),)
        ]
        ),
    );
  }
}