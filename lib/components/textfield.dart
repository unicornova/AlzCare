import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  final controller;
  final hintText;
  final obscureText;
  

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child:TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600)
                  ),
                  fillColor: Colors.blueGrey.shade100,
                  filled: true,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey[600])
                ),
              ),
            ) ;
  }
}