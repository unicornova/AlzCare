import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String user;
  final String text;
  final String time;

  const Comment({
    required this.user,
    required this.text,
    required this.time,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4)
        ),
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(text),
            const SizedBox(height: 5),

            Row(
              children: [
                Text(user,style: TextStyle(color: Colors.grey[500]),),
                Text(' . ',style: TextStyle(color: Colors.grey[500]),),
                Text(time,style: TextStyle(color: Colors.grey[500]),),
              ],
            )

        ]),
      
    );
  }
}